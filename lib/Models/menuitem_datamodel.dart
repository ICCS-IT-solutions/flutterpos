//This is a datamodel based on a subset of the product dataset.
import 'package:logger/logger.dart';

class MenuItem
{
	//important props to have: name, price, image, description - map these to the product dataset from the db
	final String menuItemName;
	final String? menuItemDescription;
	final double price;
	final String? menuItemimageData;

	MenuItem({required this.menuItemName, required this.menuItemDescription, required this.price, required this.menuItemimageData});

	factory MenuItem.fromDictionary(Map<String, dynamic> dictionary)
	{
		try
		{
			//Might be a bit hackish, but it gets the job done.
			return MenuItem(
				menuItemName: dictionary["menuitem_name"],
				//The value returned is blob, but how do i get back a string from it?
				menuItemDescription: dictionary["menuitem_description"].toString(),
				price: (dictionary["price"] is String) ? double.parse(dictionary["price"]) : (dictionary["price"] as num).toDouble(),
				menuItemimageData: dictionary["menuitem_image"].toString(),
			);
		}
		catch(ex)
		{
			Logger().e(ex);
			return MenuItem(
				menuItemName: dictionary["menuitem_name"],
				menuItemDescription: dictionary["menuitem_description"].toString(),
				price: (dictionary["price"] is String) ? double.parse(dictionary["price"]) : (dictionary["price"] as num).toDouble(),
				menuItemimageData: null,
			);
		}
	}

	Map<String, dynamic> toDictionary()
	{
		final dictionary = {
			"menuitem_name": menuItemName,
			"menuitem_description": menuItemDescription,
			"price": price,
			"menuitem_image": menuItemimageData!,
		};
		return dictionary;
	}
}