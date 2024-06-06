part of 'notification_bloc.dart';

abstract class NotificationEvent {}

class NotificationInitialEvent extends NotificationEvent {}

class NotificationChangeStatusEvent extends NotificationEvent {
  final int index;
  NotificationChangeStatusEvent(this.index);
}

class NotificationRejectTopic extends NotificationEvent {
  final int index;
  NotificationRejectTopic(this.index);
}

class NotificationAcceptTopic extends NotificationEvent {
  final int index;
  NotificationAcceptTopic(this.index);
}