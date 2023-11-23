import 'package:flutter/material.dart';
import 'package:flutterpos/Bloc/modules/inventory/order_manager_bloc.dart';

import "../Models/supplier_datamodel.dart";

class SupplierDialog extends StatefulWidget
{
	final OrderManagerBloc orderManagerBloc;
	final Supplier? existingSupplier;
	const SupplierDialog({required this.orderManagerBloc, super.key, this.existingSupplier});

	@override
	State<SupplierDialog> createState() => _SupplierDialogState();
}

class _SupplierDialogState extends State<SupplierDialog>
{	

	@override
	void initState()
	{
		super.initState();
	}

	//Text controllers for adding the props based on the supplier datamodel:
	TextEditingController supplierNameController = TextEditingController();
	TextEditingController supplierEmailAddressController = TextEditingController();
	TextEditingController supplierContactNumberController = TextEditingController();
	TextEditingController supplierStreetAddressController = TextEditingController();
	TextEditingController supplierCityNameController = TextEditingController();
	TextEditingController supplierPostalCodeController = TextEditingController();
	@override
	Widget build(BuildContext context)
	{
		return AlertDialog(
			title: const Text("Add new supplier"),
				content: SingleChildScrollView(child: Column(
					children:[
					TextField(
						controller: supplierNameController,
						decoration: const InputDecoration(
							labelText: "Supplier name",
						),
					),
					TextField(
						controller: supplierEmailAddressController,
						decoration: const InputDecoration(
							labelText: "Supplier email address",
						)
					),
					TextField(
						controller: supplierContactNumberController,
						decoration: const InputDecoration(
							labelText: "Supplier contact number",
						)
					),
					TextField(
						controller: supplierStreetAddressController,
						decoration: const InputDecoration(
							labelText: "Supplier street address",
						)
					),
					TextField(
						controller: supplierCityNameController,
						decoration: const InputDecoration(
							labelText: "Supplier city name",
						)
					),
					TextField(
						controller: supplierPostalCodeController,
						decoration: const InputDecoration(
							labelText: "Supplier postal code",
						)
					),
					const SizedBox(height: 10),
					Row(
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
							ElevatedButton(onPressed: ()
							{
								//credit, payment and total purchases are zero since the supplier has just been registered.
								//Will extend this to include these values for better real-world use.
								final newSupplier = Supplier(
									supplierName: supplierNameController.text,
									emailAddress: supplierEmailAddressController.text,
									contactNumber: supplierContactNumberController.text,
									address: supplierStreetAddressController.text,
									city: supplierCityNameController.text,
									postalCode: supplierPostalCodeController.text,
									//These are intentionally zeroed on creation.
									outstandingCredit: 0,
									currentPayment: 0,
									totalPurchases: 0
								);
								widget.orderManagerBloc.add(RegisterSupplier(currentSupplier: newSupplier));
								Navigator.of(context).pop();
							}, child: const Text("Submit")),
							ElevatedButton(
								onPressed: ()
								{
									//Clear controllers then pop:
									supplierNameController.clear();
									supplierEmailAddressController.clear();
									supplierContactNumberController.clear();
									supplierStreetAddressController.clear();
									supplierCityNameController.clear();
									supplierPostalCodeController.clear();
									Navigator.of(context).pop();
								}, 
								child: const Text("Cancel")),
						],
					)
				],
			)
		));
	}
}