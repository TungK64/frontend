part of 'topic_bloc.dart';

enum TopicStatus { initial, loading, changeScreen, createTopic, registerTopic }

class TopicState {
  List<dynamic> topicList = [];
  List<dynamic> studentList = [];
  dynamic topic;
  String? role;
  TopicStatus status = TopicStatus.initial;

  TopicState clone(TopicStatus status) {
    TopicState state = TopicState();
    state.status = status;
    state.topic = topic;
    state.topicList = topicList;
    state.role = role;
    state.studentList = studentList;
    return state;
  }
}
