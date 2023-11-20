import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutterpos/Screens/ordermanagerscreen.dart";

import "../Bloc/modules/order_manager_bloc.dart";
import "../Bloc/modules/menu_bloc.dart";
import "../Bloc/modules/user_bloc.dart";
import "menuscreen.dart";

class MainScreen extends StatelessWidget 
{
	final UserBloc userBloc;
	final MenuBloc menuBloc;
	final OrderManagerBloc orderManagerBloc;
	//Add the instances and params for the other blocs as needed, also so they can be passed to the other screen classes when instantiated, thus managing them from a central loc rather than all over the place...
	//As again, in my code files, I rule, therefore I decide the style rules :P
	//One most important rule: No stair-stepped curly brackets, line them up vertically. 
	//Need a way to set the tab stop to 4 spaces not two, ugh.
	const MainScreen({required this.orderManagerBloc,required this.menuBloc, required this.userBloc, super.key});

	@override
	Widget build(BuildContext context) 
	{
		menuBloc.add(LoadMenuItems(menuItems: []));
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
				    Text(userBloc.state.currentUser!.fullName ?? ""),
				  ],
				),
				actions: [
					//Log off
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
					ElevatedButton.icon(onPressed: ()
					{
						Navigator.of(context).push(
							MaterialPageRoute(
								builder: (context)=>OrderManagerScreen(userBloc: userBloc, orderManagerBloc: orderManagerBloc)
							)
						);
					}, 
					icon: const Icon(Icons.checklist_outlined), 
					label: const Text("Order manager")),
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
}
