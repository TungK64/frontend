import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screen/components/loading_icon.dart';
import 'package:frontend/screen/task/bloc/task_bloc.dart';
import 'package:frontend/screen/task/component/TaskColumn.dart';
import 'package:meta/meta.dart';

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
                          "task".tr(),
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
                          Expanded(child: TaskColumn("Done"))
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ));
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
