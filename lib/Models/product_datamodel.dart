

import 'package:logger/logger.dart';

class Product
{
	final String productName; //product_name : varchar
	final String supplierName;
	final String description; //description: text
	final double price; //price : decimal
	final String? imageData; //not present, probably should create this as a varchar to store a link to an image or the file name and path if local storage
	final String category;
	final int stockQuantity;
	final int onOrder;
	final int threshold;
	final int shortages; //How many items went missing, and on whose watch did this occur?
	final DateTime createdAt;
	final DateTime updatedAt;
	Product({required this.productName, required this.supplierName, required this.description, required this.price, required this.imageData, required this.category, required this.stockQuantity, required this.onOrder, required this.threshold ,required this.shortages, required this.createdAt, required this.updatedAt});

	factory Product.fromDictionary(Map<String, dynamic> dictionary)
	{
		try
		{
			return Product(
				productName: dictionary["product_name"],
				supplierName: dictionary["supplier_name"] ?? "",
				description: dictionary["description"].toString(),
				price: (dictionary["price"] is String) ? double.parse(dictionary["price"]) : (dictionary["price"] as num).toDouble(),
				imageData: dictionary["image"].toString(),
				category: dictionary["category"],
				stockQuantity: dictionary["quantity"],
				onOrder: dictionary["on_order"],
				threshold: dictionary["threshold"],
				shortages: dictionary["shortages"],
				createdAt: dictionary["created_at"],
				updatedAt: dictionary["updated_at"],
			);
		}
		catch(ex)
		{
			Logger().e(ex);
			return Product(
				productName: dictionary["product_name"],
				supplierName: dictionary["supplier_name"] ?? "",
				description: dictionary["description"].toString(),
				price: (dictionary["price"] is String) ? double.parse(dictionary["price"]) : (dictionary["price"] as num).toDouble(),
				imageData: null,
				category: dictionary["category"],
				stockQuantity: dictionary["quantity"],
				onOrder: dictionary["on_order"],
				threshold: dictionary["threshold"],
				shortages: dictionary["shortages"],
				createdAt: dictionary["created_at"],
				updatedAt: dictionary["updated_at"],
			);
		}
	}
	Map<String, dynamic> toDictionary()
	{
		return {
			"product_name": productName,
			"supplier_name": supplierName,
			"description": description,
			"price": price,
			"image": imageData,
			"category": category,
			"quantity": stockQuantity,
			"on_order": onOrder,
			"threshold": threshold,
			"shortages": shortages,
			"created_at": createdAt,
			"updated_at": updatedAt,
		};
	}
}
