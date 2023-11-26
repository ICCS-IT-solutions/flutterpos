
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterpos/Bloc/modules/local/inventory/shortagemanagement_bloc.dart';
import 'package:flutterpos/Bloc/modules/local/user_bloc.dart';


class ShortageManagementScreen extends StatefulWidget
{
	final ShortageManagementBloc shortageManagementBloc;
	final UserBloc userBloc;

  	const ShortageManagementScreen({required this.userBloc ,required this.shortageManagementBloc, super.key});

	@override
	State<ShortageManagementScreen> createState() => _ShortageManagementScreenState();
}

class _ShortageManagementScreenState extends State<ShortageManagementScreen>
{

	@override
	void initState()
	{
		super.initState();
		widget.shortageManagementBloc.add(LoadShortages(shortages: const []));
	}

	Widget BuildShortagesList(BuildContext context)
	{
		return BlocBuilder<ShortageManagementBloc, ShortageManagementBlocState>(
			builder: (context, state) 
			{
				if (state is ShortageManagementBlocSuccess)
				{
					return DataTable(
						columns: const [
							DataColumn(label: Text("User account ID")),
							DataColumn(label: Text("User name")),
							DataColumn(label: Text("Product ID")),
							DataColumn(label: Text("Product name")),
							DataColumn(label: Text("Shortages")),
						],
						rows: state.shortages!.map((shortage)
						{
							return DataRow(
								cells: [
									DataCell(Text(shortage.user_id.toString())),
									DataCell(Text(shortage.user_name)),
									DataCell(Text(shortage.product_id.toString())),
									DataCell(Text(shortage.product_name)),
									DataCell(Text(shortage.shortage_quantity.toString())),
								]
							);
						}).toList(),
					);
				}
				else
				{
					return const Center(child: Text("No shortages registered."));
				}
			},
		);
	}

	@override
	Widget build(BuildContext context)
	{
		return Scaffold(
			appBar: AppBar(
				title: const Text("Shortage Management"),
			),
			body: BuildShortagesList(context)
		);
	}
}