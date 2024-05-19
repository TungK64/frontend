// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:frontend/screen/components/loading_icon.dart';
// import 'package:frontend/screen/task/bloc/task_bloc.dart';
// import 'package:frontend/screen/topic/bloc/topic_bloc.dart';

// class TaskColumn extends StatefulWidget {

//   late String taskStatus;
//   TaskColumn(this.taskStatus, {super.key});

//   @override
//   _TaskColumnState createState() => _TaskColumnState();
// }

// class _TaskColumnState extends State<TaskColumn> {
//   late TaskBloc bloc;
//   late String taskStatus;

//   @override
//   void initState() {
//     super.initState();
//     taskStatus = widget.taskStatus;
//   }

//   @override
//   Widget build(Object context) {
//     return BlocProvider(
//       create: (context) => TaskBloc()..add(TaskInitialEvent()),
//       child: Builder(
//         builder: (context) => _buildViewChild(context),
//       ),
//     );
//   }

//   Widget _buildViewChild(BuildContext context) {
//     bloc = BlocProvider.of<TaskBloc>(context);
//     return BlocBuilder<TaskBloc, TaskState>(
//       bloc: bloc,
//       builder: (context, state) {
        
//         return SizedBox(
//           width: 300,
//           child: Padding(
//             padding: const EdgeInsets.only(left: 15.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(taskStatus.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
//                 const SizedBox(height: 10,),
//                 if(state.items.isEmpty)
//                   Container()
//                 else 
//                   if(taskStatus == "To-do")
//                     if(state.items[0].isEmpty)
//                       Container()
//                   else if(taskStatus == "On progress") 
//                     if(state.items[1].isEmpty)
//                       Container()
//                   else if(taskStatus == "Done") 
//                     if(state.items[2].isEmpty)
//                       Container()
//                   else 
//                     ListView.builder(
//                       itemCount: state.items.length,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           height: 80,
//                           width: 300,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                             border: Border.all(width: 1, color: Colors.grey)
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.only(top: 10, left: 10),
//                             child: taskStatus == "To-do" ? Text(state.items[0][index]['userName']) : 
//                               taskStatus == "On progress" ? Text(state.items[1][index]['taskName']) :
//                               Text(state.items[2][index]['topicName']),
//                           ),
//                         );
//                       }
//                     ),
//               ],
//             ),
//           ),
//         );
//       }
//     );
//   }
// }

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screen/components/loading_icon.dart';
import 'package:frontend/screen/task/bloc/task_bloc.dart';
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

        return DragTarget<Map>(
          onAccept: (data) {
             final taskId = data['taskId'];
             bloc.add(TaskDragEvent(taskId, widget.taskStatus));
          },
          builder: (context, candidateData, rejectData) {
          return SizedBox(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
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
                      shrinkWrap: true,  // Added to avoid infinite height error
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
                            'taskId': items[index]['taskID']
                          },
                          feedback: Material(child:Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Container(
                              height: 80,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(width: 1, color: Colors.grey),
                                color: Colors.lightBlue.shade100
                              ),
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
                            child: Container(
                              height: 80,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(width: 1, color: Colors.grey),
                                color: Colors.lightBlue.shade100
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, left: 10),
                                child: Text(displayText),
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
        }
        );
      },
    );
  }
}
