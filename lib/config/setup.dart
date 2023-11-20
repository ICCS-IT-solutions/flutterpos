// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:mysql1/mysql1.dart';
import 'package:path_provider/path_provider.dart';

class SetupManager
{
	bool IsSetupComplete = false;
	bool initialSetupComplete = false;
	//

	/// The function `GetUserHomepath` returns the path to the user's home directory.
	/// 
	/// Returns:
	///   The method is returning a `Future` object that will eventually resolve to a `String` representing
	/// the user's home path.
	Future<String> GetUserHomepath() async
	{
		var directory = await getApplicationDocumentsDirectory();
		return directory.path;
	}

	String dbConfigFilePath = "";
	MySqlConnection? _connection;

	/// The function `CreateDbConnectionConfig` creates a database connection configuration file, writes
	/// the configuration to the file, and tests the database connection.
	/// 
	/// Args:
	///   host (String): The host parameter is the hostname or IP address of the database server.
	///   dbName (String): The `dbName` parameter is the name of the database that you want to connect to.
	///   userName (String): The `userName` parameter is a string that represents the username for the
	/// database connection.
	///   password (String): The "password" parameter is a string that represents the password for the
	/// database user.
	/// 
	/// Returns:
	///   The function `CreateDbConnectionConfig` returns a `Future<File?>`.
	Future<File?> CreateDbConnectionConfig(String host, String dbName, String userName, String password) async
	{ 
		Logger logger = Logger();
		dbConfigFilePath = await GetUserHomepath();
		try
		{
			String dbConfigJson;
			final File configFile = File("$dbConfigFilePath/config.json");
			Map<String, String> dbConfig = 
			{
				"host": host,
				"dbName": dbName,
				"userName": userName,
				"password": password,
				"initialSetupComplete" : initialSetupComplete.toString(),
				"isSetupComplete" : IsSetupComplete.toString()
			};
			//Encode the map to json:
			dbConfigJson = jsonEncode(dbConfig);
			//Write the json to a file:
			if(!configFile.existsSync())
			{
				Directory(configFile.parent.path).createSync(recursive: true);
				configFile.createSync();
				logger.i("Database config file created.");
			}

			await configFile.writeAsString(dbConfigJson);
			logger.i("Configuration written to file.");

			ConnectionSettings testSettings = ConnectionSettings(
				host: host,
				port: 3306,
				user: userName,
				password: password,
				db: dbName
				);
			_connection = await MySqlConnection.connect(testSettings);
			if (_connection != null)
			{
				logger.i("Database connection successful.");
				//Return this only if the connection state is true/valid.
				await _connection!.close();
				initialSetupComplete = true;
				Map<String, String> updatedDbConfig =
				{
				"host": host,
				"dbName": dbName,
				"userName": userName,
				"password": password,
				"initialSetupComplete" : initialSetupComplete.toString(),
				"isSetupComplete" : IsSetupComplete.toString()
				};
				configFile.writeAsStringSync(jsonEncode(updatedDbConfig));
				return configFile;
			}
			else
			{
				logger.e("Database connection failed.");
				return null;
			}
		}
		catch(ex)
		{
		logger.e("Something went wrong while trying to write the database configuration file: $ex");
		return null;
		}
	}

	/// The function `CreateDbAdminUser` creates a new database, table, user, and grants privileges to the
	/// user using the provided configuration file and user details.
	/// 
	/// Args:
	///   configFile (File): A File object representing the configuration file that contains the database
	/// connection details.
	///   newDbName (String): The name of the new database that will be created.
	///   adminUserName (String): The adminUserName parameter is a String that represents the username for
	/// the database admin user.
	///   adminPassword (String): The `adminPassword` parameter is a string that represents the password for
	/// the admin user that will be created in the database.
	/// 
//Wrapped this method because the args list is super long.
Future<void> CreateNewDatabase({
	File? configFile, 
	String? newDbName, 
	String? adminUserName, 
	String? adminPassword,
	String? usersTableName, 
	String? productsTableName, 
	String? salesTableName, 
	String? salesItemsTableName, 
	String? transactionsTableName, 
	String? shortagesTableName, 
	String? purchasesTableName, 
	String? purchaseItemsTableName,
	String? menuItemsTableName}) async 
	{
		usersTableName ??= "users";
		productsTableName ??= "products";
		salesTableName ??= "sales";
		salesItemsTableName ??= "sales_items";
		transactionsTableName ??= "transactions";
		shortagesTableName ??= "shortages";
		purchasesTableName ??= "purchases";
		purchaseItemsTableName ??= "purchase_items";
		menuItemsTableName ??= "menu_items";
		Logger logger = Logger();
		try
		{
		//Connect to the database using the details from the configuration file located at the provided path:
		//Read in the configuration and decode it into a map:
		//First see whether this file exists: 
			if(configFile != null && await configFile.exists())
			{
				String dbConfigJson = configFile.readAsStringSync();
				Map<String, dynamic> dbConfig = jsonDecode(dbConfigJson);
				//Create the connection using the original settings retrieved from the config file:
				ConnectionSettings connectionSettings =ConnectionSettings(
				host: dbConfig["host"],
				port: 3306,
				user: dbConfig["userName"],
				password: dbConfig["password"],
				db: dbConfig["dbName"]
				);
				var conn = await MySqlConnection.connect(connectionSettings);

				//Create the database:
				final CreateDb = await conn.query("CREATE DATABASE IF NOT EXISTS $newDbName");
				logger.i(CreateDb);
				final CreateNewUser = await conn.query("CREATE USER IF NOT EXISTS '$adminUserName' IDENTIFIED BY '$adminPassword';");
				logger.i(CreateNewUser);
				final GrantAllToNewUser = await conn.query("GRANT ALL PRIVILEGES ON $newDbName.* TO '$adminUserName';");
				logger.i(GrantAllToNewUser);
				final Flush = await conn.query("FLUSH PRIVILEGES;"); 
				logger.i(Flush);
				await conn.query("use $newDbName;");
				logger.i("Using new database $newDbName");
				final usersTable = await conn.query('''CREATE TABLE IF NOT EXISTS $usersTableName (
				`userId` INT(11) NOT NULL AUTO_INCREMENT,
				`userName` VARCHAR(255) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
				`fullName` VARCHAR(255) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
				`password` VARCHAR(255) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
				`hashedPassword` VARCHAR(255) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
				`salt` VARCHAR(255) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
				`userRole` VARCHAR(255) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
				`can_process_sales` ENUM('Y','N') NULL DEFAULT 'N' COLLATE 'latin1_swedish_ci',
				`can_view_customer_info` ENUM('Y','N') NULL DEFAULT 'N' COLLATE 'latin1_swedish_ci',
				`can_open_close_register` ENUM('Y','N') NULL DEFAULT 'N' COLLATE 'latin1_swedish_ci',
				`can_access_sales_reports` ENUM('Y','N') NULL DEFAULT 'N' COLLATE 'latin1_swedish_ci',
				`can_manage_inventory` ENUM('Y','N') NULL DEFAULT 'N' COLLATE 'latin1_swedish_ci',
				`can_manage_employees` ENUM('Y','N') NULL DEFAULT 'N' COLLATE 'latin1_swedish_ci',
				`can_apply_discounts` ENUM('Y','N') NULL DEFAULT 'N' COLLATE 'latin1_swedish_ci',
				`can_access_system_settings` ENUM('Y','N') NULL DEFAULT 'N' COLLATE 'latin1_swedish_ci',
				`can_add_remove_users` ENUM('Y','N') NULL DEFAULT 'N' COLLATE 'latin1_swedish_ci',
				`can_backup_restore_system` ENUM('Y','N') NULL DEFAULT 'N' COLLATE 'latin1_swedish_ci',
				`can_configure_hardware` ENUM('Y','N') NULL DEFAULT 'N' COLLATE 'latin1_swedish_ci',
				`can_override_authorize` ENUM('Y','N') NULL DEFAULT 'N' COLLATE 'latin1_swedish_ci',
				`can_access_detailed_reports` ENUM('Y','N') NULL DEFAULT 'N' COLLATE 'latin1_swedish_ci',
				`can_handle_refunds_returns` ENUM('Y','N') NULL DEFAULT 'N' COLLATE 'latin1_swedish_ci',
				`can_manage_inventory_independently` ENUM('Y','N') NULL DEFAULT 'N' COLLATE 'latin1_swedish_ci',
				`can_generate_inventory_reports` ENUM('Y','N') NULL DEFAULT 'N' COLLATE 'latin1_swedish_ci',
				`can_view_own_sales_reports` ENUM('Y','N') NULL DEFAULT 'N' COLLATE 'latin1_swedish_ci',
				`read_permission` ENUM('Y','N') NULL DEFAULT 'N' COLLATE 'latin1_swedish_ci',
				`write_permission` ENUM('Y','N') NULL DEFAULT 'N' COLLATE 'latin1_swedish_ci',
				PRIMARY KEY (`userId`) USING BTREE
				)
				COLLATE='latin1_swedish_ci'
				ENGINE=InnoDB
				;''');
				logger.i("Table $usersTable created successfully.");
				final productsTable = await conn.query('''CREATE TABLE IF NOT EXISTS $productsTableName (
				`product_id` INT(11) NOT NULL AUTO_INCREMENT,
				`product_name` VARCHAR(255) NOT NULL COLLATE 'latin1_swedish_ci',
				`price` DECIMAL(10,2) NOT NULL,
				`image` VARCHAR(255) NOT NULL DEFAULT '' COLLATE 'latin1_swedish_ci',
				`quantity` INT(11) NOT NULL,
				`fluid_quantity` DOUBLE(11,2) NULL DEFAULT NULL,
				`shortages` INT(11) NULL DEFAULT NULL,
				`category` VARCHAR(255) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
				`description` TEXT NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
				`created_at` TIMESTAMP NULL DEFAULT current_timestamp(),
				`updated_at` TIMESTAMP NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
				PRIMARY KEY (`product_id`) USING BTREE
				)
				COLLATE='latin1_swedish_ci'
				ENGINE=InnoDB
				;''');
				logger.i("Table $productsTable created successfully.");

				final salesTable = await conn.query('''CREATE TABLE IF NOT EXISTS $salesTableName (
				`sale_id` INT(11) NOT NULL AUTO_INCREMENT,
				`user_id` INT(11) NULL DEFAULT NULL,
				`total_amount` DECIMAL(10,2) NOT NULL,
				`sale_date` TIMESTAMP NULL DEFAULT current_timestamp(),
				PRIMARY KEY (`sale_id`) USING BTREE,
				INDEX `user_id` (`user_id`) USING BTREE,
				CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES $usersTableName (`userId`) ON UPDATE RESTRICT ON DELETE RESTRICT
				)
				COLLATE='latin1_swedish_ci'
				ENGINE=InnoDB
				;''');
				logger.i("Table $salesTable created successfully.");

				final salesItemsTable = await conn.query('''CREATE TABLE IF NOT EXISTS $salesItemsTableName (
				`item_id` INT(11) NOT NULL AUTO_INCREMENT,
				`sale_id` INT(11) NULL DEFAULT NULL,
				`product_id` INT(11) NULL DEFAULT NULL,
				`quantity` INT(11) NOT NULL,
				`fluid_quantity` DOUBLE(11,2) NULL DEFAULT NULL,
				`item_total` DECIMAL(10,2) NOT NULL,
				PRIMARY KEY (`item_id`) USING BTREE,
				INDEX `sale_id` (`sale_id`) USING BTREE,
				INDEX `product_id` (`product_id`) USING BTREE,
				CONSTRAINT `sales_items_ibfk_1` FOREIGN KEY (`sale_id`) REFERENCES $salesTableName (`sale_id`) ON UPDATE RESTRICT ON DELETE RESTRICT,
				CONSTRAINT `sales_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES $productsTableName (`product_id`) ON UPDATE RESTRICT ON DELETE RESTRICT
				)
				COLLATE='latin1_swedish_ci'
				ENGINE=InnoDB
				;''');
				logger.i("Table $salesItemsTable created successfully.");
				final transactionsTable = await conn.query('''CREATE TABLE IF NOT EXISTS $transactionsTableName (
				`transaction_id` INT(11) NOT NULL AUTO_INCREMENT,
				`user_id` INT(11) NULL DEFAULT NULL,
				`transaction_type` VARCHAR(255) NOT NULL COLLATE 'latin1_swedish_ci',
				`transaction_date` TIMESTAMP NULL DEFAULT current_timestamp(),
				`details` TEXT NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
				PRIMARY KEY (`transaction_id`) USING BTREE,
				INDEX `user_id` (`user_id`) USING BTREE,
				CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES $usersTableName (`userId`) ON UPDATE RESTRICT ON DELETE RESTRICT
				)
				COLLATE='latin1_swedish_ci'
				ENGINE=InnoDB
				;''');
				logger.i("Table $transactionsTable created successfully.");

				final shortagesTable = await conn.query('''CREATE TABLE $shortagesTableName (
				`shortage_id` INT(11) NOT NULL AUTO_INCREMENT,
				`user_id` INT(11) NOT NULL,
				`product_id` INT(11) NOT NULL,
				`shortage_quantity` INT(11) NOT NULL,
				`created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
				PRIMARY KEY (`shortage_id`) USING BTREE,
				INDEX `user_id` (`user_id`) USING BTREE,
				INDEX `product_id` (`product_id`) USING BTREE,
				CONSTRAINT `shortages_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES $usersTableName (`userId`) ON UPDATE RESTRICT ON DELETE RESTRICT,
				CONSTRAINT `shortages_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES $productsTableName (`product_id`) ON UPDATE RESTRICT ON DELETE RESTRICT
				)
				COLLATE='latin1_swedish_ci'
				ENGINE=InnoDB
				;''');
				logger.i("Table $shortagesTable created successfully.");
				final purchasesTable = ('''CREATE TABLE $purchasesTableName (
					`purchase_id` INT(11) NOT NULL AUTO_INCREMENT,
					`user_id` INT(11) NULL DEFAULT NULL,
					`total_amount` DECIMAL(10,2) NOT NULL,
					`purchase_date` TIMESTAMP NULL DEFAULT current_timestamp(),
					PRIMARY KEY (`purchase_id`) USING BTREE,
					INDEX `user_id` (`user_id`) USING BTREE,
					CONSTRAINT `purchases_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES $usersTableName (`userId`) ON UPDATE RESTRICT ON DELETE RESTRICT
				)
				COLLATE='latin1_swedish_ci'
				ENGINE=InnoDB
				;
				''');
				logger.i("Table $purchasesTable created successfully.");
				final purchaseItemsTable = ('''CREATE TABLE $purchaseItemsTableName (
					`item_id` INT(11) NOT NULL AUTO_INCREMENT,
					`purchase_id` INT(11) NULL DEFAULT NULL,
					`product_id` INT(11) NULL DEFAULT NULL,
					`quantity` INT(11) NOT NULL,
					`item_total` DECIMAL(10,2) NOT NULL,
					PRIMARY KEY (`item_id`) USING BTREE,
					INDEX `purchase_id` (`purchase_id`) USING BTREE,
					INDEX `product_id` (`product_id`) USING BTREE,
					CONSTRAINT `purchase_items_ibfk_1` FOREIGN KEY (`purchase_id`) REFERENCES $purchasesTableName (`purchase_id`) ON UPDATE RESTRICT ON DELETE RESTRICT,
					CONSTRAINT `purchase_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES $productsTableName (`product_id`) ON UPDATE RESTRICT ON DELETE RESTRICT
				)
				COLLATE='latin1_swedish_ci'
				ENGINE=InnoDB
				;''');
				logger.i("Table $purchaseItemsTable created successfully.");
				final menuItemsTable = await conn.query('''CREATE TABLE $menuItemsTableName (
					`item_id` INT(11) NOT NULL AUTO_INCREMENT,
					`menuitem_name` VARCHAR(255) NOT NULL COLLATE 'latin1_swedish_ci',
					`menuitem_description` LONGTEXT NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
					`menuitem_image` LONGTEXT NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
					`price` DECIMAL(10,2) NULL DEFAULT NULL,
					`created_at` TIMESTAMP NULL DEFAULT current_timestamp(),
					`updated_at` TIMESTAMP NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
					PRIMARY KEY (`item_id`) USING BTREE
				)
				COLLATE='latin1_swedish_ci'
				ENGINE=InnoDB
				AUTO_INCREMENT=2
				;''');
				logger.i("Table $menuItemsTable created successfully.");
				//Create the triggers:
				final triggerUpdateFluidQuantity = await conn.query(
					'''	CREATE DEFINER=`root`@`localhost` TRIGGER `update_fluid_quantity` AFTER INSERT ON $salesItemsTableName FOR EACH ROW BEGIN
							UPDATE $productsTableName
							SET fluid_quantity = fluid_quantity - NEW.fluid_quantity
							WHERE product_id = NEW.product_id;
						END ''');
				logger.i("Trigger $triggerUpdateFluidQuantity created successfully.");

				final triggerUpdatePurchasesQuantity = await conn.query(
					'''CREATE DEFINER=`root`@`localhost` TRIGGER `update_purchases_quantity` AFTER INSERT ON $purchaseItemsTableName FOR EACH ROW BEGIN
							UPDATE $productsTableName
							SET quantity = quantity + NEW.quantity
							WHERE product_id=NEW.product_id;
						END''');
				logger.i("Trigger $triggerUpdatePurchasesQuantity created successfully.");

				final triggerUpdateSalesQuantity = await conn.query(
					'''CREATE DEFINER=`root`@`localhost` TRIGGER `update_sales_quantity` AFTER INSERT ON $salesItemsTableName FOR EACH ROW BEGIN
							UPDATE $productsTableName
							SET quantity = quantity - NEW.quantity
							WHERE product_id=NEW.product_id;
						END''');
				logger.i("Trigger $triggerUpdateSalesQuantity created successfully.");

				final triggerUpdateSalesTotalAmount= await conn.query(
					'''CREATE DEFINER=`root`@`localhost` TRIGGER `update_sales_total_amount` AFTER INSERT ON $salesItemsTableName FOR EACH ROW BEGIN
						UPDATE $salesTableName s
						SET s.total_amount = (
							SELECT SUM(si.item_total)
							FROM $salesItemsTableName si
							WHERE si.sale_id = NEW.sale_id
						)
						WHERE s.sale_id = NEW.sale_id;
					END''');
				logger.i("Trigger $triggerUpdateSalesTotalAmount created successfully.");

				final triggerUpdatePurchasesTotalAmount = await conn.query(
					'''CREATE DEFINER=`root`@`localhost` TRIGGER `update_purchases_total_amount` AFTER INSERT ON $purchaseItemsTableName FOR EACH ROW BEGIN
						UPDATE $purchasesTableName p
						SET p.total_amount = (
							SELECT SUM(p_i.item_total)
							FROM $purchaseItemsTableName p_i
							WHERE p_i.purchase_id = NEW.purchase_id
						)
						WHERE p.purchase_id = NEW.purchase_id;
					END''');
				logger.i("Trigger $triggerUpdatePurchasesTotalAmount created successfully.");

				final updateTransactionsAfterPurchase=await conn.query(
					'''CREATE DEFINER=`root`@`localhost` TRIGGER `update_transactions_after_purchase_insert` AFTER INSERT ON $purchasesTableName FOR EACH ROW BEGIN
						INSERT INTO $transactionsTableName (transaction_type, transaction_date, details)
						VALUES('Purchase', NOW(),'New purchase logged');
						END''');
				logger.i("Trigger $updateTransactionsAfterPurchase created successfully.");

				final updateTransactionsAfterSale = await conn.query(
					'''CREATE DEFINER=`root`@`localhost` TRIGGER `update_transactions_after_sale_insert` AFTER INSERT ON $salesTableName FOR EACH ROW BEGIN
						INSERT INTO $transactionsTableName (transaction_type, transaction_date, details)
						VALUES('Sale', NEW.sale_date, 'New sale logged');
						END''');
				logger.i("Trigger $updateTransactionsAfterSale created successfully.");
				
				//Close the connection...finally :)
				await conn.close();
				
				//Create a new map with the new user details:
				IsSetupComplete = true;
				Map<String, String> newDbConfig =
				{
				"host": dbConfig["host"],
				"dbName": newDbName!,
				"userName": adminUserName!,
				"password": adminPassword!,
				"initialSetupComplete" : initialSetupComplete.toString(),
				"isSetupComplete" : IsSetupComplete.toString(),
				"usersTableName": usersTableName,
				"productsTableName": productsTableName,
				"salesItemsTableName": salesItemsTableName,
				"transactionsTableName": transactionsTableName,
				"salesTableName": salesTableName,
				"shortagesTableName": shortagesTableName,
				"purchasesTableName": purchasesTableName,
				"purchaseItemsTableName": purchaseItemsTableName,
				};
				//Encode the map to json:
				dbConfigJson = jsonEncode(newDbConfig);
				//Write the json to a file - how can i overwrite the contents of the file?
				await configFile.writeAsString(dbConfigJson);
			}
			else
			{
				logger.e("Database config file not provided or found.");
			}
		}
		catch(ex)
		{
		logger.e("Something went wrong while trying to create the database admin user: $ex");
		}
	}

	/// The function RetrieveConfigFile retrieves a database config file from the user's home path and
	/// returns it as a File object, or returns null if the file is not found or an error occurs.
	/// 
	/// Returns:
	///   The method `RetrieveConfigFile()` returns a `Future<File?>`.
	Future<File?> RetrieveConfigFile() async
	{
		Logger logger = Logger();
		try
		{
			dbConfigFilePath = await GetUserHomepath();
			if(File("$dbConfigFilePath/config.json").existsSync())
			{
				return File("$dbConfigFilePath/config.json");
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

	/// The function `ReadConfigFile` reads a JSON config file and returns its contents as a `Map<String,
	/// dynamic>` or `null` if an error occurs.
	/// 
	/// Args:
	///   configFile (File): The `configFile` parameter is of type `File?`, which means it can either be a
	/// `File` object or `null`. It represents the configuration file that needs to be read.
	/// 
	/// Returns:
	///   a Future object that resolves to a Map<String, dynamic> or null.
	Future<Map<String, dynamic>?> ReadConfigFile(File? configFile) async
	{
		Logger logger = Logger();
		try
		{
			String dbConfigJson = configFile!.readAsStringSync();
			Map<String, dynamic> dbConfig = jsonDecode(dbConfigJson);
			return dbConfig;
		}
		catch(ex)
		{
			logger.e("Something went wrong while trying to read the database config file: $ex");
			return null;
		}
	}

	/// The function `ReadConfigfileProperty` reads a specified property from a JSON config file and returns
	/// its value as a string, or null if an error occurs.
	/// 
	/// Args:
	///   configFile (File): The `configFile` parameter is of type `File?`, which means it can either be a
	/// `File` object or `null`. It represents the configuration file from which the property value will be
	/// read.
	///   propertyName (String): The `propertyName` parameter is a string that represents the name of the
	/// property in the configuration file that you want to retrieve.
	/// 
	/// Returns:
	///   The method is returning a `Future` object that resolves to a `String` or `null`.
	Future<String?> ReadConfigfileProperty(File? configFile, String propertyName) async
	{
		Logger logger = Logger();
		try
		{
		String dbConfigJson = configFile!.readAsStringSync();
		Map<String, dynamic> dbConfig = jsonDecode(dbConfigJson);
		return dbConfig[propertyName];
		}
		catch(ex)
		{
		logger.e("Something went wrong while trying to read the database config file: $ex");
		return null;
		}
	}
}