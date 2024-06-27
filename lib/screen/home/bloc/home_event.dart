part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class AddClassEvent extends HomeEvent {
  final String classCode;
  final BuildContext context;
  AddClassEvent(this.classCode, this.context);
}
