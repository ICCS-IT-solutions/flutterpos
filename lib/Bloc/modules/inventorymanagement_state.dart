part of 'inventorymanagement_bloc.dart';

@immutable
class InventorymanagementBlocState 
{
	final String message;
	final bool isLoading;
	final List<InventoryItem>? inventory;
	final InventoryItem? inventoryItem;

	const InventorymanagementBlocState({required this.message, required this.isLoading, required this.inventory, required this.inventoryItem});
}

class InventorymanagementInitial extends InventorymanagementBlocState
{
	InventorymanagementInitial() : super(message: "", isLoading: false, inventory: [], inventoryItem:null);
}

class InventorymanagementLoading extends InventorymanagementBlocState
{
	InventorymanagementLoading() : super(message: "Loading Inventory", isLoading: true, inventory: [], inventoryItem: null);
}

class InventorymanagementSuccess extends InventorymanagementBlocState
{
	const InventorymanagementSuccess({required super.inventoryItem, required super.inventory}) : super(message: "Inventory loaded successfully.", isLoading: false);
}

class InventorymanagementFailure extends InventorymanagementBlocState
{
	InventorymanagementFailure({required String errorMessage}) : super(message: errorMessage, isLoading: false, inventory: [], inventoryItem: null);
}
