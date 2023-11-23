import 'package:flutter/material.dart';
import 'package:flutterpos/Bloc/main_app_bloc.dart';
import 'package:flutterpos/Bloc/modules/config_bloc.dart';
import 'package:flutterpos/Bloc/modules/inventory/inventorymanagement_bloc.dart';
import 'package:flutterpos/Bloc/modules/menu_bloc.dart';
import 'package:flutterpos/Bloc/modules/inventory/order_manager_bloc.dart';
import 'package:flutterpos/Bloc/modules/inventory/suppliermanagement_bloc.dart';
import 'package:flutterpos/Bloc/modules/user_bloc.dart';
import 'package:flutterpos/Bloc/modules/user_manager_bloc.dart';
import 'package:flutterpos/Bloc/modules/inventory/productmanagement_bloc.dart';
import "package:flutterpos/Bloc/modules/inventory/shortagemanagement_bloc.dart";
import 'package:flutterpos/Screens/mainapp.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:theme_provider/theme_provider.dart';




/*
Bloc modules:
MainAppBloc : Overall main app state management
ConfigBloc : Configuration management
UserBloc : User management and auth
MenuBloc : Menu management
PaymentBloc : Payment management
ReportingBloc : Reporting management -> pull data from database and prepare reports from it
OrderManagerBloc : Order management -> pull data from database and prepare orders from it
*/
//Execute the main app

//Themes:
final ThemeData lightTheme = ThemeData.light();
final ThemeData darkTheme = ThemeData.dark();
//Custom themes:
final ThemeData myCustomDarkTheme = darkTheme.copyWith(
//custom props here
);
final ThemeData myCustomLightTheme = lightTheme.copyWith(
//custom props here
);
List<AppTheme> appThemes = [
	AppTheme(
		id: "light",
		description: "Light",
		data: lightTheme
	),
	AppTheme(
		id: "dark",
		description: "Dark",
		data: darkTheme
	),
	AppTheme(
		id: "custom_light",
		description: "Custom",
		data: myCustomLightTheme
	),
	AppTheme(
		id: "custom_dark",
		description: "Custom",
		data: myCustomDarkTheme
	)
];

void main() 
{
//Instance these here:
	final ConfigBloc configBloc = ConfigBloc();
	final UserBloc userBloc = UserBloc(configBloc: configBloc);
	final MainAppBloc mainAppBloc = MainAppBloc();
	final MenuBloc menuBloc = MenuBloc(configBloc: configBloc);
	final UserManagerBloc userManagerBloc = UserManagerBloc(configBloc: configBloc);

	//Inventory, shortages, suppliers and orders:
	final OrderManagerBloc orderManagerBloc = OrderManagerBloc(configBloc: configBloc);
	final ProductManagementBloc productManagementBloc = ProductManagementBloc(configBloc: configBloc);
	final ShortageManagementBloc shortageManagementBloc = ShortageManagementBloc(configBloc: configBloc);
	final InventorymanagementBloc inventorymanagementBloc = InventorymanagementBloc(configBloc: configBloc);
	final SupplierManagementBloc supplierManagementBloc = SupplierManagementBloc(configBloc: configBloc);

	runApp(ThemeProvider(
		themes: appThemes,
		saveThemesOnChange: true,
		loadThemeOnInit: true,
		child: MyApp(userManagerBlocInstance: userManagerBloc,
		orderManagerBlocInstance: orderManagerBloc,
		menuBlocInstance: menuBloc,
		userBlocInstance: userBloc,
		configBlocInstance: configBloc,
		mainAppBlocInstance: mainAppBloc,
		inventoryManagementBlocInstance: inventorymanagementBloc,
		supplierManagementBlocInstance: supplierManagementBloc,
		productManagementBlocInstance: productManagementBloc,
		shortageManagementBlocInstance: shortageManagementBloc),
		)
	);
}

//Main app class:
class MyApp extends StatelessWidget
{
	//Create the instances of the various blocs here if needed. 
	//Observation: putting the userbloc and the config bloc here enabled the login to work, and correctly display the main screen.
	final UserBloc userBlocInstance;
	final ConfigBloc configBlocInstance;
	final MainAppBloc mainAppBlocInstance;
	final OrderManagerBloc orderManagerBlocInstance;
	final MenuBloc menuBlocInstance;
	final UserManagerBloc userManagerBlocInstance;
	final InventorymanagementBloc inventoryManagementBlocInstance;
	final SupplierManagementBloc supplierManagementBlocInstance;
	final ProductManagementBloc productManagementBlocInstance;
	final ShortageManagementBloc shortageManagementBlocInstance;

	const MyApp({required this.userManagerBlocInstance ,
	required this.orderManagerBlocInstance, 
	required this.menuBlocInstance, 
	required this.userBlocInstance, 
	required this.configBlocInstance, 
	required this.mainAppBlocInstance, 
	required this.inventoryManagementBlocInstance,
	required this.supplierManagementBlocInstance,
	required this.productManagementBlocInstance,
	required this.shortageManagementBlocInstance,
	super.key});

	@override
	Widget build(BuildContext context)
	{
		return MultiBlocProvider(
			providers: [
				BlocProvider<MainAppBloc>(
				create: (context) => mainAppBlocInstance,
				),
				BlocProvider<ConfigBloc>(
				create: (context) => configBlocInstance,
				),
				BlocProvider<UserBloc>(
				create: (context) => userBlocInstance,
				),
				BlocProvider<MenuBloc>(
				create: (context) => menuBlocInstance,
				),
				BlocProvider<OrderManagerBloc>(
					create:(context) => orderManagerBlocInstance,
				),
				BlocProvider(
					create: (context) => userManagerBlocInstance,
				),
				BlocProvider(
					create: (context) => inventoryManagementBlocInstance,
				),
				BlocProvider(
					create: (context) => supplierManagementBlocInstance,
				),
				BlocProvider(
					create: (context) => productManagementBlocInstance,
				),
				BlocProvider(
					create: (context) => shortageManagementBlocInstance,
				)
			],
			child: ThemeConsumer(
				child: Builder(
					builder: (context) 
					{
						return MaterialApp(
							theme: ThemeProvider.themeOf(context).data,
							home:  MainApp(userManagerBloc: userManagerBlocInstance,
							orderManagerBloc: orderManagerBlocInstance,
							menuBloc: menuBlocInstance, 
							userBloc: userBlocInstance, 
							configBloc: configBlocInstance, 
							mainAppBloc: mainAppBlocInstance,
							inventoryManagementBloc: inventoryManagementBlocInstance,
							supplierManagementBloc: supplierManagementBlocInstance,
							productManagementBloc: productManagementBlocInstance,
							shortageManagementBloc: shortageManagementBlocInstance,),
						);
					}
				)
			),
		);
	}
}
