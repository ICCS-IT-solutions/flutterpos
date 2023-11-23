part of "shortagemanagement_bloc.dart";

@immutable
class ShortageManagementBlocState
{
	final bool isLoading;
	final String message;
	final List<Shortage>? shortages;
	final Shortage? shortage;

	const ShortageManagementBlocState({required this.shortages, required this.shortage, required this.message, required this.isLoading});
}

class ShortageManagementBlocInitial extends ShortageManagementBlocState
{
	ShortageManagementBlocInitial() : super(shortages: [], shortage: null, message: "", isLoading: false);
}

class ShortageManagementBlocLoading extends ShortageManagementBlocState
{
	const ShortageManagementBlocLoading() : super(shortages: null, shortage: null, message: "Loading shortages", isLoading: true);
}

class ShortageManagementBlocSuccess extends ShortageManagementBlocState
{
	const ShortageManagementBlocSuccess({required super.shortages, required super.shortage}) : super(message: "Shortages loaded successfully", isLoading: false);
}

class ShortageManagementBlocFailure extends ShortageManagementBlocState
{
	const ShortageManagementBlocFailure() : super(shortages: null, shortage: null, message: "Shortages failed to load", isLoading: false);
}