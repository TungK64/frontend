import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/constants/constant.dart';
import 'package:frontend/screen/home/bloc/home_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountState()) {
    _onAccountInitialEvent();
  }

  _onAccountInitialEvent() {
    on<AccountInitialEvent>((event, emit) async {
      emit(state.clone(AccountStatus.loading));
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? role = prefs.getString(ROLE);
      String? userNumber = prefs.getString(USER_NUMBER);

      final url = Uri.parse(
          "http://192.168.98.179:8080/api/v1/get-user/$userNumber/$role");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));

        state.items = jsonResponse;
      } else {
        state.items = {};
      }
      emit(state.clone(AccountStatus.initial));
    });
  }
}
