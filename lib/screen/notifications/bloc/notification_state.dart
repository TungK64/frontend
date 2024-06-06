part of 'notification_bloc.dart';

enum NotificationStatus { initial, loading, changeScreen, changeStatus, rejectTopic, acceptTopic }

class NotificationState {
  List<dynamic> items = [];
  List<dynamic> project = [];
  List<dynamic> task = [];
  NotificationStatus status = NotificationStatus.initial;

  NotificationState clone(NotificationStatus status) {
    NotificationState state = NotificationState();
    state.status = status;
    state.items = items;
    state.project = project;
    state.task = task;
    return state;
  }
}
