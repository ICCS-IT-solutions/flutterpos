// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutterpos/Helpers/dbhelper.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../Models/product_datamodel.dart';
import 'config_bloc.dart';

part 'order_manager_bloc_event.dart';
part 'order_manager_bloc_state.dart';

//Expected uses: ordering of products and keeping track of stock levels.
class OrderManagerBloc extends Bloc<OrderManagerBlocEvent, OrderManagerBlocState> 
{
	Logger logger = Logger();
	final ConfigBloc configBloc;
	String? dbName;
	final String tableName = 'products';
	late MysqlDbHelper dbHelper;

	Future<OrderManagerBlocState> _ExecutePostOpUpdate() async
	{
		final updateProductData = await dbHelper.ReadEntries(dbName, tableName, null, null);
		final updatedProducts =  updateProductData?.map((item) => Product.fromDictionary(item)).toList() ?? [];
		//Emit a new state with the updated data
		return OrderManagerBlocState(products: updatedProducts, product: null, IsLoading: false, IsSuccessful: true, IsFailure: false, response: "Update successful");
	}

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
	OrderManagerBloc({required this.configBloc}) : super(const OrderManagerBlocInitial()) 
	{
		_initDbHelper();
		_initDatabaseName();
		on<SubmitOrder>((event, emit) 
		{
			//Todo: Build out the event handler responsible for the user's submission of orders. 
			//The event handler should be triggered by a button next to (or in the same tile as) each item.
		});
		on<LoadProducts>((event, emit) async
		{
			emit(const OrderManagerBlocLoading(loadingMsg: "Loading data... please be patient."));
			//Execute a query against the database to read all entries in the table.
			final productsData = await dbHelper.ReadEntries(dbName, tableName, null, null);
			final products =  productsData?.map((item) => Product.fromDictionary(item)).toList() ?? [];
			emit(OrderManagerBlocSuccess(successMsg: "Products loaded successfully.", loadedProducts: products));
		});
		on<AddProduct>((event, emit) async
		{
			final updatedState = await _ExecutePostOpUpdate();
			emit(updatedState);
		});
	}
}
