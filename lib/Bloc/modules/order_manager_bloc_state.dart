// ignore_for_file: non_constant_identifier_names

part of 'order_manager_bloc.dart';

@immutable
class OrderManagerBlocState 
{
	final List<Product> products;
	final Product? currentProduct;
	final bool IsLoading;
	final bool IsSuccessful;
	final bool IsFailure;
	final String response;

	const OrderManagerBlocState({required this.products, required this.currentProduct, required this.IsLoading, required this.IsSuccessful, required this.IsFailure, required this.response});
}

final class OrderManagerBlocInitial extends OrderManagerBlocState 
{
	const OrderManagerBlocInitial() : super(products: const [], currentProduct: null, IsLoading: false, IsSuccessful: false, IsFailure: false, response: "");
}

class OrderManagerBlocSuccess extends OrderManagerBlocState 
{	
	final String successMsg;
	final List<Product> products;
	final Product? currentProduct;
	const OrderManagerBlocSuccess({required this.successMsg, required this.products, this.currentProduct}) : super(products: products, currentProduct: currentProduct, IsLoading: false, IsSuccessful: true, IsFailure: false, response: successMsg);
}

class OrderManagerBlocLoading extends OrderManagerBlocState 
{
	final String loadingMsg;
	const OrderManagerBlocLoading({required this.loadingMsg}) : super(products: const [], currentProduct: null, IsLoading: true, IsSuccessful: false, IsFailure: false, response: loadingMsg);
}

class OrderManagerBlocFailed extends OrderManagerBlocState 
{	
	final String errorMsg;
	const OrderManagerBlocFailed({required this.errorMsg}) : super(products: const [], currentProduct: null, IsLoading: false, IsSuccessful: false, IsFailure: true, response: errorMsg);
}