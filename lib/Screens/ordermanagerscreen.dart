import 'package:flutter/material.dart';

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
	Widget build(BuildContext context)
	{
		//Need to build a list of stock items returned from the database -> products table.
		return Scaffold(
			appBar: AppBar(
				
			),
			body: const Center(
				
			)
		);		
	}
}