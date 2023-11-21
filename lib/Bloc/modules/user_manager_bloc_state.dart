// ignore_for_file: non_constant_identifier_names


part of 'user_manager_bloc.dart';

class UserManagerBlocState 
{
	final bool isLoading;
	final bool isAuthenticated;
	final String message;
	final List<User> users;

	const UserManagerBlocState({required this.users,required this.isLoading, required this.isAuthenticated, required this.message});
}

class UserManagerBlocInitial extends UserManagerBlocState 
{
	UserManagerBlocInitial() : super(users: [],isLoading: false, isAuthenticated: false, message: "");
}

class UserManagerBlocSuccess extends UserManagerBlocState
{
	final String SuccessMessage;
	final bool AuthState;
	final List<User> registeredUsers;

	UserManagerBlocSuccess({required this.registeredUsers, required this.AuthState, required this.SuccessMessage}) : super(users: registeredUsers, isLoading: false, isAuthenticated: AuthState, message: SuccessMessage);
}

class UserManagerBlocFailure extends UserManagerBlocState
{
	final String errorMessage;
	UserManagerBlocFailure({required this.errorMessage}) : super(users: [], isLoading: false, isAuthenticated: false, message: errorMessage);
}

class UserManagerBlocLoading extends UserManagerBlocState
{
	final String loadingMsg;
	UserManagerBlocLoading({required this.loadingMsg}) : super(users: [], isLoading: true, isAuthenticated: false, message: loadingMsg);
}