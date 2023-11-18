import 'dart:typed_data';

class ProductDataModel
{
	final String productName; //product_name : varchar
	final String description; //description: text
	final String price; //price : decimal
	final Uint8List image; //not present, probably should create this as a varchar to store a link to an image or the file name and path if local storage
	final String category;
	final int stockQuantity;
	final int shortages; //How many items went missing, and on whose watch did this occur?
	final DateTime createdAt;
	final DateTime updatedAt;
	ProductDataModel({required this.productName, required this.description, required this.price, required this.image, required this.category, required this.stockQuantity, required this.shortages, required this.createdAt, required this.updatedAt});

	factory ProductDataModel.fromDictionary(Map<String, dynamic> dictionary)
	{
		return ProductDataModel(
			productName: dictionary["product_name"],
			description: dictionary["description"],
			price: dictionary["price"],
			image: dictionary["image"],
			category: dictionary["category"],
			stockQuantity: dictionary["quantity"],
			shortages: dictionary["shortages"],
			createdAt: dictionary["created_at"],
			updatedAt: dictionary["updated_at"],
		);
	}
	Map<String, dynamic> toDictionary()
	{
		return {
			"product_name": productName,
			"description": description,
			"price": price,
			"image": image,
			"category": category,
			"quantity": stockQuantity,
			"shortages": shortages,
			"created_at": createdAt,
			"updated_at": updatedAt,
		};
	}
}
