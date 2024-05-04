part of 'topic_bloc.dart';

enum TopicStatus { initial, loading, changeScreen }

class TopicState {
  List<dynamic> topicList = [];
  dynamic topic;
  late String role;
  TopicStatus status = TopicStatus.initial;

  TopicState clone(TopicStatus status) {
    TopicState state = TopicState();
    state.status = status;
    state.topic = topic;
    state.topicList = topicList;
    state.role = role;
    return state;
  }
}
