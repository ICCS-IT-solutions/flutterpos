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
	//Hardcoded the table name here - might convert it to store in the database config file at a later point.
	Future<UserBlocState> _ExecutePostOpUpdate() async
	{
		final updatedUserData = await dbHelper.ReadEntries(dbName, tableName, null, null);
		final updatedUsers =  updatedUserData?.map((item) => UserDataModel.fromDictionary(item)).toList() ?? [];
		//Emit a new state with the updated data
		return UserBlocState(users: updatedUsers, currentUser: null, isLoading: false, isAuthenticated: false, message: "");
	}

	UserBloc({required this.configBloc}) : super(UserBlocState.Initial()) 
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
				emit(UserBlocState.LoginInitial());
				final userResult = await dbHelper.ReadSingleEntry(dbName, 'users', 'userName = ? AND password = ?', [event.userName, event.password]);
				if(userResult == null)
				{
					emit(const LoginFailed(isAuthenticated: false,errorMsg: "Invalid username or password."));
					logger.i("Invalid username or password.");
				}
				else
				{
					bool isValid = AuthManager().ValidatePassword(event.password, userResult['hashedPassword'], userResult['salt']);
					if(!isValid)
					{
					emit(const LoginFailed(isAuthenticated: false, errorMsg: "Invalid username or password."));
					logger.i("Invalid username or password.");
					}
					else
					{
					emit(LoginSuccess(isAuthenticated: true, successMsg: "User ${event.userName} logged in successfully.", users: [UserDataModel.fromDictionary(userResult)], currentUser: UserDataModel.fromDictionary(userResult)));
					logger.i("User logged in successfully.");
					}
				}
				await _ExecutePostOpUpdate();
			}
			catch(ex)
			{
				logger.e("Something went wrong while during the login process: $ex");
				emit(LoginFailed(isAuthenticated: false,errorMsg: "Something went wrong while trying to login a user: $ex"));
			}
		});
		on<Logoff>((event, emit) async 
		{
			emit(const LogoffSuccess(isAuthenticated: false, successMsg: "User logged out successfully."));
		});
		on<Register>((event, emit) async
		{
			//Register a new user:
			emit(UserBlocState.RegisterInitial());
			await dbHelper.CreateEntry(dbName, 'users', event.userData.toDictionary());
			await _ExecutePostOpUpdate();
			emit(const RegistrationSuccess(successMsg: "User registered successfully."));
		});

		//Streams:
		Stream<UserBlocState> mapRegisterToState(Register event) async*
		{
			try
			{
				//Register a new user:
				dbName = await RetrieveDatabaseName();
				//Should also run a hashing function against the user's cleartext password to create a secure one
				await dbHelper.CreateEntry(dbName, 'users', event.userData.toDictionary());
				await _ExecutePostOpUpdate();
				yield const RegistrationSuccess(successMsg: "User registered successfully.");        
			}
			catch(ex)
			{
				logger.e("Something went wrong while trying to register a new user: $ex");
				yield RegistrationFailed(errorMsg: "Something went wrong while trying to register a new user: $ex");
			}
		}
		Stream<UserBlocState> mapLoginToState(Login event) async*
		{
			try
			{
				dbName = await RetrieveDatabaseName();
				final userResult = await dbHelper.ReadSingleEntry(dbName, 'users', 'userName = ? AND password = ?', [event.userName, event.password]);
				//Now we need to hash the user's entered password and confirm it against the one in the database
				//If they match, we can log the user in, else fail and notify the user.
				if(userResult != null)
				{
					bool isValid = AuthManager().ValidatePassword(event.password, userResult['hashedPassword'], userResult['salt']);
					if(isValid)
					{
					yield LoginSuccess(isAuthenticated: true, successMsg: "User ${event.userName} logged in successfully.", users: const [], currentUser: UserDataModel.fromDictionary(userResult));
					}
					else
					{
						yield const LoginFailed(isAuthenticated: false,errorMsg: "Invalid credentials.");
					}
				}
			//Once we have this, the user can be logged in.
			}
			catch(ex)
			{
				logger.e("Something went wrong while trying to login: $ex");
			}
		}
		Stream<UserBlocState> mapLogoffToState(Logoff event) async*
		{
			yield const LogoffSuccess(isAuthenticated: false, successMsg: "User logged out successfully.");
		}

		Stream<UserBlocState> mapEventToState(UserBlocEvent event) async*
		{
			if (event is Login)
			{
				yield* mapLoginToState(event);
			}
			else if (event is Register)
			{
				yield* mapRegisterToState(event);
			}
		}
	}

	@override
	Future<void> close() async
	{
		super.close();
		configBloc.close();
	}
}
