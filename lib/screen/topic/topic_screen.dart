import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/constants/constant.dart';
import 'package:frontend/screen/components/loading_icon.dart';
import 'package:frontend/screen/student_in_topic/StudentListOfTopic.dart';
import 'package:frontend/screen/topic/bloc/topic_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TopicScreen extends StatefulWidget {
  @override
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  late TopicBloc bloc;
  Color topicText = Colors.red;
  Color studentText = Colors.black;
  final TextEditingController topicNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String alertText = "";

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
                ),
                const Spacer(),
                if (topicText == Colors.red)
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15)),
                                height: 300,
                                width: 300,
                                child: Column(children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Tạo đề tài".tr(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    color: Colors.red,
                                    height: 0.8,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 20, left: 15, right: 15),
                                    child: Column(children: [
                                      TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            alertText = "";
                                          });
                                        },
                                        controller: topicNameController,
                                        decoration: InputDecoration(
                                            labelText: "Tên đề tài".tr()),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        controller: descriptionController,
                                        decoration: InputDecoration(
                                            labelText: "mô tả".tr()),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        alertText,
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 17),
                                      ),
                                      const SizedBox(
                                        height: 5,
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
                                                String topicName =
                                                    topicNameController.text;
                                                String topicDescription =
                                                    descriptionController.text;
                                                if (topicName.isEmpty) {
                                                  setState(() {
                                                    alertText =
                                                        "Please fill in all information"
                                                            .tr();
                                                  });
                                                } else {
                                                  Map<String, dynamic>
                                                      jsonData = {
                                                    'topicName': topicName,
                                                    'description':
                                                        topicDescription
                                                  };
                                                  String jsonBody =
                                                      jsonEncode(jsonData);
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  String? projectId = prefs
                                                      .getString(PROJECT_ID);
                                                  final createTopicUrl = Uri.parse(
                                                      "${HOST}create-topic/$projectId");
                                                  final response = await http
                                                      .post(createTopicUrl,
                                                          headers: {
                                                            "Content-Type":
                                                                "application/json"
                                                          },
                                                          body: jsonBody);
                                                  if (response.statusCode ==
                                                      201) {
                                                    Navigator.of(context)
                                                        .pop(); // Close current dialog
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title:
                                                              Text("Success"),
                                                          content: Text(
                                                              "Topic created successfully!"),
                                                          actions: [
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text("OK"),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                    TopicBloc()
                                                      ..add(
                                                          TopicInitialEvent());
                                                  } else {
                                                    setState(() {
                                                      alertText = response.body;
                                                    });
                                                  }
                                                }
                                              },
                                              child: Text("Create".tr(),
                                                  style: const TextStyle(
                                                      color: Colors.lightBlue)))
                                        ],
                                      )
                                    ]),
                                  )
                                ]),
                              ),
                            );
                          });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.blue)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add_circle_outline,
                              size: 28,
                              color: Colors.red,
                            ),
                            Text(
                              "Tạo đề tài".tr(),
                              style: const TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
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
                          itemCount: state.topicList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                final urlGetStudentTopic = Uri.parse(
                                    "${HOST}get-student-in-topic/${state.topicList[index]['topicId']}");
                                final studentListOfTopic =
                                    await http.get(urlGetStudentTopic);
                                if (studentListOfTopic.statusCode == 200) {
                                  List<dynamic> studentList = jsonDecode(utf8
                                      .decode(studentListOfTopic.bodyBytes));
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return StudentListOfTopic(
                                        studentList, state.topicList[index]);
                                  }));
                                } else {
                                  return null;
                                }
                              },
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
                                      Text(
                                        state.topicList[index]['topicName'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return ListView.builder(
                          itemCount: state.studentList.length,
                          itemBuilder: (context, index) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${state.studentList[index]['userName']} - ${state.studentList[index]["userNumber"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Đề tài: ".tr(),
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                state.topic != null
                                                    ? (state.topic["topicName"])
                                                    : Text("")
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
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
