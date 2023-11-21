// ignore_for_file: non_constant_identifier_names
import 'package:flutterpos/Models/product_datamodel.dart';
import 'package:flutterpos/Widgets/supplier_dialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../Bloc/modules/order_manager_bloc.dart';
import '../Bloc/modules/user_bloc.dart';
import '../Models/supplier_datamodel.dart';

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
	Future<void> ShowSupplierDialog(BuildContext context, {Supplier? existingSupplier}) async
	{
		if(mounted)
		{
			showDialog(context: context, builder: (context)
			{
				return StatefulBuilder(builder: (context, setState)
				{
					return SupplierDialog(orderManagerBloc: widget.orderManagerBloc);
				});
			});
		}
	}
	void ShowOrderDialog(BuildContext context, {required OrderManagerBloc orderManagerBloc,Product? itemToOrder}) async
	{
		//This dialog to be shown here should allow the user to select the supplier and enter an amount to order.
		showDialog(context: context, builder: (context)
		{	
			TextEditingController amountController = TextEditingController();
			TextEditingController supplierController = TextEditingController();
			Logger().i("Order dialog for product ${itemToOrder!.productName} triggered");
			return AlertDialog(
				title: const Text("Order product"),
				content: Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						Text("Order ${itemToOrder.productName}"),
						TextFormField(
							controller: amountController,
							decoration: const InputDecoration(labelText: "Amount"),
							keyboardType: TextInputType.number,
							validator: (value)=> value == null || value.isEmpty ? "Please enter an amount" : null
							),
						TextFormField(
							controller: supplierController,
							decoration: const InputDecoration(labelText: "Supplier"),
							validator: (value)=> value == null || value.isEmpty ? "Please enter the supplier name" : null
							),
							const SizedBox(height: 10),
							Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: [
									ElevatedButton(onPressed: ()
									{	
										final amount = amountController.text;
										final supplier = supplierController.text;
										final product = itemToOrder.copyWith(supplierName: supplier, onOrder: int.parse(amount));
										orderManagerBloc.add(AddProduct(productToAdd: product));
										Navigator.of(context).pop();
									}, child: const Text("Confirm order")),
									const SizedBox(width: 10),
									ElevatedButton(onPressed: ()
									{
										Navigator.of(context).pop();
									}, child: const Text("Cancel")),
								]
							),
						],
				)
			);
		});
	}
	void ShowCancelOrderDialog(BuildContext context, {required OrderManagerBloc orderManagerBloc,Product? itemToCancel}) async
	{
		//Show the user a dialog requesting confirmation to cancel an order.
		//If the user confirms, then the order should be removed from the database.
		//If the user cancels, then the order should remain in the database.
		showDialog(context: context, builder: (context)
		{
			Logger().i("Cancel order dialog for product ${itemToCancel!.productName} triggered");
			return AlertDialog(
				title: const Text("Cancel order"),
				content: const Text("Are you sure you want to cancel this order?"),
				actions: [
					TextButton(onPressed: ()
					{	
						Navigator.pop(context);
					}, 
					child: const Text("Cancel")),
					TextButton(onPressed: ()
					{
						final product = itemToCancel.copyWith(onOrder: 0);
						orderManagerBloc.add(UpdateProduct(productToUpdate: product));
						Navigator.of(context).pop;
					}, child: const Text("Confirm")),
				]
			);
		});
	}
	@override
	Widget build(BuildContext context)
	{
		//Need to build a list of stock items returned from the database -> products table.
		return Scaffold(
			appBar: AppBar(
				title: const Text("Order manager"),
				actions: [
					//Add item: Add a new item to the products database table.
					//Update selected: Update the data on an existing item.
					//Remove item: Remove an item from the products database table.
					//The add/edit item dialog should include a dropdown linked to the suppliers table, 
					//and the products table should reference the same data point for consistency
					ElevatedButton(onPressed: (){}, child: const Text("Add item")),
					ElevatedButton(onPressed: (){}, child: const Text("Update selected")),
					ElevatedButton(onPressed: (){}, child: const Text("Remove item")),
					//Register a new supplier
					ElevatedButton(onPressed: ()
					{
						ShowSupplierDialog(context);
					}, 
					child: const Text("Add supplier")),
					//Submit the active order as an email.
					ElevatedButton(onPressed: (){}, child: const Text("Submit order"))
				],
			),
			body: BuildProductsList(context)
		);		
	}
	Widget BuildProductsList(BuildContext context)
	{	
		//Size = missing? WTFH? Infer it from the parent, NEVER assume infinity or null!
		return BlocBuilder<OrderManagerBloc,OrderManagerBlocState>(
			builder:(context,state)
			{
				if (state is OrderManagerBlocSuccess)
				{
					return SingleChildScrollView(
						scrollDirection: Axis.vertical,
						child: DataTable(
							columns: const[
								DataColumn(label: Text('Product name', overflow: TextOverflow.ellipsis,)),
								DataColumn(label: Text('Price', overflow: TextOverflow.fade,)),
								DataColumn(label: Text('Category', overflow: TextOverflow.fade,)),
								DataColumn(label: Text('Quantity', overflow: TextOverflow.fade,)),
								DataColumn(label: Text('Low threshold', overflow: TextOverflow.ellipsis,)),
								DataColumn(label: Text('On order', overflow: TextOverflow.ellipsis,)),
								DataColumn(label: Text('Shortages', overflow: TextOverflow.ellipsis,)),
								DataColumn(label: Text('Supplier', overflow: TextOverflow.fade,)),
								DataColumn(label: Text('Actions', overflow: TextOverflow.fade,)),
							],
							rows: state.products!.map((product) 
							{
							return DataRow(
								cells: [
									DataCell(Text(product.productName, overflow: TextOverflow.fade,)),
									DataCell(Text(NumberFormat.currency(symbol: "R", decimalDigits: 2).format(product.price), overflow: TextOverflow.fade,)),
									DataCell(Text(product.category, overflow: TextOverflow.fade,)),
									DataCell(Text(product.stockQuantity.toString(), overflow: TextOverflow.fade,)),
									DataCell(Text(product.threshold.toString(), overflow: TextOverflow.fade,)),
									DataCell(Text(product.onOrder.toString(), overflow: TextOverflow.fade,)),
									DataCell(Text(product.shortages.toString(), overflow: TextOverflow.fade,)),
									DataCell(Text(product.supplierName, overflow: TextOverflow.fade,)),
									DataCell(Row(children: [
										//Expected functionality: Order: adds a product to the order list
										//Cancel: removes a product from the order list
										ElevatedButton.icon(onPressed:() 
										{
											//How to get the item from which this func is triggered?
											ShowOrderDialog(context, orderManagerBloc: widget.orderManagerBloc, itemToOrder: product);
										},
										icon: const Icon(Icons.check_box_outlined),
										label: const Text("Order")),
										const SizedBox(width:10),
										ElevatedButton.icon(onPressed: ()
										{
											ShowCancelOrderDialog(context, orderManagerBloc: widget.orderManagerBloc, itemToCancel: product);
										}, 
										icon: const Icon(Icons.do_disturb) ,
										label: const Text("Cancel")),
									])
								)
							]);
						}).toList()),
					);
				}
				else
				{
					return const Center(
						child: Text("No products found"),
					);
				}
			}
		);
	}
}