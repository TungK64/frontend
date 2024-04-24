import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants/constant.dart';
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
  }

  _onHomeInitialEvent() {
    on<HomeInitialEvent>((event, emit) async {
      emit(state.clone(HomeStatus.loading));
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String uri =
          "http://192.168.98.179:8080/api/v1/get-project/${prefs.getString(USER_NUMBER)}";
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
              "http://192.168.98.179:8080/api/v1/get-lectures-name/number?list=$lecNumberString");

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

      emit(state.clone(HomeStatus.initial));
    });
  }
}
