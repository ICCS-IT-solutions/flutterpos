part of 'user_bloc.dart';

@immutable
sealed class UserBlocEvent {}

class Login extends UserBlocEvent 
{
	final String userName;
	final String password;

	Login({required this.userName, required this.password});
	//Also should generate an auth token that can be used to maintain the login state after an app or device restart, within reasonable limitations.
	//For now, simply log the user in.
}

class Register extends UserBlocEvent 
{
	final UserDataModel userData;
	Register({required this.userData});
}

class Logoff extends UserBlocEvent 
{
  	//Not sure what the event handler class should do on logoff, but the state should definitely send an isAuthenticated = false bool back to the UI
}