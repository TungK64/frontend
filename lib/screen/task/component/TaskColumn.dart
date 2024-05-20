import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screen/components/loading_icon.dart';
import 'package:frontend/screen/task/bloc/task_bloc.dart';
import 'package:frontend/screen/task_create/TaskInfo.dart';
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
          default:
            items = [];
        }

        return DragTarget<Map>(onAccept: (data) {
          final taskId = data['taskId'];
          final context = data['context'];
          bloc.add(TaskDragEvent(taskId, context, widget.taskStatus));
        }, builder: (context, candidateData, rejectData) {
          return SizedBox(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.taskStatus.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                          default:
                            displayText = '';
                        }
                        return Draggable<Map>(
                          data: {
                            'taskId': items[index]['taskID'],
                            'context': context,
                          },
                          feedback: Material(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Container(
                                height: 80,
                                width: 300,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    color: Colors.lightBlue.shade100),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10, left: 10),
                                  child: Text(displayText),
                                ),
                              ),
                            ),
                          ),
                          childWhenDragging: Container(),
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
                                height: 80,
                                width: 300,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    color: Colors.lightBlue.shade100),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10, left: 10),
                                  child: Text(displayText),
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
