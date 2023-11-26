import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutterpos/Bloc/modules/local/inventory/inventorymanagement_bloc.dart";
import "package:flutterpos/Bloc/modules/local/inventory/productmanagement_bloc.dart";
import "package:flutterpos/Bloc/modules/local/inventory/shortagemanagement_bloc.dart";
import "package:flutterpos/Bloc/modules/local/inventory/suppliermanagement_bloc.dart";
import 'package:flutterpos/Bloc/modules/local/admin/user_manager_bloc.dart';
import "package:flutterpos/Screens/localinst/inventory/inventorymanagement.dart";

import "package:flutterpos/Bloc/modules/local/inventory/order_manager_bloc.dart";
import "package:flutterpos/Bloc/modules/local/menu_bloc.dart";
import "package:flutterpos/Bloc/modules/local/user_bloc.dart";
import "package:flutterpos/Models/localuser_datamodel.dart";
import "menuscreen.dart";
import "usermanagerscreen.dart";

class MainScreen extends StatelessWidget 
{
	final UserBloc userBloc;
	final MenuBloc menuBloc;
	final UserManagerBloc userManagerBloc;
	final OrderManagerBloc orderManagerBloc;
	final InventorymanagementBloc inventoryManagementBloc;
	final SupplierManagementBloc supplierManagementBloc;
	final ProductManagementBloc productManagementBloc;
	final ShortageManagementBloc shortageManagementBloc;
	//Add the instances and params for the other blocs as needed, also so they can be passed to the other screen classes when instantiated, thus managing them from a central loc rather than all over the place...
	//As again, in my code files, I rule, therefore I decide the style rules :P
	//One most important rule: No stair-stepped curly brackets, line them up vertically. 
	//Need a way to set the tab stop to 4 spaces not two, ugh.
	const MainScreen({required this.userManagerBloc,
	required this.orderManagerBloc,
	required this.menuBloc, 
	required this.userBloc,
	required this.inventoryManagementBloc,
	required this.supplierManagementBloc,
	required this.productManagementBloc,
	required this.shortageManagementBloc,
	super.key});

	@override
	Widget build(BuildContext context) 
	{
		menuBloc.add(LoadMenuItems(menuItems: const []));
		return BlocBuilder<UserBloc, UserBlocState>(
			builder: (context,state) 
			{
				return Scaffold(
					appBar: AppBar(
						//In the app bar we should show the currently logged-in user's full name, and possibly the computer or device they are logged in on.
						
						//For the woke brigade: 
						//Note that I use gender-neutral terminology in the linguistically CORRECT manner, because I don't know the actual gender of the user, also it is not an important datapoint in POS software.
						//I also don't care a jot about your pro-conformity rhetoric that wears the colours of diversity like a wolf does sheep's clothes, so there you have it...
						
						title: Row(
						children: [
							const Text('Restaurant & Bar'),
							const SizedBox(width: 80),
							Text(userBloc.state.user!.fullName ?? ""),
						],
						),
						actions: [
							//User manager should not be visible to users without the appropriate rights.
							//Valid user roles: Administrator, Manager, Supervisor
							//All others: access denied.
							ElevatedButton.icon(
								onPressed: ()
								{
									if(userBloc.state.user!.userRole == LocalUserRole.Administrator || userBloc.state.user!.userRole == LocalUserRole.Manager || userBloc.state.user!.userRole == LocalUserRole.Supervisor)
									{
										Navigator.of(context).push(
											MaterialPageRoute(
											builder: (context) 
												{
													return UserManagementScreen(userBloc: userBloc, userManagerBloc: userManagerBloc);
												},
											)
										);
									}
									else
									{
										showDialog(
											context: context,
											builder: (context)
											{
												return AlertDialog(
													title: const Text("Access denied"),
													content: const Text("You do not have the required rights to access this feature."),
													actions: [
														TextButton(
															onPressed: ()
															{
																Navigator.of(context).pop();
															},
															child: const Text("OK")
														)
													]
												);
											}
										);
									}
								},
								icon: const Icon(Icons.settings_applications_outlined),
								label: const Text("User management")
							),
							ElevatedButton.icon(onPressed: ()
							{
								Navigator.of(context).push(
									MaterialPageRoute(
										builder: (context) => MenuScreen(userBloc: userBloc, menuBloc: menuBloc),
									)
								);
							}, 
							icon: const Icon(Icons.menu_open), 
							label: const Text("See detailed menu")
								),
							ElevatedButton.icon(onPressed:()
								{
									Navigator.of(context).push(
										MaterialPageRoute(
											builder: (context) 
											{
												return InventoryManagementScreen(userBloc: userBloc,
												supplierManagementBloc: supplierManagementBloc,
												orderManagerBloc: orderManagerBloc, 
												inventoryManagementBloc:inventoryManagementBloc,
												productManagementBloc: productManagementBloc,
												shortageManagementBloc: shortageManagementBloc);
											}
										)
									);
								}, 
							icon: const Icon(Icons.checklist_outlined), 
							label: const Text("Inventory management")),
							ElevatedButton.icon(
								onPressed: () 
								{
								//If the bloc is closed, how to reactivate it?
								userBloc.add(Logoff());
								},
							icon: const Icon(Icons.logout), 
							label: const Text('Log off'))
						],
					),
					body: BlocBuilder<MenuBloc, MenuBlocState>(
						builder: (context, state) 
						{
							if(state is MenuBlocSuccess)
							{
								return GridView.builder(
									gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8, crossAxisSpacing: 4, mainAxisSpacing: 4), 
									itemCount: state.menuItems!.length,
									itemBuilder: (context, index)
										{
											try
											{
												if(index <= state.menuItems!.length)
												{
												return Container(
												decoration: BoxDecoration(
													image:DecorationImage(image:Image.memory(base64Decode(state.menuItems![index].menuItemimageData!)).image,	fit:BoxFit.cover)
												),
												child: ListTile(
													title: Text(state.menuItems![index].menuItemName),
														subtitle: Row(
															children: [
																Text(state.menuItems![index].price.toString()),
															]
														),
														onTap:() {
															ScaffoldMessenger.of(context).showSnackBar(
																const SnackBar(
																	content: Text('Item selected'),
																)
															);
														}),
													);
												}
												else
												{
													return const ListTile(
														title: Text('No menu item found'),
														subtitle: Text('There is no item to load. Please add one first.'),
													);
												}
											}
											catch(ex)
											{
												return const ListTile(
													title: Text('No menu item found'),
													subtitle: Text('There is no item to load. Please add one first.'),
												);
											}

										}
								);
							}
							else
							{
								return const Center(
									child: Text('No menu items found'),
								);
							}
						},
					),
					floatingActionButton: FloatingActionButton.extended(
						onPressed: () {
						// Handle floating action button action (e.g., navigate to order screen).
						},
						label: const Text('Place Order'),
						icon: const Icon(Icons.check),
					),
				);
			}
		);
	}
}
