
import 'package:flutter/material.dart';
import 'package:flutterpos/Bloc/modules/inventory/productmanagement_bloc.dart';
import 'package:flutterpos/Bloc/modules/user_bloc.dart';

class ProductManagementScreen extends StatefulWidget
{
	final UserBloc userBloc;
	final ProductManagementBloc productManagementBloc;

	const ProductManagementScreen({required this.userBloc, required this.productManagementBloc, super.key});
	@override 
	State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}


class _ProductManagementScreenState extends State<ProductManagementScreen>
{
	@override
	Widget build(BuildContext context)
	{
		return Scaffold(
			appBar: AppBar(title: const Text("Product Management"),
			actions: [
				ElevatedButton(
					onPressed: (){},
					child: const Text("Add new")
				),
				ElevatedButton(
					onPressed: (){},
					child: const Text("Update")
				),
				ElevatedButton(
					onPressed: (){},
					child: const Text("Remove selected")
				),
			],
			),
			body: const Center(child: Text("Placeholder for products list.")),
		);
	}
}