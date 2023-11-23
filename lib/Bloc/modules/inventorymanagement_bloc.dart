// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutterpos/Models/inventoryitem_datamodel.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../Helpers/dbhelper.dart';
import 'config_bloc.dart';

part 'inventorymanagement_event.dart';
part 'inventorymanagement_state.dart';

class InventorymanagementBloc extends Bloc<InventorymanagementBlocEvent, InventorymanagementBlocState>
{
	Logger logger = Logger();
	final ConfigBloc configBloc;
	String? dbName;
	final String tableName = "inventory";
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
	
	InventorymanagementBloc({required this.configBloc}) : super(InventorymanagementInitial()) 
	{
		_initDbHelper();
		_initDatabaseName();

		on<LoadInventory>((event, emit) async
		{
			emit(InventorymanagementLoading());
			final inventoryItemData = await dbHelper.ReadEntries(dbName, tableName, null, null);
			final inventoryItems = inventoryItemData?.map((item) => InventoryItem.fromDictionary(item)).toList() ?? [];
			emit(InventorymanagementSuccess(inventory: inventoryItems, inventoryItem: null));
		});
	}
}
