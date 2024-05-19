part of 'task_bloc.dart';

enum TaskStatus { initial, loading, changeScreen, dragTask }

class TaskState {
  List<dynamic> items = [];
  TaskStatus status = TaskStatus.initial;

  TaskState clone(TaskStatus status) {
    TaskState state = TaskState();
    state.status = status;
    state.items = items;
    return state;
  }
}