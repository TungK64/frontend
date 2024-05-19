part of 'task_bloc.dart';

@immutable
abstract class TaskEvent {}

class TaskInitialEvent extends TaskEvent {}

class TaskDragEvent extends TaskEvent{
  final String taskId;
  final String newStatus;
  final BuildContext context;
  TaskDragEvent(this.taskId, this.context, this.newStatus);
}