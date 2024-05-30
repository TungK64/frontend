part of 'topic_bloc.dart';

@immutable
abstract class TopicEvent {}

class TopicInitialEvent extends TopicEvent {}

class CreateTopicEvent extends TopicEvent {}

class RegisterTopicEvent extends TopicEvent {}

class EditTopicEvent extends TopicEvent{
  final int index;
  final String newTopicName;
  final String newDescription;
  EditTopicEvent(this.index, this.newTopicName, this.newDescription);
}

class DeleteTopicEvent extends TopicEvent{
  final int index;
  DeleteTopicEvent(this.index);
}
