part of "productmanagement_bloc.dart";

@immutable
sealed class ProductManagementBlocEvent {}

class LoadProducts extends ProductManagementBlocEvent 
{
	final List<Product> products;
	LoadProducts(this.products);
}

class AddProduct extends ProductManagementBlocEvent 
{
	final Product product;
	AddProduct(this.product);
}

class UpdateProduct extends ProductManagementBlocEvent
{
	final Product product;
	UpdateProduct(this.product);
}

class RemoveProduct extends ProductManagementBlocEvent
{
	final Product product;
	RemoveProduct(this.product);
}