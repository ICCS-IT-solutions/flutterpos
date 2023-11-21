part of 'user_manager_bloc.dart';

@immutable
sealed class UserManagerBlocEvent 
{}

class Register extends UserManagerBlocEvent 
{
	final User userData;
	Register({required this.userData});
}

class LoadUsers extends UserManagerBlocEvent 
{
	//retrieve registered users from the database
	final List<User> users;
	LoadUsers({required this.users});
}

class EditUser extends UserManagerBlocEvent 
{
	final User userData;
	EditUser({required this.userData});
}