class InventoryItem
{
	final int productId;
	final String productName;
	final int currentQuantity;
	final int shortages;
	final int orderedQuantity;
	final int lowThreshold;

	InventoryItem({required this.productId, required this.productName, required this.currentQuantity, required this.shortages, required this.orderedQuantity, required this.lowThreshold});

	factory InventoryItem.fromDictionary(Map<String, dynamic> dictionary)
	{
		return InventoryItem(
			productId: dictionary["product_id"],
			productName: dictionary["product_name"],
			currentQuantity: dictionary["current_quantity"],
			shortages: dictionary["shortages"],
			orderedQuantity: dictionary["ordered_quantity"],
			lowThreshold: dictionary["low_threshold"],
		);
	}

	Map<String, dynamic> toDictionary()
	{
		final dictionary =
		{
			"product_id": productId,
			"product_name": productName,
			"current_quantity": currentQuantity,
			"shortages": shortages,
			"ordered_quantity": orderedQuantity,
			"low_threshold": lowThreshold,
		};
		return dictionary;
	}

	//Create a copywith function in all my other datamodel classes. It will help a shitload to fix updating them :D
	copyWith({required int productId, required String productName, required int currentQuantity, required int shortages, required int orderedQuantity, required int lowThreshold})
	{
		return InventoryItem(
			productId: productId,
			productName: productName,
			currentQuantity: currentQuantity,
			shortages: shortages,
			orderedQuantity: orderedQuantity,
			lowThreshold: lowThreshold
		);
	}
}