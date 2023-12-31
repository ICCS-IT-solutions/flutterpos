
// ignore_for_file: non_constant_identifier_names

import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:logger/logger.dart";

import "package:flutterpos/Bloc/modules/local/menu_bloc.dart";
import "../Models/menuitem_datamodel.dart";

//My rules: 4 space indents. 
//Line up all curly brackets vertically. 
//The Exception to this is the setstate method and some build methods when sufficiently short.

class MenuItemDialog extends StatefulWidget 
{
	final MenuItem? existingItem;
	final MenuBloc menuBloc;
	final Function(String?) onImageSelected;
	final VoidCallback? onActionDone;
    const MenuItemDialog({this.onActionDone, super.key, required this.menuBloc, this.existingItem, required this.onImageSelected});

	@override
	State<MenuItemDialog> createState() => _MenuItemDialogState();
}

class _MenuItemDialogState extends State<MenuItemDialog> 
{
	TextEditingController itemNameController = TextEditingController();
	TextEditingController itemDescriptionController = TextEditingController();
	TextEditingController itemPriceController = TextEditingController();
	String? SelectedImage;
	
	@override
	void initState()
	{
		super.initState();
		SelectedImage = widget.existingItem?.menuItemimageData;
	}
    @override
    Widget build(BuildContext context)
    {
		if (widget.existingItem!=null)
		{
			itemNameController.text = widget.existingItem!.menuItemName;
			itemDescriptionController.text = widget.existingItem!.menuItemDescription ?? "";
			itemPriceController.text = widget.existingItem!.price.toString();
			SelectedImage = widget.existingItem!.menuItemimageData;
		}
        return AlertDialog(
			title: const Text("Add new menu item"),
			content: SingleChildScrollView(
				child: Column(
					children: [
						TextField(
							controller: itemNameController,
							decoration: const InputDecoration(
								labelText: "Menu item name",
							)
						),
						TextField(
							controller: itemDescriptionController,
							decoration: const InputDecoration(
								labelText: "Menu item description",
							)
						),
						TextField(
							controller: itemPriceController,
							decoration: const InputDecoration(
								labelText: "Menu item price",
							)
						),
						//How the bloody hell do I get this to work properly?
						const SizedBox(height: 10),
						BuildImageSelector(),
						Row(
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								//Submit and clear buttons:
								ElevatedButton(
									onPressed: () async 
									{
										final menuItem = MenuItem(
											menuItemName: itemNameController.text,
											menuItemDescription: itemDescriptionController.text,
											price: double.parse(itemPriceController.text),
											menuItemimageData: SelectedImage, //Replace this with our selected image so as to not trigger the image picker again.
										);
										if(widget.existingItem != null)
										{	
											//Got you, you filthy bugger! 
											//Now it will update as it should.
											final updatedMenuItem = widget.existingItem!.copyWith(
												menuItemName: menuItem.menuItemName,
												menuItemDescription: menuItem.menuItemDescription,
												price: menuItem.price,
												menuItemimageData: menuItem.menuItemimageData
											);
											widget.menuBloc.add(UpdateMenuItem(updatedMenuItem));
										}
										else
										{
											widget.menuBloc.add(AddMenuItem(menuItem));
										}
										Navigator.of(context).pop();
										widget.menuBloc.add(LoadMenuItems(menuItems: const []));
									},
									child: const Text("Submit"),
								),
								//Gotta space 'em out!
								const SizedBox(width: 20),
								ElevatedButton(
									onPressed: () 
									{
										itemNameController.clear();
										itemDescriptionController.clear();
										itemPriceController.clear();
										Navigator.of(context).pop();
									},
									child: const Text("Cancel")
								),
							]
						)
					],
				)
			)
		);
    }
	//When I open the dialog, the image updates accordingly... but why not when this is triggered by the select image button?
	Widget BuildImageSelector()
	{
		return Column(
			children: [
				const Text("Select image"),
				const SizedBox(height: 10),
				//Create a placeholder for the image using a sizedbox
				//How to do this so the image updates? State builder? Not sure...
				Builder(
				  builder: (context) 
				  	{
				    	return SelectedImage != null 
				    	? SizedBox(width: 200, height: 200, child: Image.memory(base64Decode(SelectedImage!))) 
				    	: SizedBox(width: 200, height: 200, child:Container(color: Colors.black,));
				  	}
				),
				const SizedBox(height: 10),
				ElevatedButton.icon(
					onPressed: () async
					{
					String? newImageb64 = await SelectImage();
					if(newImageb64 != null)
						{
							setState(() {
								SelectedImage = newImageb64;
							});
						}
					},
					icon: const Icon(Icons.add_a_photo),
					label: const Text("Select image")
				),
				const SizedBox(height: 10),
			]
		);
	}
Future<String?> SelectImage() async
	{
		try
		{
			final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
			if(image != null)
			{
				File imageFile = File(image.path);
				Logger().i(imageFile.path);
				final imageBytes = await imageFile.readAsBytes();
				SelectedImage = base64Encode(imageBytes);
				return SelectedImage;
			}
			else
			{
				if(mounted)
				{
					ScaffoldMessenger.of(context).showSnackBar(
						const SnackBar(
							content: Text("No image selected"),
						)
					);
					File imageFile = File("../images/placeholder.png");
					final imageBytes = await imageFile.readAsBytes();
					SelectedImage = base64Encode(imageBytes);
					return SelectedImage;
				}
				return null;
			}
		}
		catch(ex)
		{
			Logger().e("Something went wrong while trying to encode your image.\nException: $ex");
			return null;
		}
	}	

}