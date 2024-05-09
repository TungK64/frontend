part of 'topic_bloc.dart';

@immutable
abstract class TopicEvent {}

class TopicInitialEvent extends TopicEvent {}

class CreateTopicEvent extends TopicEvent {}

class RegisterTopicEvent extends TopicEvent {}
