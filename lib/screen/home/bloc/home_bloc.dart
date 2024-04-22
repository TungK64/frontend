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
          "http://127.0.0.1:8080/api/v1/get-project/${prefs.getString(USER_NUMBER)}";
      final url = Uri.parse(uri);

      final response = await http.get(url);

      List<Map<String, dynamic>> jsonResponse = jsonDecode(response.body);
      state.items = jsonResponse;
      emit(state.clone(HomeStatus.initial));
    });
  }
}
