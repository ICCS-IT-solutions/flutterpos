import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterpos/Models/supplier_datamodel.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../Helpers/dbhelper.dart';
import 'config_bloc.dart';
import 'dart:convert';
import 'dart:io';

part 'suppliermanagement_event.dart';
part 'suppliermanagement_state.dart';

class SupplierManagementBloc extends Bloc<SupplierManagementBlocEvent, SupplierManagementBlocState>
{
	Logger logger = Logger();
	final ConfigBloc configBloc;
	String? dbName;
	final String tableName = "suppliers";
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

	SupplierManagementBloc({required this.configBloc}) : super(SupplierManagementBlocInitial()) 
	{
		_initDbHelper();
		_initDatabaseName();

		on<LoadSuppliers>((event, emit) async
		{
			emit(SupplierManagementBlocLoading());
			final suppliersData = await dbHelper.ReadEntries(dbName, tableName, null, null);
			final suppliers = suppliersData?.map((item) => Supplier.fromDictionary(item)).toList() ?? [];
			emit(SupplierManagementBlocSuccess(suppliers: suppliers, supplier: null));
		});
	}
}