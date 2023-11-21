// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutterpos/Auth/AuthManager.dart';
import 'package:flutterpos/Bloc/modules/config_bloc.dart';
import 'package:flutterpos/Helpers/dbhelper.dart';
import 'package:flutterpos/Models/user_datamodel.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';


part 'user_bloc_event.dart';
part 'user_bloc_state.dart';


	//UserBloc is responsible for logins and registrations, and should also handle user logoff. 
	//Helpers: none known, as of present.
	//Data models: user model
	//-> user rights -> Map these based on role? Store as enums in the database with values Y and N?
class UserBloc extends Bloc<UserBlocEvent, UserBlocState> 
{
	Logger logger = Logger();
	final ConfigBloc configBloc;
	String? dbName;
	final String tableName = 'users';
	//Get the configuration file from the config bloc:
	
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
	UserBloc({required this.configBloc}) : super(const UserBlocInitial()) 
	{
		//Initialize the database helper:
		_initDbHelper();
		_initDatabaseName();
		//Event handlers:
		on<Login>((event, emit) async
		{
			try
			{
				//Log a user in:
				emit(const UserBlocInitial());
				final userResult = await dbHelper.ReadSingleEntry(dbName, 'users', 'userName = ? AND password = ?', [event.userName, event.password]);
				if(userResult == null)
				{
					emit(const Authenticationfailure(errorMessage: "Invalid username or password."));
					logger.i("Invalid username or password.");
				}
				else
				{
					bool isValid = AuthManager().ValidatePassword(event.password, userResult['hashedPassword'], userResult['salt']);
					if(!isValid)
					{
					emit(const Authenticationfailure(errorMessage: "Invalid username or password."));
					logger.i("Invalid username or password.");
					}
					else
					{
					emit(AuthenticationSuccess(AuthState: true, AuthMessage: "User ${event.userName} logged in successfully.",currentUser: User.fromDictionary(userResult)));
					logger.i("User logged in successfully.");
					}
				}
			}
			catch(ex)
			{
				logger.e("Something went wrong while during the login process: $ex");
				emit(Authenticationfailure(errorMessage: "Something went wrong while trying to login a user: $ex"));
			}
		});
		on<Logoff>((event, emit) async 
		{
			emit(const AuthenticationSuccess(AuthState: false, AuthMessage: "User logged out successfully.", currentUser: null));
		});
	}
	@override
	Future<void> close() async
	{
		super.close();
		configBloc.close();
	}
}
