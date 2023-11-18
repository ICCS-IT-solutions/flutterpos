// ignore_for_file: non_constant_identifier_names

part of 'user_bloc.dart';

@immutable
class UserBlocState 
{
	final List<UserDataModel> users;
	final UserDataModel? currentUser;
	final bool isLoading;
	final bool isAuthenticated;
	final String message;

	const UserBlocState({required this.users, required this.currentUser, required this.isLoading, required this.isAuthenticated, required this.message});

	factory UserBlocState.Initial() 
	{
		return const UserBlocState(users: [], currentUser: null, isLoading: true, isAuthenticated: false, message: "");
	}
	factory UserBlocState.LoginInitial() 
	{
		return const UserBlocState(users: [], currentUser: null, isLoading: true, isAuthenticated: false, message: "");
	}
	factory UserBlocState.LoginSuccess({String? successMsg, List<UserDataModel>? users, UserDataModel? currentUser}) 
	{
		return UserBlocState(users: const [], currentUser: null, isLoading: false, isAuthenticated: true, message: successMsg ?? "");
	}
	factory UserBlocState.LoginFailed({String? errorMsg}) 
	{
		return UserBlocState(users: const [], currentUser: null, isLoading: false, isAuthenticated: false, message: errorMsg ?? "");
	}
	factory UserBlocState.RegisterInitial() 
	{
		return const UserBlocState(users: [], currentUser: null, isLoading: true, isAuthenticated: false, message: "");
	}
	factory UserBlocState.RegisterSuccess({String? successMsg}) 
	{
		return UserBlocState(users: const [], currentUser: null, isLoading: false, isAuthenticated: true, message: successMsg ?? "");
	}
	factory UserBlocState.RegisterFailed({String? errorMsg}) 
	{
		return UserBlocState(users: const [], currentUser: null, isLoading: false, isAuthenticated: false, message: errorMsg ?? "");
	}
}
class UserBlocInitial extends UserBlocState
{
	const UserBlocInitial() : super(users: const [], currentUser: null, isLoading: false, isAuthenticated: false, message: "");
}
class LoginFailed extends UserBlocState
{
	const LoginFailed({required String errorMsg, required bool isAuthenticated})  : super(users: const [], currentUser: null, isLoading: false, isAuthenticated: false, message: errorMsg);
}

class LoginSuccess extends UserBlocState
{
	const LoginSuccess({required String successMsg, required super.users, required UserDataModel super.currentUser, required bool isAuthenticated})  : super(isLoading: false, isAuthenticated: true, message: successMsg); 
}

class LogoffSuccess extends UserBlocState
{
	const LogoffSuccess({required String successMsg, required bool isAuthenticated}) : super(users: const [], currentUser: null, isLoading: false, isAuthenticated: false, message: "Logged off successfully");
}

class RegistrationFailed extends UserBlocState
{
	const RegistrationFailed({required String errorMsg})  : super(users: const [], currentUser: null, isLoading: false, isAuthenticated: false, message: errorMsg);
}

class RegistrationSuccess extends UserBlocState
{
	const RegistrationSuccess({required String successMsg})  : super(users: const [], currentUser: null, isLoading: false, isAuthenticated: true, message: successMsg);
}
