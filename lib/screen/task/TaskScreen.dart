import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/constants/constant.dart';
import 'package:frontend/screen/components/loading_icon.dart';
import 'package:frontend/screen/task/bloc/task_bloc.dart';
import 'package:frontend/screen/task/component/TaskColumn.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TaskScreen extends StatefulWidget {
  TaskScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late TaskBloc bloc;
  late ScrollController _scrollController;
  late double _scrollPosition;
  static const double _scrollThreshold = 40;
  DateTime? _selectedDate;
  DateTime? _deadline;
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
    setState(() {
      _deadline = _selectedDate;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollPosition = 0.0;
  }

  @override
  Widget build(Object context) {
    return BlocProvider(
      create: (context) => TaskBloc(),
      child: Builder(
        builder: (context) => _buildViewChild(context),
      ),
    );
  }

  Widget _buildViewChild(BuildContext context) {
    bloc = BlocProvider.of<TaskBloc>(context);
    return BlocBuilder<TaskBloc, TaskState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.status == TaskStatus.loading) {
            return const Center(
              child: LoadingIcon(),
            );
          }
          return Scaffold(
            body: Column(
              children: [
                SizedBox(
                    height: 80,
                    child: Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 30),
                        child: Row(children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              size: 25,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Task".tr(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ]))),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Listener(
                    onPointerMove: _handlePointerMove,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      child: SizedBox(
                        width: 1000,
                        child: Row(
                          children: [
                            Expanded(child: TaskColumn("To-do")),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(child: TaskColumn("On progress")),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(child: TaskColumn("Done")),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(child: TaskColumn("Cancel"))
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.lightBlue),
                  child: FloatingActionButton(
                    backgroundColor: Colors.lightBlue,
                    elevation: 0,
                    heroTag: 'Create task',
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: ((BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  height: 350,
                                  width: 250,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Center(
                                          child: Text(
                                            "Create Task".tr(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextField(
                                          controller: taskNameController,
                                          decoration: InputDecoration(
                                              hintText: "TASK NAME...",
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 20)),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            final DateTime? pickedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: _selectedDate ??
                                                  DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2101),
                                            );
                                            if (pickedDate != null &&
                                                pickedDate != _selectedDate) {
                                              setState(() {
                                                _selectedDate = pickedDate;
                                              });
                                            }
                                            setState(() {
                                              _deadline = _selectedDate;
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 35,
                                                width: 35,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: _selectedDate !=
                                                                null
                                                            ? Colors.red
                                                            : Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18)),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.calendar_month,
                                                    color: Colors.red,
                                                    size: 24,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Due date".tr(),
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16),
                                                  ),
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    _deadline == null
                                                        ? tr(
                                                            "Pick a date") // Change this line
                                                        : DateFormat(
                                                                'dd MM yyyy')
                                                            .format(_deadline!),
                                                    style: _deadline == null
                                                        ? TextStyle(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                221, 140, 140))
                                                        : const TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Description".tr(),
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 18),
                                        ),
                                        TextField(
                                            controller: descriptionController,
                                            decoration: InputDecoration(
                                              hintText:
                                                  "Add description for task",
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14),
                                            )),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateColor
                                                          .resolveWith(
                                                    (states) {
                                                      return Colors.white;
                                                    },
                                                  ),
                                                  side: MaterialStateBorderSide
                                                      .resolveWith(
                                                    (states) {
                                                      return const BorderSide(
                                                          color: Colors.red);
                                                    },
                                                  ),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  _deadline = null;
                                                  taskNameController.clear();
                                                  descriptionController.clear();
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Cancel".tr(),
                                                  style: const TextStyle(
                                                      color: Colors.red),
                                                )),
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateColor
                                                          .resolveWith(
                                                    (states) {
                                                      return Colors.white;
                                                    },
                                                  ),
                                                  side: MaterialStateBorderSide
                                                      .resolveWith(
                                                    (states) {
                                                      return const BorderSide(
                                                          color: Colors.blue);
                                                    },
                                                  ),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  String? topicId =
                                                      prefs.getString(TOPIC_ID);
                                                  String? userNumber = prefs
                                                      .getString(USER_NUMBER);
                                                  String? studentNumber =
                                                      prefs.getString(
                                                          STUDENT_NUMBER);
                                                  String? role =
                                                      prefs.getString(ROLE);

                                                  String taskName =
                                                      taskNameController.text;
                                                  String description =
                                                      descriptionController
                                                          .text;
                                                  if (taskName.isNotEmpty) {
                                                    var createTaskUrl;
                                                    if (role == "Lecture") {
                                                      createTaskUrl = Uri.parse(
                                                          "${HOST}create-task/$topicId/$userNumber/$studentNumber");
                                                    } else {
                                                      createTaskUrl = Uri.parse(
                                                          "${HOST}create-task/$topicId/$userNumber/$userNumber");
                                                    }
                                                    Map<String, dynamic> data =
                                                        {"taskName": taskName};
                                                    if (description
                                                        .isNotEmpty) {
                                                      data.addAll({
                                                        "description":
                                                            description
                                                      });
                                                    }
                                                    if (_selectedDate != null) {
                                                      data.addAll({
                                                        "deadline":
                                                            _selectedDate
                                                                .toString()
                                                      });
                                                    }
                                                    String jsonBody =
                                                        jsonEncode(data);
                                                    final response = await http
                                                        .post(createTaskUrl,
                                                            headers: {
                                                              "Content-Type":
                                                                  "application/json"
                                                            },
                                                            body: jsonBody);
                                                    if (response.statusCode ==
                                                        201) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      // Close current dialog
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "Success".tr()),
                                                            content: Text(
                                                                "Task created successfully"
                                                                    .tr()),
                                                            actions: [
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  Navigator.pushReplacement(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder:
                                                                              (context) {
                                                                    return TaskScreen();
                                                                  }));
                                                                },
                                                                child:
                                                                    Text("OK"),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                      _selectedDate = null;
                                                      taskNameController
                                                          .clear();
                                                      descriptionController
                                                          .clear();
                                                    } else {}
                                                  }
                                                },
                                                child: Text(
                                                  "Create".tr(),
                                                  style: const TextStyle(
                                                      color: Colors.blue),
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                          }));
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.add,
                          size: 25,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'New task'.tr(),
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        });
  }

  void _handlePointerMove(PointerEvent event) {
    _scrollPosition = _scrollController.position.pixels;

    if (event.position.dx >=
            MediaQuery.of(context).size.width - _scrollThreshold &&
        _scrollController.position.maxScrollExtent > _scrollPosition) {
      // Scroll right
      _scrollController.animateTo(
        _scrollPosition + 50,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    } else if (event.position.dx <= _scrollThreshold &&
        _scrollPosition > _scrollController.position.minScrollExtent) {
      // Scroll left
      _scrollController.animateTo(
        _scrollPosition - 50,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    }
  }
}
