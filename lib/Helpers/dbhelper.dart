// ignore_for_file: non_constant_identifier_names

import "dart:convert";
import "dart:io";
import "dart:typed_data";
import "package:logger/logger.dart";
import "package:mysql1/mysql1.dart";

import "../config/setup.dart";

abstract class BaseDbHelper
{
  //Create a connection
  Future<void> CreateConnection(File configFile);
  //Create the database only
  Future<void> CreateDatabase(String? dbName);
  //Create table
  Future<void> CreateTable(String? dbName, String? tableName, Map<String, dynamic> columns);
  //Check for an existing entry:
  Future<bool> CheckEntryExists({String? dbName, String? tableName, String? whereField, String? whereValue});
  //Create an entry
  Future<void> CreateEntry(String? dbName, String? tableName, Map<String, dynamic> values);
  //Read all entries in the table
  Future<List<Map<String, dynamic>>?> ReadEntries(String? dbName, String? tableName, String? whereClause, List<dynamic>? whereArgs);
  //Read a single entry
  Future<Map<String,dynamic>?>? ReadSingleEntry(String? dbName, String? tableName, String? whereClause, List<dynamic>? whereArgs);
  //Update an entry
  Future<void> UpdateEntry(String? dbName, String? tableName, Map<String, dynamic> values, String? whereClause, List<dynamic>? whereArgs);
  //Delete an entry
  Future<void> DeleteEntry(String? dbName, String? tableName, String? whereClause, List<dynamic>? whereArgs);
}

/// The `MysqlDbHelper` class is a Dart class that implements the `BaseDbHelper` interface and provides
/// methods for connecting to a MySQL database, creating databases and tables, checking if an entry
/// exists, creating and updating entries, deleting entries, and reading entries from the database.
class MysqlDbHelper implements BaseDbHelper
{
  File? configFile;
  MysqlDbHelper();
  Logger logger = Logger();
  
  //Need to pass the config file retrieved from the config bloc to this constructor.
  MysqlDbHelper.withConfigFile(File this.configFile);

  /// The function `CreateConnection` creates a MySQL database connection using the provided
  /// configuration file.
  /// 
  /// Args:
  ///   configFile: The `configFile` parameter is the file that contains the database configuration
  /// information. It is expected to be a `File` object.
  /// 
  /// Returns:
  ///   The method `CreateConnection` returns a `Future` object that resolves to a `MySqlConnection`
  /// object if the connection is successfully created, or `null` if there is an error.
  @override 
  Future<MySqlConnection?> CreateConnection(configFile) async
  {
    MySqlConnection? conn;
    try
    {
      var dbConfigFile = await Config().RetrieveConfigFile();
      if (dbConfigFile == null)
      {
        logger.e("No database configuration file found");
      }
      else
      {
        configFile = dbConfigFile;
      }
      var connectionJson = configFile.readAsStringSync();
      var connectionInfo = jsonDecode(connectionJson);
      var connectionSettings = ConnectionSettings(
        host: connectionInfo["host"],
        port: 3306,
        user: connectionInfo["userName"],
        password: connectionInfo["password"],
        db: connectionInfo["dbName"]
      );
      conn = await MySqlConnection.connect(connectionSettings);
    }
    catch(ex)
    {
      logger.e("Something went wrong while trying to create the database connection: $ex");
      conn = null;
    }
    return conn;
  }

 /// The function `CreateDatabase` creates a database with the given name if it does not already exist.
 /// 
 /// Args:
 ///   dbName (String): dbName is a String parameter that represents the name of the database to be
 /// created.
  @override
  Future<void> CreateDatabase(String? dbName) async
  {
    var conn = await CreateConnection(configFile!);
    try
    {
      await conn!.query("CREATE DATABASE IF NOT EXISTS $dbName");
      await conn.close();
    }
    catch(ex)
    {
      logger.e("Something went wrong while trying to create the database: $ex");
    }
    finally
    {
      //Close the connection:
      if(conn != null)
      {
        await conn.close();
      }
    }
  }

 /// The function `CreateTable` creates a table in a database with the specified name and columns using
 /// the Dart programming language.
 /// 
 /// Args:
 ///   dbName (String): The `dbName` parameter is a string that represents the name of the database
 /// where the table will be created.
 ///   tableName (String): The tableName parameter is a String that represents the name of the table you
 /// want to create in the database.
 ///   columns (Map<String, dynamic>): The `columns` parameter is a `Map` that represents the columns of
 /// the table to be created. The keys of the map represent the column names, and the values represent
 /// the column types.
  @override
  Future<void> CreateTable(String? dbName, String? tableName, Map<String, dynamic> columns) async
  { 
    var conn = await CreateConnection(configFile!);
    try
    {
      await conn!.query("CREATE TABLE IF NOT EXISTS $dbName.$tableName (${columns.keys.map((key) => "$key ${columns[key]}").join(",")})");
      await conn.close();
    }
    catch(ex)
    {
      logger.e("Something went wrong while trying to create the table: $ex");
    }
    finally
    {
      //Close the connection:
      if(conn != null)
      {
        await conn.close();
      }
    }    
  }
/// The function `CheckEntryExists` checks if an entry exists in a specified database table based on a
/// given condition.
/// 
/// Args:
///   dbName (String): The dbName parameter is the name of the database where the table is located.
///   tableName (String): The tableName parameter is the name of the table in the database where you
/// want to check if an entry exists.
///   whereField (String): The `whereField` parameter is a string that represents the name of the field
/// in the database table that you want to use for the WHERE clause in the SQL query.
///   whereValue (String): The `whereValue` parameter is the value that you want to check for in the
/// specified `whereField` column of the database table. It is used to filter the query and determine if
/// an entry exists with that value in the specified column.
/// 
/// Returns:
///   The method `CheckEntryExists` returns a `Future<bool>`.

  @override
  Future<bool> CheckEntryExists({String? dbName, String? tableName, String? whereField, String? whereValue}) async
  {
    var conn = await CreateConnection(configFile!);
    try
    {
      var result = await conn!.query("SELECT * FROM $dbName.$tableName WHERE $whereField = ?", [whereValue]);
      await conn.close();
      if(result.isNotEmpty)
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    catch(ex)
    {
      logger.e("Something went wrong while trying to check if an entry exists: $ex");
      return false;
    }
    finally
    {
      //Close the connection:
      if(conn != null)
      {
        await conn.close();
      }
    }    
  }
/// The `CreateEntry` function creates a new entry in a database table with the provided values, after
/// checking if the entry already exists.
/// 
/// Args:
///   dbName (String): The name of the database where the entry will be created.
///   tableName (String): The `tableName` parameter is a string that represents the name of the table in
/// the database where the entry will be created.
///   values (Map<String, dynamic>): The `values` parameter is a `Map` object that contains key-value
/// pairs representing the column names and their corresponding values for the entry you want to create
/// in the database table.
/// 
/// Returns:
///   The `CreateEntry` method does not have a return type specified, so it is returning `void`.

  @override
  Future<void> CreateEntry(String? dbName, String? tableName, Map<String, dynamic> values) async
  {
    var conn = await CreateConnection(configFile!);
    try
    {
      final stringValues  =  values.entries.map((entry)
      {
        if(entry.value is String)
        {
          //If the type is string, wrap with single quotes - this is required by mysql and mariadb due to rigid type checking
          return "'${entry.value}'";
        }
		else if (entry.value is Uint8List)
		{
			//Remove the square brackets from the Uint8List and store it as a string
			return entry.value.toString().replaceAll("[", "'").replaceAll("]", "'");
		}
        else
        {
          //Return the raw string value
          return entry.value.toString();
        }
      }).join(",");
      if(!await CheckEntryExists(dbName: dbName, tableName: tableName, whereField: values.keys.first, whereValue: values.values.first))
      {
        await conn!.query("INSERT INTO $dbName.$tableName (${values.keys.join(",")}) VALUES ($stringValues)");
      }
      await conn!.close();
    }
    catch(ex)
    {
      logger.e("Something went wrong while trying to create an entry: $ex");
    }
    finally
    {
      //Close the connection:
      if(conn != null)
      {
        await conn.close();
      }
    }
  }

 /// The function `UpdateEntry` updates a row in a database table with the provided values and
 /// conditions.
 /// 
 /// Args:
 ///   dbName (String): The name of the database where the table is located.
 ///   tableName (String): The tableName parameter is a String that represents the name of the table in
 /// the database where the entry needs to be updated.
 ///   values (Map<String, dynamic>): A map containing the column names and their corresponding values
 /// that you want to update in the database table.
 ///   whereClause (String): The `whereClause` parameter is a string that specifies the condition for
 /// updating the entries in the database table. It is used in the SQL query to determine which rows
 /// should be updated.
 ///   whereArgs (List<dynamic>): The `whereArgs` parameter is a list of dynamic values that will be
 /// used in the WHERE clause of the SQL query. These values will be inserted into the query in the
 /// order they appear in the list.
 /// 
 /// Returns:
 ///   The method `UpdateEntry` is returning a `Future<void>`, which means it is not returning any
 /// value.
  @override
  Future<void> UpdateEntry(String? dbName, String? tableName, Map<String, dynamic> values, String? whereClause, List<dynamic>? whereArgs) async
  {
    var conn = await CreateConnection(configFile!);
    try
    {
      final stringValues  =  values.entries.map((entry)
      {
        if(entry.value is String)
        {
			return '''${entry.value}''';
        }
		else if (entry.value is Uint8List)
		{
			//Remove the square brackets from the Uint8List and store it as a string
			return entry.value.toString().replaceAll("[", "'").replaceAll("]", "'");
		}
        else
        {
			//Return the raw string value
			return entry.value.toString();
        }
      });
      final updateValues = values.entries.map((entry) 
      {
        return "${entry.key} = ?";  
      }).join(",");
      final updateClause = "UPDATE $dbName.$tableName SET $updateValues WHERE $whereClause";
      await conn!.query(updateClause,[...stringValues, ...whereArgs!]);
      await conn.close();
    }
    catch(ex)
    {
      logger.e("Something went wrong while trying to update an entry: $ex");
    }
    finally
    {
      //Close the connection:
      if(conn != null)
      {
        await conn.close();
      }
    }
  }

/// The function `DeleteEntry` deletes an entry from a specified database table using the provided where
/// clause and arguments.
/// 
/// Args:
///   dbName (String): The `dbName` parameter represents the name of the database from which you want to
/// delete an entry.
///   tableName (String): The tableName parameter is a String that represents the name of the table from
/// which you want to delete an entry.
///   whereClause (String): The `whereClause` parameter is a string that represents the condition for
/// deleting entries from the specified table. It is used in the SQL query to specify which entries
/// should be deleted.
///   whereArgs (List<dynamic>): The `whereArgs` parameter is a list of dynamic values that will be used
/// to replace the placeholders in the `whereClause`. These values are typically used to filter the rows
/// that will be deleted from the specified table.
  @override
  Future<void> DeleteEntry(String? dbName, String? tableName, String? whereClause, List<dynamic>? whereArgs) async
  {
    var conn = await CreateConnection(configFile!);
    try
    {
      await conn!.query("DELETE FROM $dbName.$tableName WHERE $whereClause", whereArgs);
      await conn.close();
    }
    catch(ex)
    {
      logger.e("Something went wrong while trying to delete an entry: $ex");
    }
    finally
    {
      //Close the connection:
      if(conn != null)
      {
        await conn.close();
      }
    }
  }

  /// The function `ReadEntries` reads entries from a database table based on the provided parameters
  /// and returns a list of maps representing the entries.
  /// 
  /// Args:
  ///   dbName (String): The `dbName` parameter represents the name of the database you want to read
  /// entries from.
  ///   tableName (String): The tableName parameter is the name of the table from which you want to read
  /// entries.
  ///   whereClause (String): The `whereClause` parameter is a string that represents the condition to
  /// be used in the SQL query's WHERE clause. It specifies the criteria that the rows must meet in
  /// order to be included in the result set.
  ///   whereArgs (List<dynamic>): The `whereArgs` parameter is a list of dynamic values that will be
  /// used to replace the placeholders in the `whereClause` parameter. These placeholders are typically
  /// represented by question marks (?) in the SQL query string. The values in the `whereArgs` list will
  /// be used in the order they appear
  /// 
  /// Returns:
  ///   The method `ReadEntries` returns a `Future` that resolves to a `List` of `Map<String, dynamic>`
  /// or `null`.
  @override 
  Future<List<Map<String, dynamic>>?> ReadEntries(String? dbName, String? tableName, String? whereClause, List<dynamic>? whereArgs) async
  {
    var conn = await CreateConnection(configFile!);
    try
    {
      Results? result;
      if(whereClause != null)
      {
        result = await conn!.query("SELECT * FROM $dbName.$tableName WHERE $whereClause", whereArgs);
      }
      else
      {
        result = await conn!.query("SELECT * FROM $dbName.$tableName");
      }
      await conn.close();
      if (result.isNotEmpty)
      {
        return ConvertResultsToMapList(result);
      }
      else
      {
        logger.i("No entries found");
        return null;
      }
    }
    catch(ex)
    {
      logger.e("Something went wrong while trying to read entries: $ex");
      return null;
    }
    finally
    {
      //Close the connection:
      if(conn != null)
      {
        await conn.close();
      }
    }
  }

  /// The function `ReadSingleEntry` reads a single entry from a specified database table based on the
  /// provided parameters.
  /// 
  /// Args:
  ///   dbName (String): The name of the database you want to read from.
  ///   tableName (String): The tableName parameter is the name of the table from which you want to read
  /// the entry.
  ///   whereClause (String): The `whereClause` parameter is a string that represents the condition to
  /// be used in the SQL query's WHERE clause. It specifies the criteria for selecting rows from the
  /// table. For example, if you want to select rows where the "name" column equals "John", the
  /// `whereClause` would
  ///   whereArgs (List<dynamic>): The `whereArgs` parameter is a list of dynamic values that will be
  /// used to replace the placeholders in the `whereClause`. These values are used to filter the results
  /// of the query.
  /// 
  /// Returns:
  ///   The method `ReadSingleEntry` returns a `Future` that resolves to a `Map<String, dynamic>?` or
  /// `null`.
  @override 
  Future<Map<String,dynamic>?>? ReadSingleEntry(String? dbName, String? tableName, String? whereClause, List<dynamic>? whereArgs) async
  {
    var conn = await CreateConnection(configFile!);
    try
    {
      await CreateConnection(configFile!);
      Results? result;
      if(whereClause != null)
      {
        result = await conn!.query("SELECT * FROM $dbName.$tableName WHERE $whereClause", whereArgs);
      }
      else
      {
        result = await conn!.query("SELECT * FROM $dbName.$tableName");
      }
      await conn.close();
      if (result.isNotEmpty)
      {
        return ConvertIndividualResultToMap(result.first);
      }
      else
      {
        logger.i("No entries found");
        return null;
      }
    }
    catch(ex)
    {
      logger.e("Something went wrong while trying to read an entry: $ex");
      return null;
    }
    finally
    {
      //Close the connection:
      if(conn != null)
      {
        await conn.close();
      }
    }
  }

/// The function "ConvertResultsToMapList" takes a "Results" object and converts it into a list of maps,
/// where each map represents a row in the results.
/// 
/// Args:
///   results (Results): An object of type Results, which contains a collection of ResultRow objects.
/// 
/// Returns:
///   The method is returning a List of Maps, where the keys are of type String and the values can be of
/// any type (dynamic). The method can also return null if an exception occurs during the conversion
/// process.
  List<Map<String,dynamic>>? ConvertResultsToMapList(Results results)
  {
    try
    {
      final List<Map<String,dynamic>> mapList = [];
      for(ResultRow result in results)
      {
        var resultMap = ConvertIndividualResultToMap(result);
        mapList.add(resultMap);
      }
      return mapList;
    }
    catch(ex) 
    {
      logger.e("Exception occurred while converting results to map list: $ex");
      return null;
    }
  }

 /// The function converts an individual result row into a map in Dart.
 /// 
 /// Args:
 ///   row (ResultRow): The parameter "row" is of type ResultRow, which is an object representing a row
 /// of data retrieved from a database query result.
 /// 
 /// Returns:
 ///   a Map<String, dynamic> object.
  Map<String,dynamic> ConvertIndividualResultToMap(ResultRow row)
  {
    final Map<String,dynamic> rowMap = {};
    try
    {
      for (var entry in row.fields.entries)
      {
        rowMap[entry.key] = entry.value;
      }
      return rowMap;
    }
    catch(ex) 
    {
      logger.e("Exception occurred while converting results to map: $ex");
      return {};
    }
  }
}

