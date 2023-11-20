
// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutterpos/Helpers/dbhelper.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../config/configmgr.dart';

part "configmanagerevent.dart";
part "configmanagerstate.dart";

class ConfigManagerBloc extends Bloc<ConfigManagerBlocEvent, ConfigManagerBlocState> 
{
	Logger logger = Logger();
	final MysqlDbHelper _dbHelper = MysqlDbHelper();
	final _ConfigMgr = ConfigManager();
	Future<File?> retrieveConfigFile() async
	{
		final configFile = await _ConfigMgr.RetrieveConfigFile();
		return configFile;
	}
	ConfigManagerBloc() : super(const ConfigManagerBlocInitialState()) 
	{
		on<ConnectToServer>((event,emit) async
		{
			String statusMsg;
			emit (const ConfigManagerBlocInitialState());
			//Use the configuration file returned, deserialise it and connect to the server using the dbhelper.
			final configFile = await retrieveConfigFile();
			if(configFile != null)
			{
				final connection = await _dbHelper.CreateConnection(configFile);
				if(connection != null)
				{
					statusMsg = "Connected to the database server.";
					emit (ConfigManagerBlocConnectionSuccessState(ResponseMessage: statusMsg));
				}
				else
				{
					statusMsg = "Could not connect to the database server.";
					emit (ConfigManagerBlocConnectionFailureState(ResponseMessage: statusMsg));
				}
			}
			else
			{
				statusMsg = "Could not find the configuration file.";
				emit (ConfigManagerBlocConnectionFailureState(ResponseMessage: statusMsg));
			}
		});
	}

}