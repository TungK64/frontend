part of 'home_bloc.dart';

enum HomeStatus { initial, loading, changeScreen }

class HomeState {
  List<dynamic> items = [];
  List<String> lecName = [];
  HomeStatus status = HomeStatus.initial;

  HomeState clone(HomeStatus status) {
    HomeState state = HomeState();
    state.status = status;
    state.items = items;
    state.lecName = lecName;
    return state;
  }
}
