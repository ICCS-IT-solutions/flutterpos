import 'package:flutter/material.dart';
import 'package:flutterpos/Bloc/main_app_bloc.dart';
import 'package:flutterpos/Bloc/modules/config_bloc.dart';
import 'package:flutterpos/Bloc/modules/menu_bloc.dart';
import 'package:flutterpos/Bloc/modules/user_bloc.dart';
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
	final UserBloc userBloc = UserBloc(configBloc: ConfigBloc());
	final ConfigBloc configBloc = ConfigBloc();
	final MainAppBloc mainAppBloc = MainAppBloc();
	final MenuBloc menuBloc = MenuBloc(configBloc: ConfigBloc());
	runApp(ThemeProvider(
		themes: appThemes,
		saveThemesOnChange: true,
		loadThemeOnInit: true,
		child: MyApp(menuBlocInstance: menuBloc, userBlocInstance: userBloc, configBlocInstance: configBloc, mainAppBlocInstance: mainAppBloc),
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
	final MenuBloc menuBlocInstance;
	const MyApp({required this.menuBlocInstance, required this.userBlocInstance, required this.configBlocInstance, required this.mainAppBlocInstance, super.key});

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
				)
			],
			child: ThemeConsumer(
				child: Builder(
					builder: (context) 
					{
						return MaterialApp(
							theme: ThemeProvider.themeOf(context).data,
							home:  MainApp(menuBloc: menuBlocInstance, userBloc: userBlocInstance, configBloc: configBlocInstance, mainAppBloc: mainAppBlocInstance),
						);
					}
				)
			),
		);
	}
}
