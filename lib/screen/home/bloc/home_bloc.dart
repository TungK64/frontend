import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pHUST/constants/constant.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    _onHomeInitialEvent();
    _onAddClassEvent();
  }

  _onHomeInitialEvent() {
    on<HomeInitialEvent>((event, emit) async {
      emit(state.clone(HomeStatus.loading));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userNumer = prefs.getString(USER_NUMBER);

      String uri = "${HOST}get-project/${prefs.getString(USER_NUMBER)}";
      final url = Uri.parse(uri);

      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        state.items = jsonResponse;
        List<dynamic> lecNumber = [];
        for (int i = 0; i < jsonResponse.length; i++) {
          if (jsonResponse[i]['lectureNumber'] != null) {
            lecNumber.add(jsonResponse[i]['lectureNumber']);
          }
        }
        if (lecNumber.isNotEmpty) {
          String lecNumberString = lecNumber.join(',');
          final getNameUrl = Uri.parse(
              "${HOST}get-lectures-name/number?list=$lecNumberString");

          final getNameResponse = await http.get(getNameUrl);

          if (getNameResponse.statusCode == 200) {
            List<dynamic> jsonGetNameResponse =
                jsonDecode(utf8.decode(getNameResponse.bodyBytes));
            for (var name in jsonGetNameResponse) {
              if (name is String) {
                state.lecName.add(name);
              }
            }
          } else {
            state.lecName = [];
          }
        }
      } else {
        state.items = [];
      }

      final getUnreadNotification = Uri.parse("${HOST}get-unread-noti/$userNumer");
      final unreadNotiResponse = await http.get(getUnreadNotification);
      if(unreadNotiResponse.statusCode == 200) {
        state.unread = unreadNotiResponse.body;
      }
      emit(state.clone(HomeStatus.initial));
    });
  }

  _onAddClassEvent() {
    on<AddClassEvent>((event, emit) async {
      emit(state.clone(HomeStatus.loading));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? role = prefs.getString(ROLE);
      String? userNumber = prefs.getString(USER_NUMBER);

      final uri = Uri.parse("${HOST}add-class/${event.classCode}/$userNumber/$role");
      final response = await http.put(uri);
      state.message = response.body;
      showDialog(
        context: event.context,
        builder:
            (BuildContext
                context) {
          return AlertDialog(
            title: state.message == "Successfully added class" ? Text(
                "Success"
                    .tr()) : Text(
                "Failed"
                    .tr()),
            content: Text(
                state.message.tr()
                    ),
            actions: [
              ElevatedButton(
                onPressed:
                    () {
                  Navigator.of(
                          context)
                      .pop();
                },
                child: Text(
                    "OK"),
              ),
            ],
          );
        },
      );
      emit(state.clone(HomeStatus.addClassDone));
    });
  }
}
