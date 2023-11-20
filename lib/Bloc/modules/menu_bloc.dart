// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../Helpers/dbhelper.dart';
import '../../Models/menuitem_datamodel.dart';
import 'config_bloc.dart';

part 'menu_bloc_event.dart';
part 'menu_bloc_state.dart';

//Like in the UserBloc, we need to use the database helper to handle these events and make sure they fire correctly.
class MenuBloc extends Bloc<MenuBlocEvent, MenuBlocState> 
{
	//Menu items are based on these, without certain props. 
	//Maybe set up a table in my db for these, that has no quantities but inserts and deletes based on the 
	//products unit quantity being higher than zero, and if zero, for drinks use the fluid quantity too.
	
	//For now I am going to hardcode in the name of the database table(s) we are using:
	Logger logger = Logger();
	final ConfigBloc configBloc;
	String? dbName;
	final String tableName = 'menu_items'; 

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
	//Hardcoded the table name here - might convert it to store in the database config file at a later point.
	Future<MenuBlocState> _ExecutePostOpUpdate() async
	{
		final updatedMenuItemData = await dbHelper.ReadEntries(dbName, tableName, null, null);
		final updatedMenuItems =  updatedMenuItemData?.map((item) => MenuItem.fromDictionary(item)).toList() ?? [];
		//Emit a new state with the updated data
		return MenuBlocSuccess(menuItems: updatedMenuItems, currentMenuItem: null, isLoading: false, hasFinishedLoading: true, message: "");
	}
	MenuBloc({required this.configBloc}) : super(MenuBlocInitial()) 
	{
		_initDbHelper();
		_initDatabaseName();
		on<AddMenuItem>((event, emit) async
		{
			emit(MenuBlocLoading());
			await dbHelper.CreateEntry(dbName, tableName, event.menuItem.toDictionary());
			emit(await _ExecutePostOpUpdate());
		});
		on<UpdateMenuItem>((event, emit) async
		{	
			await dbHelper.UpdateEntry(dbName, tableName, event.menuItem.toDictionary(), "menuitem_name = ?", [event.menuItem.menuItemName]);
			emit(await _ExecutePostOpUpdate());
		});
		on<DeleteMenuItem>((event, emit) async
		{
			await dbHelper.DeleteEntry(dbName, tableName, "menuitem_name = ?", [event.menuItem.menuItemName]);
			emit(await _ExecutePostOpUpdate());
		});
		on<LoadMenuItems>((event, emit) async 
		{
			//emit an initial state:
			emit(MenuBlocLoading());
			//Execute a ReadEntries query:
			final menuItemData = await dbHelper.ReadEntries(dbName, tableName, null, null);
			final menuItems =  menuItemData?.map((item) => MenuItem.fromDictionary(item)).toList() ?? [];
			//Emit a new state with the updated data:
			emit(MenuBlocSuccess(menuItems: menuItems, currentMenuItem: null, isLoading: false, hasFinishedLoading: true, message: ""));	
		});
	}
}
