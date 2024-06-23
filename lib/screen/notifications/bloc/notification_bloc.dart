import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pHUST/constants/constant.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationState()) {
    _onNotificationInitialEvent();
    _onChangeStatusEvent();
    _onRejectTopicEvent();
    _onAcceptTopicEvent();
  }

  _onNotificationInitialEvent() {
    on<NotificationInitialEvent>((event, emit) async {
      emit(state.clone(NotificationStatus.loading));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userNumber = prefs.getString(USER_NUMBER);
      final getNotificationUrl = Uri.parse("${HOST}get-notification/$userNumber");
      final getNoti = await http.get(getNotificationUrl);
      // debugPrint(getNoti.body);
      if(getNoti.statusCode == 200) {
        Map<String ,dynamic> jsonNotiMap = jsonDecode(utf8.decode(getNoti.bodyBytes)); 
        state.items = jsonNotiMap["0"]!;
        state.task = jsonNotiMap["1"]!;
        state.project = jsonNotiMap["2"]!;
      } else {
        state.items = [];
        state.task = [];
        state.project = [];
      }

      emit(state.clone(NotificationStatus.initial));
    });
  }

  _onChangeStatusEvent() {
    on<NotificationChangeStatusEvent>((event, emit) async {
      emit(state.clone(NotificationStatus.loading));
      final notiId = state.items[event.index]['notificationId'];
      final changeStatusNotiUrl = Uri.parse("${HOST}change-status-noti/$notiId");
      final response = await http.put(changeStatusNotiUrl);
      if(response.statusCode == 200) {
        state.items[event.index]['status'] = true;
      }
      emit(state.clone(NotificationStatus.changeStatus));
    });
  }

  _onRejectTopicEvent() {
    on<NotificationRejectTopic>((event, emit) async {
      emit(state.clone(NotificationStatus.loading));
      final rejectTopicUrl = Uri.parse("${HOST}reject-topic/${state.items[event.index]["receiver"]}/${state.items[event.index]["reporter"]}/${state.items[event.index]["notificationId"]}");
      final data = state.items[event.index]["message"].substring(state.items[event.index]["message"].indexOf(":") + 2, 
          state.items[event.index]["message"].indexOf("with") - 1);
      final jsonBody = jsonEncode(data);
      final response = await http.post(rejectTopicUrl, headers: {"Content-Type": "application/json"}, body: jsonBody);
      if(response.statusCode == 200) {
        state.items.remove(state.items[event.index]);
      }

      emit(state.clone(NotificationStatus.rejectTopic));
    });
  }


  _onAcceptTopicEvent() {
    on<NotificationAcceptTopic>((event, emit) async {
      emit(state.clone(NotificationStatus.loading));
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      

      final acceptTopicUrl = Uri.parse("${HOST}accept-topic/${state.items[event.index]["receiver"]}/${state.items[event.index]["reporter"]}/${state.items[event.index]["notificationId"]}");
      Map<String, String> data = {"topicName": state.items[event.index]["message"].substring(state.items[event.index]["message"].indexOf(":") + 2, 
          state.items[event.index]["message"].indexOf("with") - 1),
                  "description": state.items[event.index]["message"].substring(state.items[event.index]["message"].indexOf("description") + 13, 
          state.items[event.index]["message"].indexOf("to:") - 1),
                  "classCode": state.items[event.index]["message"].substring(state.items[event.index]["message"].length - 6)
          };
      final jsonBody = jsonEncode(data);
      final response = await http.post(acceptTopicUrl, headers: {"Content-Type": "application/json"}, body: jsonBody);
      if(response.statusCode == 200) {
        state.items.remove(state.items[event.index]);
      }
      emit(state.clone(NotificationStatus.acceptTopic));
    });
  }

}

