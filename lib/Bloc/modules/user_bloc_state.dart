// ignore_for_file: non_constant_identifier_names

part of 'user_bloc.dart';

@immutable
class UserBlocState 
{
	final User? user;
	final bool isLoading;
	final bool isAuthenticated;
	final String message;

	const UserBlocState({required this.user, required this.isLoading, required this.isAuthenticated, required this.message});
}

class UserBlocInitial extends UserBlocState
{
	const UserBlocInitial() : super(user: null, isLoading: false, isAuthenticated: false, message: "");
}

class UserBlocSuccess extends UserBlocState
{
	final String SuccessMessage;
	final bool AuthState;
	const UserBlocSuccess({required this.AuthState, required this.SuccessMessage}) : super(user: null, isLoading: false, isAuthenticated: AuthState, message: SuccessMessage);
}

class AuthenticationSuccess extends UserBlocState
{
	final String AuthMessage;
	final bool AuthState;
	final User? currentUser;
	const AuthenticationSuccess({required this.AuthState, required this.AuthMessage, required this.currentUser}) : super(user: currentUser, isLoading: false, isAuthenticated: AuthState, message: AuthMessage);
}

class Authenticationfailure extends UserBlocState
{
	final String errorMessage;
	const Authenticationfailure({required this.errorMessage}) : super(user: null, isLoading: false, isAuthenticated: false, message: errorMessage);
}

class UserBlocLoading extends UserBlocState
{
	final String loadingMsg;
	const UserBlocLoading({required this.loadingMsg}) : super(user: null, isLoading: true, isAuthenticated: false, message: loadingMsg);
}

class UserBlocFailure extends UserBlocState
{
	final String errorMessage;
	const UserBlocFailure({required this.errorMessage}):super(user: null, isLoading: false, isAuthenticated: false, message: errorMessage);
}