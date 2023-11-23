import 'package:flutter/material.dart';
import 'package:flutterpos/Bloc/modules/order_manager_bloc.dart';
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
	//Will need the following functionality:
	//Load orders from database
	//Add new order -> build a form with dropdowns for supplier and product, text field for amount to order, and possibly a date selector.
	//Cancel order -> cancel existing order.
	//Edit existing order -> edit an active order, i.e. one that is not yet submitted.
	//Submit order -> submit an active order.
	@override 
	Widget build(BuildContext context)
	{
		return Scaffold(
			appBar: AppBar(
				title: const Text('Order Management'),
			),
			body: Container(),
		);
	}
}