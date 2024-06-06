part of 'home_bloc.dart';

enum HomeStatus { initial, loading, changeScreen }

class HomeState {
  List<dynamic> items = [];
  List<String> lecName = [];
  String unread = "0";
  HomeStatus status = HomeStatus.initial;

  HomeState clone(HomeStatus status) {
    HomeState state = HomeState();
    state.status = status;
    state.items = items;
    state.lecName = lecName;
    state.unread = unread;
    return state;
  }
}
