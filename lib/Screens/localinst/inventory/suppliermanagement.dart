
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterpos/Bloc/modules/local/inventory/suppliermanagement_bloc.dart';
import 'package:flutterpos/Bloc/modules/local/user_bloc.dart';

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
	@override
	void initState()
	{
		widget.supplierManagementBloc.add(LoadSuppliers(suppliers: const []));
		super.initState();
	}
	Widget BuildSuppliersList(BuildContext context)
	{
		return BlocBuilder<SupplierManagementBloc, SupplierManagementBlocState>(
			builder: (context, state)
			{
				if (state is SupplierManagementBlocSuccess)
				{
				return SingleChildScrollView(
						child: DataTable(
							columns: const [
								DataColumn(label: Text("Supplier name", overflow: TextOverflow.ellipsis,)),
								DataColumn(label: Text("Email address", overflow: TextOverflow.ellipsis,)),
								DataColumn(label: Text("Contact number", overflow: TextOverflow.ellipsis,)),
								DataColumn(label: Text("City", overflow: TextOverflow.ellipsis,)),
								DataColumn(label: Text("Street address", overflow: TextOverflow.ellipsis,)),
								DataColumn(label: Text("Postal code", overflow: TextOverflow.ellipsis,)),
								DataColumn(label: Text("Outstanding credit", overflow: TextOverflow.ellipsis,)),
								DataColumn(label: Text("Current payment", overflow: TextOverflow.ellipsis,)),
								DataColumn(label: Text("Total purchases", overflow: TextOverflow.ellipsis,)),
							],
							rows: state.suppliers!.map((supplier)
							{
								return DataRow(cells: [
										DataCell(Text(supplier.supplierName)),
										DataCell(Text(supplier.emailAddress)),
										DataCell(Text(supplier.contactNumber)),
										DataCell(Text(supplier.city)),
										DataCell(Text(supplier.address)),
										DataCell(Text(supplier.postalCode)),
										DataCell(Text(supplier.outstandingCredit.toString())),
										DataCell(Text(supplier.currentPayment.toString())),
										DataCell(Text(supplier.totalPurchases.toString())),
									]);
							}).toList(),
						)
					);
				}
				else
				{
					return const Center(child: Text("No suppliers found."));
				}
			}
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