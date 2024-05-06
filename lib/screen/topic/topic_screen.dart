import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screen/components/loading_icon.dart';
import 'package:frontend/screen/topic/bloc/topic_bloc.dart';

class TopicScreen extends StatefulWidget {
  @override
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  late TopicBloc bloc;
  Color topicText = Colors.red;
  Color studentText = Colors.black;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TopicBloc()..add(TopicInitialEvent()),
      child: Builder(builder: (context) => _buildViewChild(context)),
    );
  }

  Widget _buildViewChild(BuildContext context) {
    bloc = BlocProvider.of<TopicBloc>(context);
    return Scaffold(
      body: Column(children: [
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
                  "topic".tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22),
                )
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

        // Text(
        //   "Hãy lựa chọn hoặc đề xuất đề tài bạn muốn",
        //   style: TextStyle(
        //       fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
        // ),
        Expanded(
            child: BlocBuilder<TopicBloc, TopicState>(
          bloc: bloc,
          builder: (context, state) {
            if (state.status == TopicStatus.loading) {
              return const Center(
                child: LoadingIcon(
                  text: '',
                ),
              );
            }
            if (state.role == "Student") {
              if (state.topic == null) {
                return ListView.builder(
                    itemCount: state.topicList.length + 1,
                    itemBuilder: (context, index) {
                      if (index < state.topicList.length) {
                        return GestureDetector(
                          onTap: () {},
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
                                    "assets/images/topics/topic-logo${index + 1}.png",
                                    width: 65,
                                    height: 65,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(state.topicList[index]['topicName'])
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                                border: Border.all(style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                                child: Column(children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Icon(Icons.add_rounded),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Đề xuất đề tài".tr(),
                                style: TextStyle(fontSize: 20),
                              )
                            ])),
                          ),
                        );
                      }
                    });
              } else {
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 20),
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
                          "assets/images/topics/topic.png",
                          width: 65,
                          height: 65,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(state.topic['topicName'])
                      ],
                    ),
                  ),
                );
              }
            } else {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              studentText = Colors.black;
                              topicText = Colors.red;
                            });
                          },
                          child: Container(
                            height: 40,
                            child: Center(
                                child: Text(
                              "DS đề tài".tr(),
                              style: TextStyle(fontSize: 18, color: topicText),
                            )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              studentText = Colors.red;
                              topicText = Colors.black;
                            });
                          },
                          child: Container(
                            height: 40,
                            child: Center(
                                child: Text(
                              "DS sinh viên".tr(),
                              style:
                                  TextStyle(fontSize: 18, color: studentText),
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                      child: BlocBuilder<TopicBloc, TopicState>(
                    bloc: bloc,
                    builder: (context, state) {
                      if (topicText == Colors.red) {
                        return ListView.builder(
                            itemCount: state.topicList.length + 1,
                            itemBuilder: (context, index) {
                              if (index < state.topicList.length) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, bottom: 20),
                                    child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.grey.shade300),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Image.asset(
                                            "assets/images/topics/topic-logo${index + 1}.png",
                                            width: 65,
                                            height: 65,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(state.topicList[index]
                                              ['topicName'])
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            });
                      } else {
                        return Container();
                      }
                    },
                  ))
                ],
              );
            }
          },
        ))
      ]),
    );
  }
}
