import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screen/components/loading_icon.dart';
import 'package:frontend/screen/task/bloc/task_bloc.dart';

class TaskCreateScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _taskCreateScreenState();
}

class _taskCreateScreenState extends State<TaskCreateScreen> {
  late TaskBloc bloc;

  @override
  Widget build(BuildContext context) {
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
                child: Column(),
              ))
            ]),
          );
        });
  }
}
