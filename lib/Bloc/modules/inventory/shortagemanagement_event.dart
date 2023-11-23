part of "shortagemanagement_bloc.dart";

@immutable
sealed class ShortageManagementBlocEvent{}

class LoadShortages extends ShortageManagementBlocEvent
{
	final List<Shortage> shortages;
	LoadShortages({required this.shortages});
}

class AddShortage extends ShortageManagementBlocEvent
{
	final Shortage shortage;
	AddShortage({required this.shortage});
}

class UpdateShortage extends ShortageManagementBlocEvent
{
	final Shortage shortage;
	UpdateShortage({required this.shortage});
}

class RemoveShortage extends ShortageManagementBlocEvent
{
	final Shortage shortage;
	RemoveShortage({required this.shortage});
}