part of 'payment_bloc.dart';

@immutable
sealed class PaymentBlocEvent {}

class PostSale extends PaymentBlocEvent 
{
	//These event classes should handle updating/inserting items into their respective tables
}

class PostPurchase extends PaymentBlocEvent 
{

}