import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'main_app_bloc_event.dart';
part 'main_app_bloc_state.dart';

class MainAppBloc extends Bloc<MainAppBlocEvent, MainAppBlocState> {
  MainAppBloc() : super(MainAppBlocInitial()) {
    on<MainAppBlocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
