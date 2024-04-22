part of 'home_bloc.dart';

enum HomeStatus { initial, loading, changeScreen }

class HomeState {
  List<Map<String, dynamic>> items = [];
  HomeStatus status = HomeStatus.initial;

  HomeState clone(HomeStatus status) {
    HomeState state = HomeState();
    state.status = status;
    state.items = items;
    return state;
  }
}
