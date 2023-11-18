part of 'config_bloc.dart';

@immutable
sealed class ConfigBlocState {}

final class ConfigBlocInitialState extends ConfigBlocState {}

class ConfigBlocConnectionSuccess extends ConfigBlocState 
{
  final File configFile;
  ConfigBlocConnectionSuccess(this.configFile);
}

class ConfigBlocConnectionFailure extends ConfigBlocState
{
  final String message;
  ConfigBlocConnectionFailure(this.message);
}

class ConfigBlocNewDatabaseSuccess extends ConfigBlocState
{
  final File configFile;
  ConfigBlocNewDatabaseSuccess(this.configFile);
}

class ConfigBlocNewDatabaseFailure extends ConfigBlocState
{
  final String message;
  ConfigBlocNewDatabaseFailure(this.message);
}

class CreateDatabaseTables extends ConfigBlocState
{}

class CreateDatabaseTablesSuccess extends ConfigBlocState
{
  final File configFile;
  CreateDatabaseTablesSuccess(this.configFile);
}

class CreateDatabaseTablesFailure extends ConfigBlocState
{
  final String message;
 CreateDatabaseTablesFailure(this.message);
}