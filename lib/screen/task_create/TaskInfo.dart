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

  @override
  void initState() {
    super.initState();
    taskInfo = widget.taskInfo;
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40,),
                      Text(taskInfo['taskName'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                      const SizedBox(height: 15,),
                      Text("Assignee".tr(), style: TextStyle(color: Colors.grey, fontSize: 16),),
                      const SizedBox(height: 5,),
                      Builder(
                        builder: (context) {
                          return Text(state.assignee['userName'] ?? "Unknown");
                        }
                      )
                    ],),
                ),
              ))
            ]),
          );
        });
  }
}
