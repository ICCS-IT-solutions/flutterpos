// ignore_for_file: non_constant_identifier_names

import "dart:convert";
import "dart:io";

import "package:flutter_bloc/flutter_bloc.dart";
import 'package:flutter/material.dart';
import "package:flutterpos/Bloc/modules/config_bloc.dart";
import "package:flutterpos/Bloc/modules/inventory/inventorymanagement_bloc.dart";
import "package:flutterpos/Bloc/modules/inventory/productmanagement_bloc.dart";
import "package:flutterpos/Bloc/modules/inventory/suppliermanagement_bloc.dart";
import "package:flutterpos/Bloc/modules/user_manager_bloc.dart";

import "../Bloc/main_app_bloc.dart";
import "../Bloc/modules/menu_bloc.dart";
import '../Bloc/modules/inventory/order_manager_bloc.dart';
import "../Bloc/modules/user_bloc.dart";

import "loginscreen.dart";
import "setupscreen.dart";
import "mainscreen.dart";


class MainApp extends StatelessWidget 
{
	final UserBloc userBloc;
	final ConfigBloc configBloc;
	final MainAppBloc mainAppBloc;
	final OrderManagerBloc orderManagerBloc;
	final UserManagerBloc userManagerBloc;
	final MenuBloc menuBloc;
	final InventorymanagementBloc inventoryManagementBloc;
	final SupplierManagementBloc supplierManagementBloc;
	final ProductManagementBloc productManagementBloc;

	const MainApp({required this.userManagerBloc, 
	required this.orderManagerBloc, 
	required this.menuBloc, 
	required this.userBloc, 
	required this.configBloc, 
	required this.mainAppBloc,
	required this.inventoryManagementBloc,
	required this.supplierManagementBloc,
	required this.productManagementBloc,
	super.key});
	
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
						if(state is AuthenticationSuccess && state.isAuthenticated)
						{
						return MainScreen(userManagerBloc: userManagerBloc,
							orderManagerBloc: orderManagerBloc,
							menuBloc: menuBloc,	
							userBloc: userBloc,
							inventoryManagementBloc: inventoryManagementBloc,
							supplierManagementBloc: supplierManagementBloc,
							productManagementBloc: productManagementBloc);
						}
						else
						{
						//Will need to see the configfile and look for the two props that control the setup state, but that's later's job...
						return LoginScreen(userManagerBloc: userManagerBloc, userBloc: userBloc);
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