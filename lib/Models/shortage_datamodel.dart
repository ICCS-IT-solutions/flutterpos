// ignore_for_file: non_constant_identifier_names

class Shortage
{
	final int user_id;
	final String user_name;
	final int product_id;
	final String product_name;
	final int shortage_quantity;

	Shortage({required this.user_id, required this.user_name, required this.product_id, required this.product_name, required this.shortage_quantity});

	factory Shortage.fromDictionary(Map<String, dynamic> dictionary)
	{
		return Shortage(
			user_id: dictionary['user_id'],
			user_name: dictionary['user_name'],
			product_id: dictionary['product_id'],
			product_name: dictionary['product_name'],
			shortage_quantity: dictionary['shortage_quantity']
		);
	}

	Map<String, dynamic> toDictionary()
	{
		return {
			'user_id': user_id,
			'user_name': user_name,
			'product_id': product_id,
			'product_name': product_name,
			'shortage_quantity': shortage_quantity
		};
	}
	copyWith({required int? user_id, required String? user_name, required int? product_id, required String? product_name ,required int? shortage_quantity})
	{
		return Shortage(
			user_id: user_id?? this.user_id,
			user_name: user_name?? this.user_name,
			product_id: product_id?? this.product_id,
			product_name: product_name?? this.product_name,
			shortage_quantity: shortage_quantity?? this.shortage_quantity
		);
	}
}