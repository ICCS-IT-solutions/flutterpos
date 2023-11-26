// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import "package:flutterpos/config/setup.dart";

part 'config_bloc_event.dart';
part 'config_bloc_state.dart';

class ConfigBloc extends Bloc<ConfigBlocEvent, ConfigBlocState> 
{
  Logger logger = Logger();
  final _SetupManager = SetupManager();
  Future<File?> retrieveConfigFile() async
  {
    final configFile = await _SetupManager.RetrieveConfigFile();
    return configFile;
  }
  ConfigBloc() : super(ConfigBlocInitialState()) 
  {
    //Event handlers:
    on<SetupConnection>((event, emit) async
    {
       try
      {
        final configFile = await _SetupManager.CreateDbConnectionConfig
        (
          event.host,
          event.dbName,
          event.userName,
          event.password
        );  
        if(configFile != null)
        {
          emit (ConfigBlocConnectionSuccess(configFile));
        }
        else
        {
          emit (ConfigBlocConnectionFailure("Could not connect to the database server."));
        }
      }
      catch(ex)
      {
        logger.e("Something went wrong while trying to connect to the database server: $ex");
        emit (ConfigBlocConnectionFailure("Something went wrong while trying to connect to the database server: $ex"));
      }
    });
    on<CreateNewDatabase>((event, emit) async
    {
      try
      {
        final configFile = await _SetupManager.RetrieveConfigFile();
        if(configFile != null)
        {
          await _SetupManager.CreateNewDatabase(
            configFile: configFile, 
            newDbName: event.newDbName,
            adminUserName:event.adminUserName,
            adminPassword: event.adminPassword,
            usersTableName: event.usersTableName,
            productsTableName: event.productsTableName,
            salesTableName: event.salesTableName,
            salesItemsTableName: event.salesItemsTableName,
            transactionsTableName: event.transactionsTableName,
			purchaseItemsTableName: event.purchaseItemsTableName,
			purchasesTableName: event.purchasesTableName,
			shortagesTableName: event.shortagesTableName,
			menuItemsTableName: event.menuItemsTableName
            );
          emit (ConfigBlocNewDatabaseSuccess(configFile));
        }
        else
        {
          emit (ConfigBlocNewDatabaseFailure("Could not create the new database."));
        }
      }
      catch(ex)
      {
        logger.e("Something went wrong while trying to create the new database: $ex");
        emit (ConfigBlocNewDatabaseFailure("Something went wrong while trying to create the new database: $ex"));
      }

    });
    //Streams mapping events to states:
    Stream<ConfigBlocState> mapSetupConnectionToState(SetupConnection event) async*
    {
      try
      {
        final configFile = await _SetupManager.CreateDbConnectionConfig
        (
          event.host,
          event.dbName,
          event.userName,
          event.password
        );  
        if(configFile != null)
        {
          yield ConfigBlocConnectionSuccess(configFile);
        }
        else
        {
          yield ConfigBlocConnectionFailure("Could not connect to the database server.");
        }
      }
      catch(ex)
      {
        logger.e("Something went wrong while trying to connect to the database server: $ex");
        yield ConfigBlocConnectionFailure("Something went wrong while trying to connect to the database server: $ex");
      }
      //Close the stream when done with it:
    }

    Stream<ConfigBlocState> mapSetupNewDatabaseToState(CreateNewDatabase event) async*
    {
      try
      {
        final configFile = await _SetupManager.RetrieveConfigFile();
        if(configFile != null)
        {
          await _SetupManager.CreateNewDatabase(
            configFile: configFile, 
            newDbName: event.newDbName,
            adminUserName:event.adminUserName,
            adminPassword: event.adminPassword,
            usersTableName: event.usersTableName,
            productsTableName: event.productsTableName,
            salesTableName: event.salesTableName,
            salesItemsTableName: event.salesItemsTableName,
            transactionsTableName: event.transactionsTableName,
			purchaseItemsTableName: event.purchaseItemsTableName,
			purchasesTableName: event.purchasesTableName,
			shortagesTableName: event.shortagesTableName,
			menuItemsTableName: event.menuItemsTableName
            );
          yield ConfigBlocNewDatabaseSuccess(configFile);
        }
        else
        {
          yield ConfigBlocNewDatabaseFailure("Could not create the new database.");
        }
      }
      catch(ex)
      {
        logger.e("Something went wrong while trying to create the new database: $ex");
        yield ConfigBlocNewDatabaseFailure("Something went wrong while trying to create the new database: $ex");
      }
    }

    @override
    Stream<ConfigBlocState> mapEventToState(ConfigBlocEvent event) async*
    {
      if(event is SetupConnection)
      {
        yield* mapSetupConnectionToState(event);
      }
      else if(event is CreateNewDatabase)
      {
        yield* mapSetupNewDatabaseToState(event);
      }
    }
  }
}
