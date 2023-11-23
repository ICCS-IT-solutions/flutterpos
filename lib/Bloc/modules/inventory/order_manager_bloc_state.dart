// ignore_for_file: non_constant_identifier_names

part of 'order_manager_bloc.dart';

@immutable
class OrderManagerBlocState 
{
	final List<Order>? orders;
	final Order? order;
	final bool isLoading;
	final String message;

	const OrderManagerBlocState({required this.orders, required this.order, required this.isLoading, required this.message});
}

class OrderManagerBlocInitial extends OrderManagerBlocState
{
	const OrderManagerBlocInitial(): super(orders: null, order: null, isLoading: false, message: '');
}

class OrderManagerBlocLoading extends OrderManagerBlocState
{
	const OrderManagerBlocLoading(): super(orders: null, order: null, isLoading: true, message: 'Orders loading...');
}

class OrderManagerBlocSuccess extends OrderManagerBlocState
{
	const OrderManagerBlocSuccess({required super.order, required super.orders}) : super(isLoading: false, message: 'Orders loaded successfully.');
}

class OrderManagerBlocFailure extends OrderManagerBlocState
{
	const OrderManagerBlocFailure(): super(orders: null, order: null, isLoading: false, message: 'Orders failed to load.');
}