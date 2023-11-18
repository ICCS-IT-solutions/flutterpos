import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'reporting_bloc_event.dart';
part 'reporting_bloc_state.dart';

//Expected uses: Purchase reports, sales reports, shortage reports.
class ReportingBloc extends Bloc<ReportingBlocEvent, ReportingBlocState> 
{
	ReportingBloc() : super(ReportingBlocInitial()) 
	{
		on<ReportingBlocEvent>((event, emit) 
		{
		// TODO: implement event handler
		});
	}
}
