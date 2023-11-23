// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterpos/Bloc/modules/inventory/order_manager_bloc.dart';
import 'package:flutterpos/Bloc/modules/user_bloc.dart';

class OrderManagementScreen extends StatefulWidget
{
	//Will likely separate the bloc into three that are better suited for their use cases.
	final OrderManagerBloc orderManagerBloc;

	//This one is needed as it manages the auth and user rights states.
	final UserBloc userBloc;

	const OrderManagementScreen({required this.userBloc, required this.orderManagerBloc, super.key});
	@override
	State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen>
{
		@override 
	void initState()
	{
		super.initState();
		widget.orderManagerBloc.add(LoadOrders(orders:const []));
	}
	Widget BuildOrdersList(BuildContext context)
	{
		//Use a bloc builder and data table to display the orders... but how to make the entries individually selectable?
		return BlocBuilder<OrderManagerBloc,OrderManagerBlocState>(
			builder: (context,state)
			{
				if (state is OrderManagerBlocSuccess)
				{
					return DataTable(
						columns: const [
							DataColumn(label: Text("Product ID")),
							DataColumn(label: Text("Product name")),
							DataColumn(label: Text("Amount on order")),
							DataColumn(label: Text("Created")),
							DataColumn(label: Text("Updated")),
							DataColumn(label: Text("Submitted")),
						],
						rows: state.orders!.map((order) 
						{
							return DataRow(
								cells: [
									DataCell(Text(order.product_id.toString())),
									DataCell(Text(order.product_name)),
									DataCell(Text(order.amount_to_order.toString())),
									DataCell(Text(order.created_at.toString())),
									DataCell(Text(order.updated_at.toString())),
									DataCell(Text(order.is_submitted.toString())),
								]);
						}).toList(),
					);
				}
				else
				{
					return const Center(child: Text("No orders found."));
				}
			}
		);
	}
	@override 
	Widget build(BuildContext context)
	{
		return Scaffold(
			appBar: AppBar(
				title: const Text('Order Management'),
			),
			body: BuildOrdersList(context),
		);
	}
}