
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterpos/Bloc/modules/local/inventory/productmanagement_bloc.dart';
import 'package:flutterpos/Bloc/modules/local/user_bloc.dart';

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
	void initState()
	{
		super.initState();
		widget.productManagementBloc.add(LoadProducts(products: const []));
	}
	
	Widget BuildProductsList(BuildContext context)
	{
		//Use a blocbuilder here.
		return BlocBuilder<ProductManagementBloc, ProductManagementBlocState>(
			builder: (context, state)
			{
				if (state is ProductManagementBlocSuccess)
				{
					//Datatable is good, but i want something where the rows can be selected.
					return DataTable(
						columns: const [
							DataColumn(label: Text("Product ID")),
							DataColumn(label: Text("Product name")),
							DataColumn(label: Text("Category")),
							DataColumn(label: Text("Price")),
							DataColumn(label: Text("Quantity")),
							DataColumn(label: Text("Date registered")),
						],
						rows: state.products!.map((product)
						{
							return DataRow(
								cells: [
									DataCell(Text(product.product_id.toString())),
									DataCell(Text(product.productName)),
									DataCell(Text(product.category)),
									DataCell(Text(product.price.toString())),
									DataCell(Text(product.stockQuantity.toString())),
									DataCell(Text(product.createdAt.toString())),
								]
							);
						}).toList()
					);
				}
				else
				{
					return const Center(child: Text("No products found."));
				}
			}
		);
	}

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
			body: BuildProductsList(context),
		);
	}
}