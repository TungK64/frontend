import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/constants/constant.dart';
import 'package:frontend/screen/components/loading_icon.dart';
import 'package:frontend/screen/task/TaskScreen.dart';
import 'package:meta/meta.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskState()) {
    _onTaskInitialEvent();
    _onTaskDragEvent();
    _onTaskInfoEvent();
  }

  _onTaskInitialEvent() {
    on<TaskInitialEvent>((event, emit) async {
      emit(state.clone(TaskStatus.loading));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? topicId = prefs.getString(TOPIC_ID);
      String? role = prefs.getString(ROLE);
      String? studentNumber = prefs.getString(STUDENT_NUMBER);
      String? userNumber = prefs.getString(USER_NUMBER);

      if (role == "Student") {
        final getTaskTodo =
            Uri.parse("${HOST}get-task/$topicId/to-do/$userNumber");
        final getTaskOnProgress =
            Uri.parse("${HOST}get-task/$topicId/on-progress/$userNumber");
        final getTaskDone =
            Uri.parse("${HOST}get-task/$topicId/done/$userNumber");

        final todoTaskList = await http.get(getTaskTodo);
        final onProgressTaskList = await http.get(getTaskOnProgress);
        final doneTaskList = await http.get(getTaskDone);

        if (todoTaskList.statusCode == 200) {
          List<dynamic> jsonTodoTaskList =
              jsonDecode(utf8.decode(todoTaskList.bodyBytes));
          state.items.add(jsonTodoTaskList);
        } else {
          state.items.add([]);
        }

        if (onProgressTaskList.statusCode == 200) {
          List<dynamic> jsonOnProgressTaskList =
              jsonDecode(utf8.decode(onProgressTaskList.bodyBytes));
          state.items.add(jsonOnProgressTaskList);
        } else {
          state.items.add([]);
        }

        if (doneTaskList.statusCode == 200) {
          List<dynamic> jsonDoneTaskList =
              jsonDecode(utf8.decode(doneTaskList.bodyBytes));
          state.items.add(jsonDoneTaskList);
        } else {
          state.items.add([]);
        }
        emit(state.clone(TaskStatus.initial));
      } else {
        final getTaskTodo =
            Uri.parse("${HOST}get-task/$topicId/to-do/$studentNumber");
        final getTaskOnProgress =
            Uri.parse("${HOST}get-task/$topicId/on-progress/$studentNumber");
        final getTaskDone =
            Uri.parse("${HOST}get-task/$topicId/done/$studentNumber");

        final todoTaskList = await http.get(getTaskTodo);
        final onProgressTaskList = await http.get(getTaskOnProgress);
        final doneTaskList = await http.get(getTaskDone);

        if (todoTaskList.statusCode == 200) {
          List<dynamic> jsonTodoTaskList =
              jsonDecode(utf8.decode(todoTaskList.bodyBytes));
          state.items.add(jsonTodoTaskList);
        } else {
          state.items.add([]);
        }

        if (onProgressTaskList.statusCode == 200) {
          List<dynamic> jsonOnProgressTaskList =
              jsonDecode(utf8.decode(onProgressTaskList.bodyBytes));
          state.items.add(jsonOnProgressTaskList);
        } else {
          state.items.add([]);
        }

        if (doneTaskList.statusCode == 200) {
          List<dynamic> jsonDoneTaskList =
              jsonDecode(utf8.decode(doneTaskList.bodyBytes));
          state.items.add(jsonDoneTaskList);
        } else {
          state.items.add([]);
        }
        emit(state.clone(TaskStatus.initial));
      }
    });
  }

  _onTaskDragEvent() {
    on<TaskDragEvent>((event, emit) async {
      emit(state.clone(TaskStatus.loading));

      String newStatus = event.newStatus;
      newStatus = newStatus.toLowerCase();
      newStatus = newStatus.replaceAll(" ", "-");
      final context = event.context;

      final changeStatusUrl =
          Uri.parse("${HOST}change-status/${event.taskId}/$newStatus");
      final response = await http.put(changeStatusUrl);
      if (response.statusCode == 200) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return TaskScreen();
        }));

        emit(state.clone(TaskStatus.dragTask));
      } else {
        emit(state.clone(TaskStatus.dragTask));
      }
    });
  }

  _onTaskInfoEvent() {
    on<TaskInfoEvent>((event, emit) async {
      emit(state.clone(TaskStatus.loading));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? role = prefs.getString(ROLE);
      String? userNumber = prefs.getString(USER_NUMBER);
      String? studentNumber = prefs.getString(STUDENT_NUMBER);
      String assigneeNumber = event.taskInfo['assignee'];

        final getAssigneeUrl = Uri.parse("${HOST}get-user/$assigneeNumber/Student");
        final response = await http.get(getAssigneeUrl);
        if(response.statusCode == 200) {
          dynamic assignee = jsonDecode(utf8.decode(response.bodyBytes));
          state.assignee = assignee;
        } else {
          state.assignee = {};
        }
      
      emit(state.clone(TaskStatus.getTaskInfo));
    });
    
  }
}
