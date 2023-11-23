
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutterpos/Bloc/modules/inventory/suppliermanagement_bloc.dart';
import 'package:flutterpos/Bloc/modules/user_bloc.dart';

class SupplierManagementScreen extends StatefulWidget
{
	final SupplierManagementBloc supplierManagementBloc;
	final UserBloc userBloc;

	//Pass in the blocs from the parent, in this case the order manager.
	const SupplierManagementScreen({required this.userBloc, required this.supplierManagementBloc, super.key});
	@override
	State<SupplierManagementScreen> createState() => _SupplierManagementScreenState();
}

class _SupplierManagementScreenState extends State<SupplierManagementScreen>
{
	Widget BuildSuppliersList(BuildContext context)
	{
		return Container(
			
		);
	}
	@override
	Widget build(BuildContext context)
	{
		return Scaffold(
			appBar: AppBar(
				title: const Text('Supplier Management'),
				actions: [
					ElevatedButton(
						onPressed: (){},
						child: const Text('Add Supplier'),
					),
					ElevatedButton(
						onPressed: (){},
						child: const Text('Edit Supplier'),
					),
					ElevatedButton(
						onPressed: (){},
						child: const Text('Remove Supplier'),
					)
				],
			),
			body: BuildSuppliersList(context)
		);
	}
}