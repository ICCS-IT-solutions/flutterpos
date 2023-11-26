part of 'inventorymanagement_bloc.dart';

@immutable
sealed class InventorymanagementBlocEvent {}

class LoadInventory extends InventorymanagementBlocEvent
{	
	final List<InventoryItem> inventory;
	LoadInventory({required this.inventory});
}

class AddInventoryItem extends InventorymanagementBlocEvent
{
	final InventoryItem inventoryItem;
	AddInventoryItem({required this.inventoryItem});
}

class UpdateInventoryItem extends InventorymanagementBlocEvent
{
	final InventoryItem inventoryItem;
	UpdateInventoryItem({required this.inventoryItem});
}

class RemoveInventoryItem extends InventorymanagementBlocEvent
{
	final InventoryItem inventoryItem;
	RemoveInventoryItem({required this.inventoryItem});
}