// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../Bloc/modules/menu_bloc.dart';
import '../Bloc/modules/user_bloc.dart';
import '../Models/menuitem_datamodel.dart';
import '../Models/user_datamodel.dart';
import '../Widgets/menuitem_dialog.dart';
//The menu screen should essentially be used to manage the menu items themselves, such as setting prices, deleting and/or adding new ones to the menu.
//The menu from which the user orders should be on the mainscreen. 
//What should be presented here is a tabulated list that can be managed with the appropriate user rights.
//To handle the user rights issue, we need the user bloc here too, and can look at the userBloc.state.currentUser to see what rights the user has.
class MenuScreen extends StatefulWidget
{
	final MenuBloc menuBloc;
	final UserBloc userBloc;
	const MenuScreen({required this.userBloc,required this.menuBloc, super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> 
{
	String? SelectedImage;
	@override
	void initState()
	{
		super.initState();
		widget.menuBloc.add(LoadMenuItems(menuItems: const []));
	}
	//Todo: Build these widgets out with the required functionality.
	Widget BuildMenuManagementUI(BuildContext context)
	{
		return Scaffold(
			appBar: AppBar(
				title: const Text('Menu - Management mode'),
				actions: [
					ElevatedButton.icon(onPressed: () => ShowMenuItemDialog(context), 
					icon: const Icon(Icons.add), 
					label:const Text("Add new menu item"))
				],
			),
			body: BuildEditableMenuEntries(),
		);
	}

	Future<void> ShowMenuItemDialog(BuildContext context, {MenuItem? existingItem}) async 
	{		
		if(mounted)
		{
			showDialog(context: context, builder: (context)
			{
				return StatefulBuilder(
					builder: (context,setState) 
					{
						return MenuItemDialog(menuBloc: widget.menuBloc ,existingItem: existingItem, onImageSelected: (newImage)
						{
							setState((){
								SelectedImage = newImage;
							});
						});
					}
				);
			});
		}	
	}

	Widget BuildEditableMenuEntries()
	{
		//Execute a menubloc -> load menu items event:
		widget.menuBloc.add(LoadMenuItems(menuItems: const []));
		//Use a bloc builder targeting the menu bloc:
		return BlocBuilder<MenuBloc, MenuBlocState>(
			builder: (context, state)
			{
				if(state is MenuBlocSuccess)
				{
					return ListView.builder(
						itemCount: state.menuItems!.length,
						itemBuilder: ((context, index)
						{
							return ListTile(
								title: Text(state.menuItems![index].menuItemName),
								subtitle: Row(
									children: [
										Column(
											mainAxisSize: MainAxisSize.min,
											children: [
												SizedBox(width:100,height:100,child: Image.memory(base64Decode(state.menuItems![index].menuItemimage!))),
											]
										),
										const SizedBox(width: 20,),
										Column(
											mainAxisSize: MainAxisSize.min,
											children: [
												Text(state.menuItems![index].menuItemDescription ?? "",
												),
												//Need to use the currency from the region of the user, or do I store that in the config file during initial setup?
												Text("Price: R ${state.menuItems![index].price.toString()}"
												),
											]
										)
									],
								),
								trailing: Row(
									mainAxisSize: MainAxisSize.min,
									children: [
										ElevatedButton.icon(onPressed: ()
										{
											ShowMenuItemDialog(context, existingItem: state.menuItems![index]);
										}, 
										icon: const Icon(Icons.refresh), 
										label: const Text("Update")
										),
										const SizedBox(width:10),
										ElevatedButton.icon(onPressed: ()
										{
											//Delete this item:
										},
										icon: const Icon(Icons.delete),
										label: const Text("Delete")
										),
									]
								),
							);
						})
					);
				}
				else
				{
					return const Center(
						child: Column(
							children: [
								Text('No menu items found'),
							]
						),
					);
				}
			}
		);
	}

	//End
	Widget BuildMenuUI(BuildContext context)
	{
		return Scaffold(
			appBar: AppBar(
				title: const Text('Menu - User mode'),
				//In the actions no add item button should be present
			),
			body: BuildReadonlyMenuEntries()
		);
	}

	Widget BuildReadonlyMenuEntries()
	{
		//Execute a menubloc -> load menu items event:
		widget.menuBloc.add(LoadMenuItems(menuItems: const []));
		//Use a bloc builder targeting the menu bloc:
		return BlocBuilder<MenuBloc, MenuBlocState>(
			builder: (context, state)
			{
				if(state is MenuBlocSuccess)
				{
					return ListView.builder(
						itemCount: state.menuItems!.length,
						itemBuilder: ((context, index)
						{
							return ListTile(
								title: Text(state.menuItems![index].menuItemName),
								subtitle: Row(
									children: [
										Column(
											mainAxisSize: MainAxisSize.min,
											children: [
												SizedBox(width:100,height:100,child: Image.memory(state.menuItems![index].menuItemimage! as Uint8List)),
											]
										),
										const SizedBox(width: 20,),
										Column(
											mainAxisSize: MainAxisSize.min,
											children: [
												Text(state.menuItems![index].menuItemDescription ?? ""
												),
												//Need to use the currency from the region of the user, or do I store that in the config file during initial setup?
												Text("Price: R ${state.menuItems![index].price.toString()}"
												),
											]
										)
									],
								),
							);
						})
					);
				}
				else
				{
					return const Center(
						child: Column(
							children: [
								Text('No menu items found'),
							]
						),
					);
				}
			}
		);
	}

	//End
	@override
	Widget build(BuildContext context)
	{
		return BlocBuilder<UserBloc,UserBlocState>(
			bloc: widget.userBloc,
			builder: (context, state)
			{	
				if(state is UserBlocInitial)
				{
					Logger().e("User bloc state is initial. There is no usable data present at this point.");
					return Scaffold(
						appBar: AppBar(
							title: const Text('Menu'),
						),
						body: const Center(
						child: CircularProgressIndicator()
						),
					);
				}
				final currentUser  = state.currentUser;
				Logger().i("Current user: ${currentUser?.fullName}");
				//Check whether the user has the Can_Manage_Inventory right:
				if(currentUser!.userRights.contains(UserRight.Can_Manage_Inventory))
				{
					return BuildMenuManagementUI(context);
				}
				else
				{
					return BuildMenuUI(context);
				}
			}
		);
	}
}