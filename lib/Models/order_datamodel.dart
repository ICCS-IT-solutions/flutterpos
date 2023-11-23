// ignore_for_file: non_constant_identifier_names

class Order
{
	final int product_id;
	final String product_name;
	final int amount_to_order;
	final bool is_submitted;
	//These props will be created by the database engine, and should not be touched by the frontend. 
	//We need to be able to retrieve them however, but NOT submit them unless absolutely necessary.
	DateTime? created_at;
	DateTime? updated_at;

	Order(this.product_id, this.product_name, this.amount_to_order, this.is_submitted, this.created_at, this.updated_at);

	factory Order.fromDictionary(Map<String, dynamic> dictionary)
	{
		return Order(
			dictionary["product_id"],
			dictionary["product_name"],
			dictionary["amount_to_order"],
			dictionary["is_submitted"],
			dictionary["created_at"],
			dictionary["updated_at"]
		);
	}
	//Create a dictionary of our order to be uploaded to the database. 
	//For now, use a simple key value map for each prop.
	//As the order might grow more complex, it may be necessary to support an embedded dataset mapping stock items to their ordered quantities.
	Map<String, dynamic> toDictionary()
	{
		final dictionary = {
			"product_id": product_id,
			"product_name": product_name,
			"amount_to_order": amount_to_order,
			"is_submitted": is_submitted, //This is a bool prop, and in the db it is an enum with values Y and N.
			"created_at": created_at,
			"updated_at": updated_at
		};
		return dictionary;
	}
	
	//for updating these entries:
	copyWith({required int product_id, required String product_name, required int amount_to_order, required bool is_submitted, DateTime? created_at, DateTime? updated_at})
	{
		return Order(
			product_id,
			product_name,
			amount_to_order,
			is_submitted,
			created_at?? this.created_at,
			updated_at?? this.updated_at
		);
	}
}