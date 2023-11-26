// ignore_for_file: non_constant_identifier_names
import 'package:flutterpos/Bloc/modules/local/inventory/inventorymanagement_bloc.dart';
import 'package:flutterpos/Bloc/modules/local/inventory/productmanagement_bloc.dart';
import 'package:flutterpos/Bloc/modules/local/inventory/shortagemanagement_bloc.dart';
import 'package:flutterpos/Bloc/modules/local/inventory/suppliermanagement_bloc.dart';
import 'package:flutterpos/Screens/localinst/inventory/productmanagement.dart';
import 'package:flutterpos/Screens/localinst/inventory/suppliermanagement.dart';
import 'package:flutterpos/Screens/localinst/inventory/shortagemanagement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutterpos/Bloc/modules/local/inventory/order_manager_bloc.dart';
import 'package:flutterpos/Bloc/modules/local/user_bloc.dart';
import 'ordermanagement.dart';

//Immediate objective for the inventory management aspect: Create a dashboard type interface to serve as an overview of products, inventory, orders and suppliers
//Should supplier management be its own screen? 
//Might be a better option going forward given the complexity of the supplier dataset,
// and this dataset needs to be available for use as a dropdown for the products options
// 
//Rename this to inventory, create new screen widget for order management, and tie that to the orders table.
//Would it help to divide the bloc up as well into new modules for each new screen to be added?
//
//Actions for this screen would then be: Manage orders, Manage suppliers, Manage products
class InventoryManagementScreen extends StatefulWidget
{	
	final OrderManagerBloc orderManagerBloc;
	final InventorymanagementBloc inventoryManagementBloc;
	final SupplierManagementBloc supplierManagementBloc;
	final ProductManagementBloc productManagementBloc;
	final ShortageManagementBloc shortageManagementBloc;
	final UserBloc userBloc;
	//Need to keep track of the currently logged-in user 
	
	const InventoryManagementScreen({required this.userBloc, 
	required this.orderManagerBloc, 
	required this.inventoryManagementBloc, 
	required this.supplierManagementBloc,
	required this.productManagementBloc,
	required this.shortageManagementBloc,
	super.key});

	@override
	State<InventoryManagementScreen> createState() => _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen>
{
	@override 
	void initState()
	{
		super.initState();
		widget.inventoryManagementBloc.add(LoadInventory(inventory:const []));
	}

	
	@override
	Widget build(BuildContext context)
	{
		//Need to build a list of stock items returned from the database -> products table.
		return Scaffold(
			appBar: AppBar(
				title: const Text("Inventory Management"),
				actions: [
					ElevatedButton(
						onPressed: ()
						{
							Navigator.of(context).push(
								MaterialPageRoute(builder: (context)
								{
									return OrderManagementScreen(userBloc: widget.userBloc, orderManagerBloc: widget.orderManagerBloc,);
								}
							));
						},
						child: const Text("Manage orders"),
					),
					ElevatedButton(onPressed: ()
					{
						Navigator.of(context).push(
							MaterialPageRoute(builder: (context)
							{	
								//Build out this module still
								return ProductManagementScreen(userBloc: widget.userBloc, productManagementBloc: widget.productManagementBloc);
							})
						);
					}, 
					child: const Text("Manage products")),
					//Register a new supplier
					ElevatedButton(onPressed: ()
					{
						Navigator.of(context).push(
							MaterialPageRoute(builder: (context) 
							{
								return SupplierManagementScreen(userBloc: widget.userBloc, supplierManagementBloc: widget.supplierManagementBloc,);
							})
						);
					}, 
					child: const Text("Manage suppliers")),
					ElevatedButton(
						onPressed:()
						{
							Navigator.of(context).push(
								MaterialPageRoute(builder: (context)
								{
									return ShortageManagementScreen(userBloc: widget.userBloc, shortageManagementBloc: widget.shortageManagementBloc,);
								})
							);
						},
						child: const Text("Manage shortages"),
					)
				],
			),
			body: BuildProductsList(context)
		);		
	}
	//Turn this into an overview type list, which should show at a glance what the current inventory state looks like.
	Widget BuildProductsList(BuildContext context)
	{	
		//Size = missing? WTFH? Infer it from the parent, NEVER assume infinity or null!
		return BlocBuilder<InventorymanagementBloc,InventorymanagementBlocState>(
			builder:(context,state)
			{
				if (state is InventorymanagementSuccess)
				{
					return SingleChildScrollView(
						scrollDirection: Axis.vertical,
						child: DataTable(
							columns: const[
								DataColumn(label: Text('Product name', overflow: TextOverflow.ellipsis,)),
								DataColumn(label: Text('Current quantity', overflow: TextOverflow.ellipsis,)),
								DataColumn(label: Text('Shortages', overflow: TextOverflow.ellipsis,)),
								DataColumn(label: Text('Amount on order', overflow: TextOverflow.ellipsis,)),
								DataColumn(label: Text('Warning threshold', overflow: TextOverflow.ellipsis,)),
							],
							rows: state.inventory!.map((inventoryItem) 
							{
							return DataRow(
								cells: [
									DataCell(Text(inventoryItem.productName, overflow: TextOverflow.fade,)),
									DataCell(Text(inventoryItem.currentQuantity.toString(), overflow: TextOverflow.fade,)),
									DataCell(Text(inventoryItem.shortages.toString(), overflow: TextOverflow.fade,)),
									DataCell(Text(inventoryItem.orderedQuantity.toString(), overflow: TextOverflow.fade,)),
									DataCell(Text(inventoryItem.lowThreshold.toString(), overflow: TextOverflow.fade,)),
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