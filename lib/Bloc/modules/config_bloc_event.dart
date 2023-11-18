part of 'config_bloc.dart';

@immutable
sealed class ConfigBlocEvent {}

class SetupConnection extends ConfigBlocEvent
{
 final String host;
 final String dbName;
 final String userName;
 final String password;

 SetupConnection({required this.host, required this.dbName, required this.userName, required this.password});
}

class CreateNewDatabase extends ConfigBlocEvent
{
  //Use this event to handle the creation of the new database, table and admin user
  final String newDbName;
  final String adminUserName;
  final String adminPassword;
  final String usersTableName;
  final String productsTableName;
  final String salesTableName;
  final String salesItemsTableName;
  final String transactionsTableName;
  final String purchaseItemsTableName;
  final String purchasesTableName;
  final String shortagesTableName;
  final String menuItemsTableName;
  
  //Wrapped this constructor due to length overflowing my screen.
  //My code, my call.
  CreateNewDatabase({
	required this.newDbName, 
	required this.adminUserName, 
	required this.adminPassword, 
	required this.usersTableName, 
	required this.productsTableName, 
	required this.salesTableName, 
	required this.salesItemsTableName, 
	required this.transactionsTableName, 
	required this.purchaseItemsTableName, 
	required this.purchasesTableName,
	required this.shortagesTableName,
	required this.menuItemsTableName
	});
}