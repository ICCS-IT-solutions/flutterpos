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
			),
			body: BuildProductsList(context)
		);		
	}
	Widget BuildProductsList(BuildContext context)
	{
		return BlocBuilder<OrderManagerBloc, OrderManagerBlocState>(
			builder: (context, state)
			{
				if(state is OrderManagerBlocSuccess)
				{
					return ListView.builder(
						itemCount: state.products.length,
						itemBuilder: (context, index) 
						{
							//How else can i construct a list item widget that won't whine about overflow but will adjust?
							return ListTile(
								title: Text(state.products[index].productName),
								subtitle: Row(
									children: [
									//Need a more reliable way to display this as R XX XXX.yy, the international standard format for SA currency amounts
									Flexible(child: Text("Price: ${NumberFormat.currency(symbol: 'R' , decimalDigits: 2).format(state.products[index].price)}")),
									const SizedBox(width:10),
									Flexible(child: Text("Category: ${state.products[index].category}", overflow: TextOverflow.ellipsis,)),
									const SizedBox(width:10),
									Flexible(child: Text("Quantity: ${state.products[index].stockQuantity}", overflow: TextOverflow.ellipsis)),
									const SizedBox(width:10),
									Flexible(child: Text("Shortages: ${state.products[index].shortages}", overflow: TextOverflow.ellipsis)),
									],
								),
								//catch, log on exceptions but continue rendering... don't bloody break the run on these!
								trailing: Column(
								  children: [
								    ElevatedButton.icon(
								    	//Do nothing yet. Later: show a dialog with the details for submitting an order.
								    	//The submit method ultimately should enable the app to send an email to the supplier listed
								    	//Note: add supplier to database -> products table, create a dropdown list of registered suppliers
								    	//This will be pulled in from the db as well. Need a new table for them that includes contact info.
								    	onPressed: () {},
								    	icon: Icon(Icons.check_box_outlined),
								    	label: const Text("Order"),
								    ),
								  ],
								),	
							);
						});
				}
				else
				{
					return const Center(child: CircularProgressIndicator());
				}
			}
		);
	}
}