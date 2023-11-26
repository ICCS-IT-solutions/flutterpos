import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'payment_bloc_event.dart';
part 'payment_bloc_state.dart';

//Expected uses: payment handling for purchases and sales
class PaymentBloc extends Bloc<PaymentBlocEvent, PaymentBlocState> 
{
	PaymentBloc() : super(PaymentBlocInitial()) 
	{
		on<PostSale>((event,emit) async
		{

		});
		on<PostPurchase>((event,emit) async
		{

		});
	}
}
