part of 'order_manager_bloc.dart';

@immutable
sealed class OrderManagerBlocEvent {}

class LoadOrders extends OrderManagerBlocEvent 
{
	final List<Order> orders;
	LoadOrders({required this.orders});
}
class AddOrder extends OrderManagerBlocEvent 
{
	final Order newOrder;
	AddOrder({required this.newOrder});
}
class UpdateOrder extends OrderManagerBlocEvent
{
	final Order orderToUpdate;
	UpdateOrder({required this.orderToUpdate});
}

class RemoveOrder extends OrderManagerBlocEvent
{
	final Order orderToRemove;
	RemoveOrder({required this.orderToRemove});
}
