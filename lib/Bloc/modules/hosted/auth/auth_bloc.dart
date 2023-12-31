
//This file will be used with the hosted mode installation.
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import "package:http/http.dart" as http;

import 'package:bloc/bloc.dart';
import 'package:flutterpos/Bloc/modules/main/config_bloc.dart';
import 'package:flutterpos/Helpers/dbhelper.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

part "auth_event.dart";
part "auth_state.dart";

class AuthBloc extends Bloc<AuthEvent, AuthState>
{
	Logger logger = Logger();
	final apiUrl = "http://localhost/pos-api";
	final ConfigBloc configBloc;
	String? dbName;
	final String tableName = 'users';
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
	
	AuthBloc({required this.configBloc}) : super(AuthInitial())
	{
		//Initialize the database helper:
		_initDbHelper();
		_initDatabaseName();

		//Event handlers
		on<HandleLogin>((event, emit) async
		{
			final userdata = {"user_name": event.username, "password": event.password};
			try
			{
				final response = await http.post(
					Uri.parse(apiUrl),
					body: {'login:', jsonEncode(userdata)},
				);
				if(response.statusCode==200)
				{
					emit(AuthSuccess(message: "Login successful"));
				}
				else
				{
					emit(AuthFailure(errorMessage: "Login failed"));
				}
			}
			catch(ex)
			{
				logger.e("Something went wrong during login: $ex");
			}
		});

		on<HandleLogoff>((event, emit) async
		{

		});

		on<HandleRegister>((event, emit) 
		{
		  
		});
		
		//Triggers a reset password method in the restapi frontend code.
		on<HandleResetPassword>((event, emit) async
		{

		});
	}
}