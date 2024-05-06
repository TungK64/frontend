import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/constants/constant.dart';
import 'package:meta/meta.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

part 'topic_state.dart';
part 'topic_event.dart';

class TopicBloc extends Bloc<TopicEvent, TopicState> {
  TopicBloc() : super(TopicState()) {
    _onTopicInitialEvent();
  }

  _onTopicInitialEvent() {
    on<TopicInitialEvent>((event, emit) async {
      emit(state.clone(TopicStatus.loading));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? role = prefs.getString(ROLE);
      state.role = role!;
      String? userNumber = prefs.getString(USER_NUMBER);
      String? projectId = prefs.getString(PROJECT_ID);

      final url = Uri.parse("${HOST}get-topic/${projectId}");
      final getTopic = await http.get(url);

      if (getTopic.statusCode == 200) {
        List<dynamic> jsonTopicList =
            jsonDecode(utf8.decode(getTopic.bodyBytes));

        state.topicList = jsonTopicList;
      } else {
        state.topicList = [];
      }
      if (role == "Student") {
        final urlGetTopic =
            Uri.parse("${HOST}get-topic-by-student/${projectId}/${userNumber}");
        final getTopicByStudent = await http.get(urlGetTopic);

        if (getTopicByStudent.statusCode == 200) {
          dynamic topic = jsonDecode(utf8.decode(getTopicByStudent.bodyBytes));
          state.topic = topic;
        } else {
          state.topic = null;
        }
      }

      emit(state.clone(TopicStatus.initial));
    });
  }
}
