// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterpos/Bloc/modules/local/user_bloc.dart';

import 'package:flutterpos/Bloc/modules/local/admin/user_manager_bloc.dart';

class UserManagementScreen extends StatefulWidget 
{
	//Need a separate bloc class to handle the user manager. 
	//Using the user bloc to manage users is conflicting with its purpose of handling auth.
	final UserManagerBloc userManagerBloc;
	final UserBloc userBloc;
	const UserManagementScreen({required this.userBloc, required this.userManagerBloc, super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> 
{
	@override 
	void initState()
	{
		super.initState();
		widget.userManagerBloc.add(LoadUsers(users:const []));
	}
	@override
	Widget build(BuildContext context) 
	{
		return Scaffold(
			appBar: AppBar(
				title: const Text('User Management'),
				actions: [
					//Two buttons in the app bar:
					ElevatedButton.icon(onPressed: (){}, icon: const Icon(Icons.add_sharp), label: const Text("New user")),
					ElevatedButton.icon(onPressed: (){}, icon: const Icon(Icons.remove_sharp), label: const Text("Remove user")),
				]),
			body: BuildUsersList(context)
		);
	}

	Widget BuildUsersList(BuildContext context)
	{
		//Construct this list in the same style as the order manager data table:
		return BlocBuilder<UserManagerBloc,UserManagerBlocState>(builder: (context,state)
		{
			if(state is UserManagerBlocSuccess)
			{
				return SingleChildScrollView(
				scrollDirection: Axis.vertical,
				child: DataTable(
					columns: const [
						DataColumn(label: Text("User name")),
						DataColumn(label: Text("Full name")),
						DataColumn(label: Text("Registered email address")),
						DataColumn(label: Text("Role"))
						],
					rows: state.users.map((user)
					{
						return DataRow(cells: [
							DataCell(Text(user.userName)),
							DataCell(Text(user.fullName!)),
							DataCell(Text(user.emailAddress!)),
							DataCell(Text(user.userRole.toString().split(".").last))
						]);
					}).toList())
				);
			}
			else
			{
				return const Center(child: Text("No users found."));
			}
		});
	}
}