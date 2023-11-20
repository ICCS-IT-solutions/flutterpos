part of 'order_manager_bloc.dart';

@immutable
sealed class OrderManagerBlocEvent {}

class PostOrder extends OrderManagerBlocEvent 
{
	//These event classes should handle updating/inserting items into their respective tables
}

class LoadProducts extends OrderManagerBlocEvent 
{
	//This event class is responsible for holding the products list to be used in the UI
}