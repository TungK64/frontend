part of 'task_bloc.dart';

enum TaskStatus { initial, loading, changeScreen, dragTask, getTaskInfo }

class TaskState {
  List<dynamic> items = [];
  dynamic assignee = {};
  dynamic topicInfo = {};
  dynamic projectInfo = {};
  TaskStatus status = TaskStatus.initial;

  TaskState clone(TaskStatus status) {
    TaskState state = TaskState();
    state.status = status;
    state.items = items;
    state.assignee = assignee;
    state.projectInfo = projectInfo;
    state.topicInfo = topicInfo;
    return state;
  }
}
