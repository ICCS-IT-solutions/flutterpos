// ignore_for_file: non_constant_identifier_names

part of "configmanagerbloc.dart";

@immutable
class ConfigManagerBlocState
{
	final bool ConnectionSuccessful;
	final bool IsConnecting;
	final bool ConnectionFailed;
	final String ResponseMessage;

	const ConfigManagerBlocState({required this.ConnectionSuccessful,required this.IsConnecting, required this.ConnectionFailed, required this.ResponseMessage});
}

class ConfigManagerBlocInitialState extends ConfigManagerBlocState 
{
	const ConfigManagerBlocInitialState():super(ConnectionFailed: false, ConnectionSuccessful: false, IsConnecting: false, ResponseMessage: "");
}
class ConfigManagerBlocConnectionWaitingState extends ConfigManagerBlocState 
{
	const ConfigManagerBlocConnectionWaitingState():super(IsConnecting: true, ConnectionFailed: false, ConnectionSuccessful: false, ResponseMessage: "");
}

class ConfigManagerBlocConnectionSuccessState extends ConfigManagerBlocState 
{
	const ConfigManagerBlocConnectionSuccessState({required String ResponseMessage}):super(ConnectionSuccessful: true, ConnectionFailed: false, IsConnecting: false, ResponseMessage: "Connection established");
}

class ConfigManagerBlocConnectionFailureState extends ConfigManagerBlocState
{	
	const ConfigManagerBlocConnectionFailureState({required String ResponseMessage}):super(ConnectionFailed: true, ConnectionSuccessful: false, IsConnecting: false, ResponseMessage: "Connection failed");
}