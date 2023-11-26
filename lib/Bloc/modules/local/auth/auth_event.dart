part of "auth_bloc.dart";


@immutable
sealed class AuthEvent{}

class HandleLogin extends AuthEvent
{
	final String username;
	final String password;
	HandleLogin({required this.username, required this.password});
}

class HandleLogoff extends AuthEvent
{
	final String username;
	HandleLogoff({required this.username});
}

class HandleRegister extends AuthEvent
{
	final String username;
	final String password;
	HandleRegister({required this.username, required this.password});
}

class HandleResetPassword extends AuthEvent
{
	final String username;
	final String newPassword;
	HandleResetPassword({required this.username, required this.newPassword});
}