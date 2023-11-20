part of "configmanagerbloc.dart";

@immutable
abstract class ConfigManagerBlocEvent{}

class ConnectToServer extends ConfigManagerBlocEvent
{
	final String host;
	final String dbName;
	final String userName;
	final String password;
	final int port;

	ConnectToServer({required this.host, required this.dbName, required this.userName, required this.password, required this.port});
}