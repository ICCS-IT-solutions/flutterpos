
import 'package:flutter/material.dart';

class ProductDialog extends StatefulWidget
{
  const ProductDialog({super.key});

	@override
	State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog>
{
	//Text ediing controllers for product name, price and description:
	@override
	void initState()
	{
		super.initState();
	}

	@override
	Widget build(BuildContext context)
	{
		return const AlertDialog(
			title: Text("Add new product"),
			content: Text("Not implemented yet"),
		);
	}
}
