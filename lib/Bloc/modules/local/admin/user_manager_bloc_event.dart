part of 'user_manager_bloc.dart';

@immutable
sealed class UserManagerBlocEvent 
{}

class Register extends UserManagerBlocEvent 
{
	final LocalUser userData;
	Register({required this.userData});
}

class LoadUsers extends UserManagerBlocEvent 
{
	//retrieve registered users from the database
	final List<LocalUser> users;
	LoadUsers({required this.users});
}

class EditUser extends UserManagerBlocEvent 
{
	final LocalUser userData;
	EditUser({required this.userData});
}

class DeleteUser extends UserManagerBlocEvent
{
	final LocalUser userData;
	DeleteUser({required this.userData});
}