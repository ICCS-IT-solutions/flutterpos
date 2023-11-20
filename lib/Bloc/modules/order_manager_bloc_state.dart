// ignore_for_file: non_constant_identifier_names

part of 'order_manager_bloc.dart';

@immutable
class OrderManagerBlocState 
{
	final List<Product>? products;
	final List<Supplier>? suppliers;
	final Product? product;
	final Supplier? supplier;
	final bool IsLoading;
	final bool IsSuccessful;
	final bool IsFailure;
	final String response;

	const OrderManagerBlocState({this.products, this.suppliers, this.supplier, this.product, required this.IsLoading, required this.IsSuccessful, required this.IsFailure, required this.response});
}

final class OrderManagerBlocInitial extends OrderManagerBlocState 
{
	const OrderManagerBlocInitial() : super(products: const [], product: null, IsLoading: false, IsSuccessful: false, IsFailure: false, response: "");
}

class OrderManagerBlocSuccess extends OrderManagerBlocState 
{	
	final String successMsg;
  	final List<Product> loadedProducts;
  	final Product? currentProduct;
	const OrderManagerBlocSuccess({required this.successMsg, required this.loadedProducts, this.currentProduct}) : super(products: loadedProducts, product: currentProduct, IsLoading: false, IsSuccessful: true, IsFailure: false, response: successMsg);
}

class OrderManagerBlocLoading extends OrderManagerBlocState 
{
	final String loadingMsg;
	const OrderManagerBlocLoading({required this.loadingMsg}) : super(products: const [], product: null, IsLoading: true, IsSuccessful: false, IsFailure: false, response: loadingMsg);
}

class OrderManagerBlocFailed extends OrderManagerBlocState 
{	
	final String errorMsg;
	const OrderManagerBlocFailed(String s, {required this.errorMsg}) : super(products: const [], product: null, IsLoading: false, IsSuccessful: false, IsFailure: true, response: errorMsg);
}