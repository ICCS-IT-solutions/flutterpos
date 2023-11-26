part of 'menu_bloc.dart';


@immutable
sealed class MenuBlocEvent 
{}

class AddMenuItem extends MenuBlocEvent 
{
  final MenuItem menuItem;

  AddMenuItem(this.menuItem);
}

class UpdateMenuItem extends MenuBlocEvent 
{
  final MenuItem menuItem;

  UpdateMenuItem(this.menuItem);
}

class DeleteMenuItem extends MenuBlocEvent 
{
  final MenuItem menuItem;

  DeleteMenuItem(this.menuItem);
}

class LoadMenuItems extends MenuBlocEvent 
{
	final List<MenuItem> menuItems;
	LoadMenuItems({required this.menuItems});
}
