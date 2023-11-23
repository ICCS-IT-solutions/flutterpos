// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutterpos/Models/shortage_datamodel.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import 'package:flutterpos/Helpers/dbhelper.dart';
import 'package:flutterpos/Bloc/modules/config_bloc.dart';

part "shortagemanagement_event.dart";
part "shortagemanagement_state.dart";

class ShortageManagementBloc extends Bloc<ShortageManagementBlocEvent, ShortageManagementBlocState> 
{
	Logger logger = Logger();
	final ConfigBloc configBloc;
	String? dbName;
	final String tableName = 'shortages';
	late MysqlDbHelper dbHelper;

	Future<MysqlDbHelper?> initDbHelper() async
	{
		try
		{
			File? configFile = await configBloc.retrieveConfigFile();
			if(configFile != null)
			{
			return MysqlDbHelper.withConfigFile(configFile);
			}
			else
			{
			logger.e("No config file found");
			return null;
			}
		}
		catch(ex)
		{
			logger.e("Something went wrong while trying to initialize the database helper: $ex");
			return null;
		}
	}

	Future<void> _initDbHelper() async
	{
		dbHelper = await initDbHelper() ?? MysqlDbHelper();
	}
		Future<void> _initDatabaseName() async
	{
		dbName = await RetrieveDatabaseName();
	}
		Future<String?> RetrieveDatabaseName() async
	{
		try
		{
			final configFile = await configBloc.retrieveConfigFile();
			if(configFile != null)
			{
			//json decode the file
			final jsonConfig = jsonDecode(configFile.readAsStringSync());
			return jsonConfig['dbName'];
			}
			else
			{
			return null;
			}    
		}
		catch(ex)
		{
			logger.e("Something went wrong while trying to retrieve the database name: $ex");
			return null;
		}
	}

	ShortageManagementBloc({required this.configBloc}) : super(ShortageManagementBlocInitial())
	{
		_initDbHelper();
		_initDatabaseName();

		on<LoadShortages>((event, emit) async
		{
			emit(ShortageManagementBlocInitial());
			final shortagesData = await dbHelper.ReadEntries(dbName, tableName, null, null);
			final shortages = shortagesData?.map((item)=> Shortage.fromDictionary(item)).toList() ?? [];
			emit(ShortageManagementBlocSuccess(shortages: shortages, shortage: null));
		});

		on<AddShortage>((event, emit) async
		{
			emit(ShortageManagementBlocInitial());
			final shortage = event.shortage;
			final shortageData = shortage.toDictionary();
			final result = await dbHelper.CreateEntry(dbName, tableName, shortageData);
			if (result == 0)
			{
				emit(ShortageManagementBlocSuccess(shortages: const [], shortage: shortage));
			}
			else
			{	
				//Something went wrong here.
				emit(const ShortageManagementBlocFailure());
			}
		});
	}
}