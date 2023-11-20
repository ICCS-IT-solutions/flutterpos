part of 'order_manager_bloc.dart';

@immutable
sealed class OrderManagerBlocEvent {}

class LoadProducts extends OrderManagerBlocEvent 
{
	//This event class is responsible for holding the products list to be used in the UI
}
class AddProduct extends OrderManagerBlocEvent 
{

}

class SubmitOrder extends OrderManagerBlocEvent 
{

}