part of 'menu_bloc.dart';

@immutable
class MenuBlocState 
{
    final List<MenuItem>? menuItems;
    final MenuItem? currentMenuItem;
    final bool isLoading;
    final bool hasFinishedLoading;
    final String message;

    const MenuBlocState({required this.menuItems, required this.currentMenuItem, required this.isLoading, required this.hasFinishedLoading, required this.message});
}

class MenuBlocInitial extends MenuBlocState
{
	MenuBlocInitial() : super(menuItems: [], currentMenuItem: null, isLoading: false, hasFinishedLoading: false, message: "");
}

class MenuBlocLoading extends MenuBlocState
{
	MenuBlocLoading() : super(menuItems: [], currentMenuItem: null, isLoading: true, hasFinishedLoading: false, message: "");
}

class MenuBlocSuccess extends MenuBlocState 
{
	const MenuBlocSuccess({required List<MenuItem> menuItems, required MenuItem? currentMenuItem, required bool isLoading, required bool hasFinishedLoading, required String message}) : super(menuItems: menuItems, currentMenuItem: null, isLoading: false, hasFinishedLoading: true, message: "");
}
