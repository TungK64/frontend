import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screen/components/loading_icon.dart';
import 'package:frontend/screen/task/bloc/task_bloc.dart';
import 'package:frontend/screen/task_info/TaskInfo.dart';
import 'package:frontend/screen/topic/bloc/topic_bloc.dart';

class TaskColumn extends StatefulWidget {
  final String taskStatus;
  TaskColumn(this.taskStatus, {Key? key}) : super(key: key);

  @override
  _TaskColumnState createState() => _TaskColumnState();
}

class _TaskColumnState extends State<TaskColumn> {
  late TaskBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc()..add(TaskInitialEvent()),
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
        List<dynamic> items;
        switch (widget.taskStatus) {
          case 'To-do':
            items = state.items.isNotEmpty ? state.items[0] : [];
            break;
          case 'On progress':
            items = state.items.isNotEmpty ? state.items[1] : [];
            break;
          case 'Done':
            items = state.items.isNotEmpty ? state.items[2] : [];
            break;
          case 'Cancel':
            items = state.items.isNotEmpty ? state.items[3] : [];
            break;
          default:
            items = [];
        }

        return DragTarget<Map>(onAccept: (data) {
          final taskId = data['taskId'];
          final context = data['context'];
          final oldStatus = data['oldStatus'];
          final index = data['index'];
          bloc.add(TaskDragEvent(
              taskId, context, index, oldStatus, widget.taskStatus));
        }, builder: (context, candidateData, rejectData) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: widget.taskStatus == "Done"
                    ? Colors.green.shade200
                    : widget.taskStatus == "Cancel"
                        ? Colors.red.shade100
                        : Colors.grey.shade100),
            width: 200,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.taskStatus.tr(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  if (items.isEmpty)
                    Container()
                  else
                    ListView.builder(
                      shrinkWrap: true, // Added to avoid infinite height error
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        String displayText;
                        switch (widget.taskStatus) {
                          case 'To-do':
                            displayText = items[index]['taskName'];
                            break;
                          case 'On progress':
                            displayText = items[index]['taskName'];
                            break;
                          case 'Done':
                            displayText = items[index]['taskName'];
                            break;
                          case 'Cancel':
                            displayText = items[index]['taskName'];
                            break;
                          default:
                            displayText = '';
                        }
                        return Draggable<Map>(
                          data: {
                            'taskId': items[index]['taskID'],
                            'context': context,
                            'index': index,
                            'oldStatus': widget.taskStatus,
                          },
                          feedback: Material(
                            child: Padding(
                              padding: EdgeInsets.zero,
                              child: Container(
                                height: 90,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    color: Colors.lightBlue.shade100),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10, left: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(displayText),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(items[index]['deadline'])
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          childWhenDragging: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return TaskInfo(items[index]);
                                }));
                              },
                              child: Container(
                                height: 90,
                                width: 300,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    color: Colors.lightBlue.shade100),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10, left: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayText,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(items[index]['deadline'])
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
