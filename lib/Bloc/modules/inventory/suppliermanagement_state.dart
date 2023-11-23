part of "suppliermanagement_bloc.dart";

class SupplierManagementBlocState
{
	final Supplier? supplier;
	final List<Supplier>? suppliers;
	final bool isLoading;
	final String message;

	SupplierManagementBlocState({required this.supplier, required this.suppliers, required this.isLoading, required this.message});
}

class SupplierManagementBlocInitial extends SupplierManagementBlocState
{
	SupplierManagementBlocInitial() : super(supplier: null, suppliers: [], isLoading: false, message: "");
}

class SupplierManagementBlocLoading extends SupplierManagementBlocState
{
	SupplierManagementBlocLoading() : super(supplier: null, suppliers: [], isLoading: true, message: "Loading Suppliers");
}

class SupplierManagementBlocSuccess extends SupplierManagementBlocState
{
	SupplierManagementBlocSuccess({required super.supplier, required super.suppliers }) : super(isLoading: false, message: "Suppliers loaded successfully.");
}

class SupplierManagementBlocFailure extends SupplierManagementBlocState
{
	final String errorMessage;
	SupplierManagementBlocFailure({required this.errorMessage}) : super(supplier: null, suppliers: [], isLoading: false, message: errorMessage);
}