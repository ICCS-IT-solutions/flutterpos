
// ignore_for_file: non_constant_identifier_names

import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:logger/logger.dart";

import "../Bloc/modules/menu_bloc.dart";
import "../Models/menuitem_datamodel.dart";

class MenuItemDialog extends StatefulWidget 
{
	final MenuItem? existingItem;
	final MenuBloc menuBloc;
	final Function(String?) onImageSelected;
    const MenuItemDialog({super.key, required this.menuBloc, this.existingItem, required this.onImageSelected});

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
		SelectedImage = widget.existingItem?.menuItemimage;
	}
    @override
    Widget build(BuildContext context)
    {
		if (widget.existingItem!=null)
		{
			itemNameController.text = widget.existingItem!.menuItemName;
			itemDescriptionController.text = widget.existingItem!.menuItemDescription ?? "";
			itemPriceController.text = widget.existingItem!.price.toString();
			SelectedImage = widget.existingItem!.menuItemimage;
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
											menuItemimage: SelectedImage, //Replace this with our selected image so as to not trigger the image picker again.
										);
										if(widget.existingItem != null)
										{
											widget.menuBloc.add(UpdateMenuItem(widget.existingItem!));
										}
										else
										{
											widget.menuBloc.add(AddMenuItem(menuItem));
										}
										Navigator.of(context).pop();
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
									child: const Text("Clear")
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
				//Logging tells me that when this method fires the image path is updated as it should be, but how do I update the image
				//shown in the selector?
				//How can I trigger this image update ? 
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