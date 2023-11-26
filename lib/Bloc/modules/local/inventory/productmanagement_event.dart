part of "productmanagement_bloc.dart";

@immutable
sealed class ProductManagementBlocEvent {}

class LoadProducts extends ProductManagementBlocEvent 
{
	final List<Product> products;
	LoadProducts({required this.products});
}

class AddProduct extends ProductManagementBlocEvent 
{
	final Product product;
	AddProduct({required this.product});
}

class UpdateProduct extends ProductManagementBlocEvent
{
	final Product product;
	UpdateProduct({required this.product});
}

class RemoveProduct extends ProductManagementBlocEvent
{
	final Product product;
	RemoveProduct({required this.product});
}