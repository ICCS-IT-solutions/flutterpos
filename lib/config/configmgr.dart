// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class ConfigManager
{
	String? DbConfigFilePath;
	Future<String> GetUserHomepath() async
	{
		var directory = await getApplicationDocumentsDirectory();
		return directory.path;
	}
	Future<File?> RetrieveConfigFile() async
	{
		Logger logger = Logger();
		try
		{
			DbConfigFilePath = await GetUserHomepath();
			if(File("$DbConfigFilePath/config.json").existsSync())
			{
				return File("$DbConfigFilePath/config.json");
			}
			else
			{
				logger.e("Database config file not found.");
				return null;
			}
		}
		catch(ex)
		{
			logger.e("Something went wrong while trying to retrieve the database config file: $ex");
			return null;
		}
	}
}