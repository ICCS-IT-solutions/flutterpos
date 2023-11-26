part of "productmanagement_bloc.dart";

class ProductManagementBlocState
{
	final String message;
	final bool isLoading;
	final List<Product>? products;
	final Product? product;

	ProductManagementBlocState({required this.message, required this.isLoading, required this.products, required this.product});
}

class ProductManagementBlocInitial extends ProductManagementBlocState
{
	ProductManagementBlocInitial() : super(message: "", isLoading: false, products: null, product: null);
}

class ProductManagementBlocLoading extends ProductManagementBlocState
{
	ProductManagementBlocLoading() : super(product: null, products: null,message: "Loading products", isLoading: true);
}

class ProductManagementBlocSuccess extends ProductManagementBlocState
{
	ProductManagementBlocSuccess({required super.product, required super.products}) : super(message: "Products loaded successfully", isLoading: false);
}


class ProductManagementBlocFailure extends ProductManagementBlocState
{
	ProductManagementBlocFailure() : super(product: null, products: null,message: "Products failed to load", isLoading: false);
}