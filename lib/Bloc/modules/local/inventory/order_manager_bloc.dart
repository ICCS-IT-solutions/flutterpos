// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutterpos/Helpers/dbhelper.dart';
import 'package:flutterpos/Models/order_datamodel.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import 'package:flutterpos/Bloc/modules/main/config_bloc.dart';

part 'order_manager_bloc_event.dart';
part 'order_manager_bloc_state.dart';

//Expected uses: ordering of products and keeping track of stock levels.
class OrderManagerBloc extends Bloc<OrderManagerBlocEvent, OrderManagerBlocState> 
{
	Logger logger = Logger();
	final ConfigBloc configBloc;
	String? dbName;
	final String tableName = 'orders';
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
	OrderManagerBloc({required this.configBloc}) : super(const OrderManagerBlocInitial()) 
	{
		_initDbHelper();
		_initDatabaseName();
		on<LoadOrders>((event, emit) async
		{
			emit(const OrderManagerBlocInitial());
			final ordersData = await dbHelper.ReadEntries(dbName, tableName, null, null);
			final orders = ordersData?.map((item)=> Order.fromDictionary(item)).toList() ?? [];
			emit(OrderManagerBlocSuccess(orders: orders, order: null));
		});
		on<AddOrder>((event, emit) async
		{
			emit(const OrderManagerBlocInitial());
			final order = event.newOrder;
			final orderData = order.toDictionary();
			final result = await dbHelper.CreateEntry(dbName, tableName, orderData);
			if (result == 0)
			{
				emit(OrderManagerBlocSuccess(orders: const [], order: order));
			}
			else
			{	
				//Something went wrong here.
				emit(const OrderManagerBlocFailure());
			}
		});
	}
}
