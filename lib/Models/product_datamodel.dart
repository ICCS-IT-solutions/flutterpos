

// ignore_for_file: non_constant_identifier_names

import 'package:logger/logger.dart';

class Product
{
	final int product_id;
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
	DateTime? createdAt;
	DateTime? updatedAt;
	Product({required this.product_id, required this.productName, required this.supplierName, required this.description, required this.price, required this.imageData, required this.category, required this.stockQuantity, required this.onOrder, required this.threshold ,required this.shortages, this.createdAt, this.updatedAt});

	factory Product.fromDictionary(Map<String, dynamic> dictionary)
	{
		try
		{
			return Product(
				product_id: dictionary["product_id"],
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
				product_id: dictionary["product_id"],
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
			"product_id": product_id,
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
		};
	}
	//Create a copy of the target, allowing for its props to be overridden by new vals.
	copyWith({	
		int? product_id,
		String? productName,
		String? supplierName, 
		String? description, 
		double? price, String? 
		imageData, 
		String? category, 
		int? stockQuantity, 
		int? onOrder, 
		int? threshold, 
		int? shortages, })
	{
		return Product(
			product_id: product_id?? this.product_id,
			productName: productName?? this.productName,
			supplierName: supplierName?? this.supplierName,
			description: description?? this.description,
			price: price?? this.price,
			imageData: imageData?? this.imageData,
			category: category?? this.category,
			stockQuantity: stockQuantity?? this.stockQuantity,
			onOrder: onOrder?? this.onOrder,
			threshold: threshold?? this.threshold,
			shortages: shortages?? this.shortages,
		);
	}
}
