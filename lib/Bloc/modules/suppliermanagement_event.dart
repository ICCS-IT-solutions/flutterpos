
part of "suppliermanagement_bloc.dart";

@immutable
sealed class SupplierManagementBlocEvent {}

class LoadSuppliers extends SupplierManagementBlocEvent
{
	final List<Supplier> suppliers;
	LoadSuppliers({required this.suppliers});
}