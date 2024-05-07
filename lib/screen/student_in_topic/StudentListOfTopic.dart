import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screen/topic/bloc/topic_bloc.dart';

class StudentListOfTopic extends StatefulWidget {
  List<dynamic> studentList;
  dynamic topic;
  StudentListOfTopic(this.studentList, this.topic, {super.key});

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentListOfTopic> {
  late TopicBloc bloc;
  List<dynamic> studentList = List.empty(growable: true);
  dynamic topic;

  @override
  void initState() {
    super.initState();
    studentList.addAll(widget.studentList);
    topic = widget.topic;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TopicBloc()..add(TopicInitialEvent()),
      child: Builder(builder: (context) => _buildView(context)),
    );
  }

  Widget _buildView(BuildContext context) {
    bloc = BlocProvider.of<TopicBloc>(context);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 80,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
              child: Row(
                children: [
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
                    topic['topicName'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            height: 0.8,
            color: Colors.grey.withOpacity(0.2),
          ),
          Expanded(
            child: BlocBuilder<TopicBloc, TopicState>(
              bloc: bloc,
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.topicList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {},
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 20),
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey.shade300),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Image.asset(
                                "assets/images/avatar_default.jpg",
                                width: 65,
                                height: 65,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                "${studentList[index]['userName']} - ${studentList[index]['userNumber']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
