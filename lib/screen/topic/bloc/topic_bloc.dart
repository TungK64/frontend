import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/constants/constant.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      // final url = Uri.parse("http://192.168.98.179:8080/api/v1/get-topic/${}");
    });
  }
}
