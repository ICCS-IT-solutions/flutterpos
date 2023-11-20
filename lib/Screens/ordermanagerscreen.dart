// ignore_for_file: non_constant_identifier_names
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/modules/order_manager_bloc.dart';
import '../Bloc/modules/user_bloc.dart';

class OrderManagerScreen extends StatefulWidget
{	
	final OrderManagerBloc orderManagerBloc;
	final UserBloc userBloc;
	//Need to keep track of the currently logged-in user 
	
	const OrderManagerScreen({required this.userBloc, required this.orderManagerBloc, super.key});

	@override
	State<OrderManagerScreen> createState() => _OrderManagerScreenState();
}

class _OrderManagerScreenState extends State<OrderManagerScreen>
{
	@override 
	void initState()
	{
		super.initState();
		widget.orderManagerBloc.add(LoadProducts());
	}
	@override
	Widget build(BuildContext context)
	{
		//Need to build a list of stock items returned from the database -> products table.
		return Scaffold(
			appBar: AppBar(
				title: const Text("Order manager"),
				actions: [
					ElevatedButton(onPressed: (){}, child: Text("Add item")),
					ElevatedButton(onPressed: (){}, child: Text("Remove item")),
				],
			),
			body: BuildProductsList(context)
		);		
	}
	Widget BuildProductsList(BuildContext context)
	{	
		//Size = missing? WTFH? Infer it from the parent, NEVER assume infinity or null!
		return Column(
			children: [
				//Header row
				const Row(
					children: [
						Expanded(child: Text("Product name")),
						Expanded(child: Text("Price")),
						Expanded(child: Text("Category")),
						Expanded(child: Text("Quantity")),
						Expanded(child: Text("Shortages")),
						Expanded(child: Text("Supplier")),
						SizedBox(width:50),
						Expanded(child: Text("Actions")),
					]
				),
				//List body
				Expanded(
					child: BlocBuilder<OrderManagerBloc, OrderManagerBlocState>(
						builder: (context, state)
						{
							if(state is OrderManagerBlocSuccess)
							{
								return SingleChildScrollView(
									scrollDirection: Axis.vertical,
									child: Column(
										children: List.generate(state.products.length, (index)
										{		
											return Padding(
												padding: const EdgeInsets.all(4),
												child:Row(
												children: [
													Expanded(child: Text(state.products[index].productName)),
													Expanded(child: Text(NumberFormat.currency(symbol: "R", decimalDigits: 2).format(state.products[index].price))),
													Expanded(child: Text(state.products[index].category)),
													Expanded(child: Text(state.products[index].stockQuantity.toString())),
													Expanded(child: Text(state.products[index].shortages.toString())),
													Expanded(child: Text(state.products[index].supplierName)),
													const SizedBox(width:50),
													ElevatedButton.icon(
														onPressed: (){}, 
														icon: const Icon(Icons.check_box_outlined), 
														label: const Text("Order")
													),
													const SizedBox(width:10),
													ElevatedButton.icon(
														onPressed: (){}, 
														icon: const Icon(Icons.do_disturb),
														label: const Text("Cancel")
													),
													const SizedBox(width:10),											
												]
											));
										})
									),
								);
							}
							else
							{	
								return const Center(
									child: CircularProgressIndicator(),
								);
							}
						},
					)
				),
		  	],
		);
	}
}