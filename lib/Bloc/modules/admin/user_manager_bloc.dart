// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutterpos/Bloc/modules/config_bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import 'package:flutterpos/Helpers/dbhelper.dart';
import 'package:flutterpos/Models/localuser_datamodel.dart';

part 'user_manager_bloc_event.dart';
part 'user_manager_bloc_state.dart';

class UserManagerBloc extends Bloc<UserManagerBlocEvent, UserManagerBlocState> 
{
	Logger logger = Logger();
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
	UserManagerBloc({required this.configBloc}) : super(UserManagerBlocInitial()) 
	{
		//Initialize the database helper:
		_initDbHelper();
		_initDatabaseName();
		//Load users, register new user, delete user, edit user etc.
		on<LoadUsers>((event, emit) async
		{	
			emit(UserManagerBlocLoading(loadingMsg: "Loading user data, please be patient"));
			final rawUserData = await dbHelper.ReadEntries(dbName, tableName, null, null);
			final users = rawUserData?.map((item) => LocalUser.fromDictionary(item)).toList() ?? [];
			emit(UserManagerBlocSuccess(registeredUsers: users, AuthState: true, SuccessMessage: "User data loaded successfully"));
		});
		on<EditUser>((event, emit) 
		{
			//Noting to do yet.
		});

		on<Register>((event, emit) async
		{
			emit(UserManagerBlocInitial());
			final result = await dbHelper.CreateEntry(dbName, tableName, event.userData.toDictionary());
			if(result == 0)
			{
				emit(UserManagerBlocSuccess(registeredUsers: [], AuthState: false, SuccessMessage: "User registration successful"));
			}
			//Something went wrong here
			else
			{
				emit(UserManagerBlocFailure(errorMessage: "Something went wrong while registering a new user"));
			}
		});
		on<DeleteUser>((event, emit) async 
		{
			emit(UserManagerBlocInitial());
			final result = await dbHelper.DeleteEntry(dbName, tableName, "userName = ?",[event.userData.toDictionary()]);
			if(result == 0)
			{
				emit(UserManagerBlocSuccess(registeredUsers: [], AuthState: false, SuccessMessage: "User deleted successfully"));
			}
			else
			{
				emit(UserManagerBlocFailure(errorMessage: "Something went wrong while deleting the user."));
			}
		});
	}
}
