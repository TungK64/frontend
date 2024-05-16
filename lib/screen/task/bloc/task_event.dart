part of 'task_bloc.dart';

@immutable
abstract class TaskEvent {}

class TaskInitialEvent extends TaskEvent {}