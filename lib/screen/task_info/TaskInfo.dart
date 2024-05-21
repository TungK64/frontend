import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screen/components/loading_icon.dart';
import 'package:frontend/screen/task/bloc/task_bloc.dart';

class TaskInfo extends StatefulWidget {
  dynamic taskInfo;

  TaskInfo(this.taskInfo, {super.key});

  @override
  State<StatefulWidget> createState() => _taskInfoState();
}

class _taskInfoState extends State<TaskInfo> {
  late TaskBloc bloc;
  late dynamic taskInfo;
  DateTime? _selectedDate;
  final List<String> statusList = <String>['To do', 'On progress', 'Done'];
  late String dropdownValue;
  late String priorityText;

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
  }

  @override
  void initState() {
    super.initState();
    taskInfo = widget.taskInfo;
    dropdownValue = statusList.first;
    priorityText = "-";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc()..add(TaskInfoEvent(taskInfo)),
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
            body: Column(children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 3,
                      color: Color.fromARGB(255, 236, 233, 232),
                    ),
                  ),
                ),
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 15, top: 30),
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
                      "task".tr(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.done,
                        size: 24,
                      ),
                    )
                  ]),
                ),
              ),
              Container(
                color: Color.fromARGB(255, 240, 240, 240),
                height: 30,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.lock,
                      size: 18,
                      color: Color.fromARGB(255, 109, 110, 111),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Private to members of its project".tr(),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 109, 110, 111),
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                            taskInfo['taskName'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Assignee".tr(),
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Builder(builder: (context) {
                                    return Text(
                                      state.assignee['userName'] ?? "Unknown",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    );
                                  })
                                ],
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'project'.tr(),
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Builder(builder: (context) {
                                    return Text(
                                      state.projectInfo["projectName"] ??
                                          "Unknown",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    );
                                  })
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () => selectDate(context),
                            child: Row(
                              children: [
                                Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.red),
                                      borderRadius: BorderRadius.circular(18)),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Due date".tr(),
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      _selectedDate == null
                                          ? tr(
                                              "Pick a date") // Change this line
                                          : DateFormat('dd MMMM yyyy')
                                              .format(_selectedDate!),
                                      style: _selectedDate == null
                                          ? TextStyle(
                                              color: Colors.grey.shade400)
                                          : const TextStyle(
                                              color: Colors.red, fontSize: 16),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "topic".tr(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                state.topicInfo['topicName'] ?? "Unknown",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              DropdownMenu<String>(
                                width: 150,
                                textStyle: TextStyle(color: Colors.grey),
                                inputDecorationTheme: InputDecorationTheme(
                                  border: InputBorder.none,
                                ),
                                initialSelection: statusList.first,
                                onSelected: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    dropdownValue = value!;
                                  });
                                },
                                dropdownMenuEntries: statusList
                                    .map<DropdownMenuEntry<String>>(
                                        (String value) {
                                  return DropdownMenuEntry<String>(
                                      value: value, label: value);
                                }).toList(),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      color: Color.fromARGB(255, 240, 240, 240),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              "Priority".tr(),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                          ),
                          Expanded(
                              child: Center(
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: ((BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          height: 300,
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
                                                    "Choose priority".tr(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      priorityText = "-";
                                                      Navigator.of(context)
                                                          .pop();
                                                    });
                                                  },
                                                  child: const Center(
                                                    child: Text(
                                                      "-",
                                                      style: TextStyle(
                                                          fontSize: 22),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      priorityText = "High";
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Center(
                                                    child: Container(
                                                      width: 100,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: Color.fromARGB(
                                                              255,
                                                              240,
                                                              106,
                                                              106)),
                                                      child: Center(
                                                        child:
                                                            Text("High".tr()),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      priorityText = "Medium";
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Center(
                                                    child: Container(
                                                      width: 100,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: Color.fromARGB(
                                                              255,
                                                              236,
                                                              141,
                                                              113)),
                                                      child: Center(
                                                        child:
                                                            Text("Medium".tr()),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      priorityText = "Low";
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Center(
                                                    child: Container(
                                                      width: 100,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: Color.fromARGB(
                                                              255,
                                                              241,
                                                              189,
                                                              108)),
                                                      child: Center(
                                                        child: Text("Low".tr()),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }));
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: priorityText == "-"
                                    ? null
                                    : priorityText == "High"
                                        ? BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: const Color.fromARGB(
                                                255, 240, 106, 106))
                                        : priorityText == "Medium"
                                            ? BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: const Color.fromARGB(
                                                    255, 236, 141, 113))
                                            : BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: const Color.fromARGB(
                                                    255, 241, 189, 108)),
                                child: Center(
                                  child: Text(
                                    priorityText.tr(),
                                    style: priorityText == "-"
                                        ? const TextStyle(fontSize: 20)
                                        : const TextStyle(
                                            color: Colors.black, fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "description".tr(),
                            style: TextStyle(color: Colors.black87),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          taskInfo['description'] != null
                              ? Text(
                                  taskInfo['description'],
                                  style: TextStyle(fontSize: 18),
                                )
                              : TextField(
                                  decoration: InputDecoration(
                                      hintText:
                                          "Add more detail for this task".tr(),
                                      border: InputBorder.none),
                                )
                        ],
                      ),
                    ),
                    Container(
                      height: 0.8,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Attachments"),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 100,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: taskInfo['attachments'] != null
                                    ? taskInfo['attachments'].length + 1
                                    : 1,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 20),
                                      child: Container(
                                        width: 70,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(width: 1)),
                                        child: Icon(Icons.add),
                                      ),
                                    );
                                  }
                                }),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ))
            ]),
          );
        });
  }
}
