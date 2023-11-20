// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterpos/Bloc/modules/user_bloc.dart';
import 'package:logger/logger.dart';

import '../Models/user_datamodel.dart';

//Should simplify the form needed to handle login and registration with a user controllable context switch.
//Note that this context switch is not the BuildContext variable, but can be a boolean called isNewUser.
class LoginScreen extends StatefulWidget
{
	//Login uses the UserBloc so it makes sense to pass the initial instance down from the void main() function here.
	//Is there not a better way to achieve the same result? <scratches head> Not so sure...
	
	//Well bollocks to it, if this works, then bloody brilliant!
	
	//The nine hundred thousand nine hundred thirteen company (900913) isn't going to tell me how to write code, that's a bloody given!
	//It makes me think they've forgotten the ABC's of keeping coders happy, and supplied with ample amounts of coffee!
	
	///The 'userBloc' variable is a reference to the UserBloc instance passed down from the main function, used here in the constructor as a parameter.
	///This avoids instantiating it again, which can derail things, or cause a train-wreck. 
	///I highly advise you to specify it in the constructor when instantiating this screen widget, well you kinda' have to :D
	final UserBloc userBloc;
	const LoginScreen({required this.userBloc ,super.key});

	@override
	State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{
	//Import our bloc into the screen state class:

	//Control this boolean prop with the userbloc?
	//Use this var to conditionally render the retype password form and change the text on the submit button conditionally between 'log in' and 'register'?
	bool isNewUser = true;
	//Registration requires the use of an additional password controller.
	TextEditingController userNameController = TextEditingController();
	TextEditingController userFirstNameController = TextEditingController();
	TextEditingController userSurnameController = TextEditingController();
	TextEditingController passwordController = TextEditingController();
	TextEditingController retypePasswordController = TextEditingController();
	String selectedRole = "User";
	//Form key
	final _formKey=GlobalKey<FormState>();
	//Dropdown list:
	List<DropdownMenuItem<String>>? BuildItemList()
	{
		return Role.values.map((role)
		{
			return DropdownMenuItem(
				///Here we don't change anything because this is not a visual representation
				value: role.toString().split(".").last,

				//Replace them with spaces, because it looks better from a user interface perspective.
				child: Text(role.toString().split(".").last.replaceAll(r'_', ' ')), 
			);
		}).toList();
	}

	//Login and registration form:
	Widget LoginForm() 
	{
		return Padding(
		padding: const EdgeInsets.all(8.0),
			child: Form(
				key: _formKey,
				child: Column(
					children: [
						AnimatedSwitcher(
						duration: const Duration(milliseconds: 400),
						child: isNewUser 
							? KeyedSubtree(
								key: const ValueKey<bool>(true),
								child: Column(
									children: [
										TextFormField(
											controller: userNameController,
											decoration: const InputDecoration(
											labelText: "Username"
											),
											validator: (value) => value == "" ? "Please enter a username" : null,
										),
										TextFormField(
											controller: userFirstNameController,
											decoration: const InputDecoration(
											labelText: "Name"
											),
											validator: (value) => value == "" ? "Please enter your name" : null,
										),  
										TextFormField(
											controller: userSurnameController,
											decoration: const InputDecoration(
											labelText: "Surname"
											),
											validator: (value) => value == "" ? "Please enter your surname" : null,
										),  
										TextFormField(
											controller: passwordController,
											obscureText: true,
											decoration: const InputDecoration(
											labelText: "Password"
											),
											validator: (value) 
											{
												value == "" ? "Please enter a password" : null;
												if(value != retypePasswordController.text)
												{
													return "Passwords do not match";
												}
												return null;
											},
										),                      
										TextFormField(
											controller: retypePasswordController,
											obscureText: true,
											decoration: const InputDecoration(
											labelText: "Retype Password"
											),
											validator: (value) 
											{
											value == "" ? "Please reenter a password" : null;
											if(value != passwordController.text)
											{
												return "Passwords do not match";
											}
											return null;
											}
										),
										Row(
											mainAxisAlignment: MainAxisAlignment.center,
											children: [
												const Text("Role"),
												const SizedBox(width: 20),
												DropdownButton<String>(
													value: selectedRole,
													//Build this from the user datamodel -> role enum.
													items: BuildItemList() ?? [
													const DropdownMenuItem(
														value: "User",
														child: Text("User")
													)
													],
													onChanged: (value) => setState(() {
													selectedRole = value!;
													})
												)
											]
										),
									]
								)
							) 
							//Login
							: KeyedSubtree(
								key: const ValueKey<bool>(false),
								child: Column(
									children: [
										TextFormField(
											controller: userNameController,
											decoration: const InputDecoration(
												labelText: "Username"
											),
											validator: (value) => value == "" ? "Please enter a username" : null,
										),
										TextFormField(
											controller: passwordController,
											obscureText: true,
											decoration: const InputDecoration(
												labelText: "Password"
											),
											validator: (value) => value == "" ? "Please enter a password" : null,
										),
										const SizedBox(height: 206),
									]
								)
							),
						),
						//Add a slider or some on-off widget to control the isNewUser boolean?
						Row(
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								const Text("New user?"),
								const SizedBox(width: 20),
								Switch(value: isNewUser, onChanged: (value) => setState(() => isNewUser = value))
							],
						),           
						Row(
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								ElevatedButton(
								onPressed: ()
								{
									try
									{
										if(_formKey.currentState!.validate())
										{
											if(isNewUser)
											{
											final user = UserDataModel(
												userName: userNameController.text,
												fullName: "${userFirstNameController.text}  ${userSurnameController.text}",
												password: passwordController.text,
												userRole: MapRoleNameToRole(selectedRole),
												userRights: UserRightsHandler().GetUserRights(MapRoleNameToRole(selectedRole))
											);
											widget.userBloc.add(Register(userData: user));
											}
											else
											{
											widget.userBloc.add(Login(userName: userNameController.text,password: passwordController.text));
											}
										}
									}
									catch(ex)
									{
									ScaffoldMessenger.of(context).showSnackBar(
										const SnackBar(
										content: Text("Something went wrong during registration.")
										)
									);
									Logger().e("Exception occurred: $ex");
									}

								},
								child: isNewUser ? const Text("Register") : const Text("Log in"),
								),
								const SizedBox(width: 20),
								ElevatedButton(
								onPressed: ()
								{
									userNameController.clear();
									passwordController.clear();
									retypePasswordController.clear();
								},
								child: const Text("Clear"),
								)
							]
						)
					],
				),
			),
		);
	}

	@override
	//Nothing to see here yet.
	Widget build(BuildContext context)
	{
		return Scaffold(
		appBar: AppBar(
			title: const Text("Login"),
		),
		//Pass the state var? Wrap this in a bloc listener?
		body: BlocListener<UserBloc, UserBlocState>(
			listener:(context,state) 
			{
			if(state is RegistrationSuccess)
			{
				ScaffoldMessenger.of(context).showSnackBar(
				const SnackBar(
					content: Text("Registration successful"),
				)
				);
			}
			else if (state is LoginSuccess)
			{
				ScaffoldMessenger.of(context).showSnackBar(
				const SnackBar(
					content: Text("Login successful"),
				)
				);
				//Navigate to the mainscreen.
			}
			},
			child: BlocBuilder<UserBloc, UserBlocState>(
			builder: (context, state)
			{
				return LoginForm();
			}
			)
		)
		);
	}

	@override
	void dispose()
	{
		super.dispose();
	} 
}