// ignore_for_file: non_constant_identifier_names

import "dart:convert";
import "dart:io";

import 'package:flutter/material.dart';
import "package:flutterpos/Bloc/modules/config_bloc.dart";
import "../Bloc/main_app_bloc.dart";
import "../Bloc/modules/menu_bloc.dart";
import "loginscreen.dart";
import "setupscreen.dart";
import "mainscreen.dart";
import "../Bloc/modules/user_bloc.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class MainApp extends StatelessWidget 
{
	final UserBloc userBloc;
	final ConfigBloc configBloc;
	final MainAppBloc mainAppBloc;
	final MenuBloc menuBloc;
	const MainApp({required this.menuBloc,required this.userBloc, required this.configBloc, required this.mainAppBloc, super.key});
	
	Future<File?> initConfigFile() async
	{
		return await configBloc.retrieveConfigFile();
	}


	//Need to redevelop this build method to achieve two objectives: Check if the config file is present and that two props are true:
	//initialSetupComplete and isSetupComplete. 
	//These are encoded as json KV pairs where the values are strings, so a value of "true" must be interpreted as the boolean true state.
	//in the case of initialSetupComplete, tell the setup screen to procced to the database creation stage.
	@override
	Widget build(BuildContext context)
	{
		return FutureBuilder<File?>(
		future: initConfigFile(),
		builder: (context, AsyncSnapshot<File?> snapshot) 
		{
			if(snapshot.connectionState==ConnectionState.waiting)
			{
			return const Center(
				child:Column(
				children: [
					CircularProgressIndicator(),
					//Add some space between these two for a better layout:
					SizedBox(height: 10),
					Text("Loading...")
				]
				)
			);
			}
			else if (snapshot.hasError)
			{
				return Text("Something went wrong while trying to load the configuration: ${snapshot.error}");
			}
			else if (snapshot.hasData)
			{
				final configFile = snapshot.data!;
				final Map<String,dynamic> config = jsonDecode(configFile.readAsStringSync());
				if(config["initialSetupComplete"] == "true" && config["isSetupComplete"] == "true")
				{
					return BlocBuilder<UserBloc,UserBlocState>(
					builder: (context, state)
					{
						if(state is LoginSuccess && state.isAuthenticated)
						{
						return MainScreen(menuBloc: menuBloc,userBloc: userBloc);
						}
						else
						{
						//Will need to see the configfile and look for the two props that control the setup state, but that's later's job...
						return LoginScreen(userBloc: userBloc);
						}
					}
					);
				}
				else
				{
					return SetupScreen(configBloc: configBloc);
				}
			}
			else
			{
			return const Center(
				child: Text("Something went wrong during the initial configuration load."));
			}
		});
	}
}