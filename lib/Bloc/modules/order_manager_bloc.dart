import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'order_manager_bloc_event.dart';
part 'order_manager_bloc_state.dart';

//Expected uses: ordering of products and keeping track of stock levels.
class OrderManagerBloc extends Bloc<OrderManagerBlocEvent, OrderManagerBlocState> 
{
	OrderManagerBloc() : super(OrderManagerBlocInitial()) 
	{
		on<OrderManagerBlocEvent>((event, emit) 
		{
		// TODO: implement event handler
		});
	}
}
