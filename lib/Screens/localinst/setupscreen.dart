// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:flutterpos/Bloc/modules/main/config_bloc.dart';

class SetupScreen extends StatefulWidget
{
  final ConfigBloc configBloc;
  const SetupScreen({required this.configBloc,super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen>
{
  //Form key
  final _formKey=GlobalKey<FormState>();

  //Connection form controllers
  final hostController = TextEditingController();
  final dbNameController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  //New database creation form controllers
  final newDbNameController = TextEditingController();
  final adminUserNameController = TextEditingController();
  final adminPasswordController = TextEditingController();
  final retypeAdminPasswordController = TextEditingController();

  //Controllers for the new table names:
  final usersTableNameController = TextEditingController();
  final productsTableNameController = TextEditingController();
  final salesTableNameController = TextEditingController();
  final salesItemsTableNameController = TextEditingController();
  final transactionsTableNameController = TextEditingController();
  final purchasesTableNameController = TextEditingController();
  final purchaseItemsTableNameController = TextEditingController();
  final menuItemsTableNameController = TextEditingController();
  final shortagesTableNameController =TextEditingController();

  void HandleCreateConnectionConfig()
  {
    //Check if the form is valid
    if(_formKey.currentState!.validate())
    {
      widget.configBloc.add(SetupConnection(
        host: hostController.text,
        dbName: dbNameController.text,
        userName: userNameController.text,
        password: passwordController.text
      ));
    }
  }
  void HandleCreateNewDatabase()
  {
    //Check if the form is valid
    if(_formKey.currentState!.validate())
    {
      widget.configBloc.add(CreateNewDatabase(
        newDbName: newDbNameController.text,
        adminUserName: adminUserNameController.text,
        adminPassword: adminPasswordController.text,
		//Database tables:
        usersTableName: usersTableNameController.text,
        productsTableName: productsTableNameController.text,
        salesTableName: salesTableNameController.text,
        salesItemsTableName: salesItemsTableNameController.text,
        transactionsTableName: transactionsTableNameController.text,
		purchasesTableName: purchasesTableNameController.text,
		purchaseItemsTableName: purchaseItemsTableNameController.text,
		menuItemsTableName: menuItemsTableNameController.text,
		shortagesTableName: shortagesTableNameController.text
      ));
    }
  }
  //Clear all the controllers and other state props:
  @override
  void dispose()
  {
    hostController.dispose();
    dbNameController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    newDbNameController.dispose();
    adminUserNameController.dispose();
    adminPasswordController.dispose();
    retypeAdminPasswordController.dispose();
    usersTableNameController.dispose();
    productsTableNameController.dispose();
    salesTableNameController.dispose();
    salesItemsTableNameController.dispose();
    transactionsTableNameController.dispose();
	purchasesTableNameController.dispose();
	purchaseItemsTableNameController.dispose();
	menuItemsTableNameController.dispose();

    widget.configBloc.close();
    super.dispose();
  }

  //Initial setup form:
  Widget BuildConnectionForm()
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        //four input text form fields, and one row with two buttons called submit and clear
        child: Column
        (
          children: [
            TextFormField
            (
              controller: hostController,
              decoration: const InputDecoration(
                labelText: "Host",
              ),
              validator: (value) => value!.isEmpty ? "Please enter a host IP address" : null,
            ),
            TextFormField
            (
              controller: dbNameController,
              decoration: const InputDecoration(
                labelText: "Database name",
              ),
              validator: (value) => value!.isEmpty ? "Please enter a database name" : null,
            ),
            TextFormField
            (
              controller: userNameController,
              decoration: const InputDecoration(
                labelText: "User name",
              ),
              validator: (value) => value!.isEmpty ? "Please enter a user name" : null,
            ),
            TextFormField
            (
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
              validator: (value) => value!.isEmpty ? "Please enter a password" : null,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: HandleCreateConnectionConfig,
                  child: const Text("Submit"),
    
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: ()
                  {
                    hostController.clear();
                    dbNameController.clear();
                    userNameController.clear();
                    passwordController.clear();
                  },
                  child: const Text("Clear"),
                )
              ]
            )
          ]
        )
      ),
    );
  }

  //Database and user creation form:
  Widget BuildCreateNewDbForm()
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: newDbNameController,
              decoration: const InputDecoration(
                labelText: "New database name"
              ),
              validator: (value) => value!.isEmpty ? "Please enter the name for the new database" : null
            ),
            TextFormField(
              controller: adminUserNameController,
              decoration: const InputDecoration(
                labelText: "Admin user name"
              ),
              validator: (value) => value!.isEmpty ? "Please enter an admin user name" : null
            ),
            TextFormField(
              controller: adminPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Admin password"
              ),
              validator: (value) => value!.isEmpty ? "Please enter an admin password" : null
            ),
            TextFormField(
              controller: retypeAdminPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Retype admin password"
              ),
              validator: (value) 
              {
                value!.isEmpty ? "Please retype the admin password" : null;
                if(value != adminPasswordController.text)
                {
                  return "Passwords do not match";
                }
                else
                {
                  return null;
                }
              }
            ),
            const SizedBox(height: 10),
            const Text("Table names:"),
            //Add text fields for the new database table name controllers:
            TextFormField(
              controller: usersTableNameController,
              decoration: const InputDecoration(
                labelText: "Users table name"
              ),
              validator: (value) => value!.isEmpty ? "Please enter the users table name" : null,              
            ),
            TextFormField(
              controller: productsTableNameController,
              decoration: const InputDecoration(
                labelText: "Products table name"
              ),
              validator: (value) => value!.isEmpty ? "Please enter the transactions table name" : null,              
            ),
            TextFormField(
              controller: salesTableNameController,
              decoration: const InputDecoration(
                labelText: "Sales table name"
              ),
              validator: (value) => value!.isEmpty ? "Please enter the sales table name" : null,              
            ),
            TextFormField(
              controller: salesItemsTableNameController,
              decoration: const InputDecoration(
                labelText: "Sales items table name"
              ),
              validator: (value) => value!.isEmpty ? "Please enter the sales items table name" : null,              
            ),
            TextFormField(
              controller: transactionsTableNameController,
              decoration: const InputDecoration(
                labelText: "Transactions table name"
              ),
              validator: (value) => value!.isEmpty ? "Please enter the transactions table name" : null,
            ),
			TextFormField(
			  controller: purchaseItemsTableNameController,
			  decoration: const InputDecoration(
				  label: Text("Purchase items table name")
			  ),
			  validator: (value) => value!.isEmpty ? "Please enter the purchase items table name" : null,
			),
			TextFormField(
				controller: purchasesTableNameController,
				decoration: const InputDecoration(
					label: Text("Purchases table name")
				),
				validator: (value) => value!.isEmpty ? "Please enter the purchases table name" : null,
			),
			TextFormField(
				controller: menuItemsTableNameController,
				decoration: const InputDecoration(
					label: Text("Menu items table name")
				),
				validator: (value) => value!.isEmpty ? "Please enter the menu items table name" : null,
			),
			TextFormField(
				controller: shortagesTableNameController,
				decoration: const InputDecoration(
					label: Text("Shortages table name")
				),
				validator: (value) => value!.isEmpty ? "Please enter the shortages table name" : null,
			),
			const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: HandleCreateNewDatabase,
                  child: const Text("Submit"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: (){
                    newDbNameController.clear();
                    adminUserNameController.clear();
                    adminPasswordController.clear();
                    retypeAdminPasswordController.clear();
                  },
                  child: const Text("Clear"),
                )
              ],
            )
          ],
        )
        ,
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
		appBar: AppBar
		(
			title: const Text("Setup"),
		),
		body: SingleChildScrollView(
			child: BlocBuilder<ConfigBloc, ConfigBlocState>(
				builder: (context, state)
				{
					if(state is ConfigBlocConnectionSuccess)
					{
						return BuildCreateNewDbForm();
					}
						else if(state is ConfigBlocConnectionFailure)
					{
						return BuildConnectionForm();
					}
						else if(state is ConfigBlocNewDatabaseSuccess)
					{
						return const Center(child: Text("If you are seeing this, it means your app is working properly."));
					}
						else if(state is ConfigBlocNewDatabaseFailure)
					{
			
						return BuildCreateNewDbForm();
					}
					else
					{
						return BuildConnectionForm();
					}
				}),
			)
		);
	}
}