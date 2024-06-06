import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/constants/constant.dart';
import 'package:frontend/screen/components/loading_icon.dart';
import 'package:frontend/screen/student_in_topic/StudentListOfTopic.dart';
import 'package:frontend/screen/task/TaskScreen.dart';
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
  final TextEditingController suggestTopicController = TextEditingController();
  final TextEditingController suggestDescriptionController = TextEditingController();
  final TextEditingController editTopicController = TextEditingController();
  final TextEditingController editDescriptionController = TextEditingController();
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
      body: BlocBuilder<TopicBloc, TopicState>(
          bloc: bloc,
          builder: (context, state) {
            return Column(children: [
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
                      if (topicText == Colors.red && state.role == "Lecture")
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      height: 300,
                                      width: 300,
                                      child: Column(children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "create_topic".tr(),
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
                                                  labelText: "topic_name".tr()),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            TextField(
                                              controller: descriptionController,
                                              decoration: InputDecoration(
                                                  labelText:
                                                      "description".tr()),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              alertText,
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 17),
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
                                                      side:
                                                          MaterialStateBorderSide
                                                              .resolveWith(
                                                        (states) {
                                                          return const BorderSide(
                                                              color:
                                                                  Colors.red);
                                                        },
                                                      ),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      descriptionController.clear();
                                                      topicNameController.clear();
                                                      Navigator.of(context)
                                                          .pop();
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
                                                      side:
                                                          MaterialStateBorderSide
                                                              .resolveWith(
                                                        (states) {
                                                          return const BorderSide(
                                                              color:
                                                                  Colors.blue);
                                                        },
                                                      ),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      String topicName =
                                                          topicNameController
                                                              .text;
                                                      String topicDescription =
                                                          descriptionController
                                                              .text;

                                                      descriptionController.clear();
                                                      topicNameController.clear();
                                                          
                                                      if (topicName.isEmpty) {
                                                        setState(() {
                                                          alertText =
                                                              "Please fill in all information"
                                                                  .tr();
                                                        });
                                                      } else {
                                                        Map<String, dynamic>
                                                            jsonData = {
                                                          'topicName':
                                                              topicName,
                                                          'topicDescription':
                                                              topicDescription
                                                        };
                                                        String jsonBody =
                                                            jsonEncode(
                                                                jsonData);
                                                        SharedPreferences
                                                            prefs =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        String? projectId =
                                                            prefs.getString(
                                                                PROJECT_ID);
                                                        final createTopicUrl =
                                                            Uri.parse(
                                                                "${HOST}create-topic/$projectId");
                                                        final response =
                                                            await http.post(
                                                                createTopicUrl,
                                                                headers: {
                                                                  "Content-Type":
                                                                      "application/json"
                                                                },
                                                                body: jsonBody);
                                                        if (response
                                                                .statusCode ==
                                                            201) {
                                                              
                                                          Navigator.of(context)
                                                              .pop(); 
                                                          // Close current dialog
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    "Success"
                                                                        .tr()),
                                                                content: Text(
                                                                    "Topic created successfully"
                                                                        .tr()),
                                                                actions: [
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        "OK"),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                          bloc.add(
                                                              CreateTopicEvent());
                                                        } else {
                                                          setState(() {
                                                            alertText =
                                                                response.body;
                                                          });
                                                        }
                                                      }
                                                    },
                                                    child: Text("Create".tr(),
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .lightBlue)))
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
                                border:
                                    Border.all(width: 1, color: Colors.blue)),
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
                                    "create_topic".tr(),
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
              BlocBuilder<TopicBloc, TopicState>(
                bloc: bloc,
                builder: (context, state) {
                  if (state.status == TopicStatus.loading) {
                    return const Expanded(
                      child: Center(
                        child: LoadingIcon(),
                      ),
                    );
                  }
                  if (state.role == "Student") {
                    if (state.topic == null) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: state.topicList.length + 1,
                            itemBuilder: (context, index) {
                              if (index < state.topicList.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, bottom: 20),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('register_topic'.tr()),
                                          content: Text(
                                              'Confirm topic registration'
                                                  .tr()),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: Text(
                                                'Cancel'.tr(),
                                                style: const TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                String? userNumber = prefs
                                                    .getString(USER_NUMBER);
                                                final urlRegisterTopic = Uri.parse(
                                                    "${HOST}register-topic/${state.topicList[index]['topicId']}/$userNumber");
                                                final response = await http
                                                    .post(urlRegisterTopic,
                                                        headers: {
                                                      "Content-Type":
                                                          "application/json"
                                                    });
                                                if (response.statusCode ==
                                                    201) {
                                                  Navigator.of(context)
                                                      .pop(); // Close current dialog
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "Success".tr()),
                                                        content: Text(
                                                            "Register Topic successfully"
                                                                .tr()),
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
                                                }
                                                bloc.add(RegisterTopicEvent());
                                              },
                                              child: Text('Yes'.tr(),
                                                  style: const TextStyle(
                                                      color: Colors.blue)),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    onLongPress: () {
                                      showDialog(
                                          context: context,
                                          builder: ((BuildContext context) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Container(
                                                height: 250,
                                                width: 250,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15, right: 15),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Center(
                                                        child: Text(
                                                          state.topicList[index]
                                                              ['topicName'],
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                          "${"description".tr()} : ${state.topicList[index]['topicDescription'] ?? " "}"),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                          "${"amount".tr()} : ${state.topicList[index]['studentList'] != null ? state.topicList[index]['studentList'].length : 0}")
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }));
                                    },
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
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, bottom: 30),
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
                                          child: SizedBox(
                                            height: 300,
                                            width: 250,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 15, right: 15),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 15,),
                                                  Center(
                                                    child: Text(
                                                      "Create Topic".tr(),
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
                                                  TextField(controller: suggestTopicController ,decoration: InputDecoration(hintText: "Topic Name...", border: InputBorder.none, hintStyle: TextStyle(color: Colors.grey, fontSize: 20)),),
                                                  const SizedBox(height: 10,),
                                                  Text("Description".tr(), style: TextStyle(color: Colors.black, fontSize: 18),),
                                                  TextField(controller: suggestDescriptionController ,decoration: InputDecoration(hintText: "Add description for task",border: InputBorder.none, hintStyle: TextStyle(color: Colors.grey, fontSize: 14),))  ,
                                                  const SizedBox(height: 15,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                        side:
                                                            MaterialStateBorderSide
                                                                .resolveWith(
                                                          (states) {
                                                            return const BorderSide(
                                                                color:
                                                                    Colors.red);
                                                          },
                                                        ),
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10),
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        suggestTopicController.clear();
                                                        suggestDescriptionController.clear();
                                                        Navigator.of(context)
                                                            .pop();
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
                                                          side:
                                                              MaterialStateBorderSide
                                                                  .resolveWith(
                                                            (states) {
                                                              return const BorderSide(
                                                                  color:
                                                                      Colors.blue);
                                                            },
                                                          ),
                                                          shape: MaterialStateProperty
                                                              .all<
                                                                  RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(10),
                                                            ),
                                                          ),
                                                        ),
                                                        onPressed: () async {
                                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                                          String? userNumber = prefs.getString(USER_NUMBER);
                                                          String? projectId = prefs.getString(PROJECT_ID);

                                                          final suggestTopicUrl = Uri.parse("${HOST}suggest/$userNumber/$projectId");
                                                          if(suggestTopicController.text.isNotEmpty) {
                                                            Map<String, String> data = {};
                                                            if(suggestDescriptionController.text.isNotEmpty) {
                                                              data.addAll({"topicName": suggestTopicController.text, "topicDescription": suggestDescriptionController.text});
                                                            } else {
                                                              data.addAll({"topicName": suggestTopicController.text});
                                                            }
                                                            final jsonBody = jsonEncode(data);
                                                            final response = await http.post(suggestTopicUrl, headers: {"Content-Type": "application/json"}, body: jsonBody);
                                                            if(response.statusCode == 201) {
                                                              
                                                              suggestTopicController.clear();
                                                              suggestDescriptionController.clear();
                                                              showDialog(
                                                                context: context,
                                                                builder:
                                                                    (BuildContext context) {
                                                                      return AlertDialog(
                                                                        title: Text(
                                                                            "Success".tr()),
                                                                        content: Text(
                                                                            "Register Topic successfully"
                                                                                .tr()),
                                                                        actions: [
                                                                          ElevatedButton(
                                                                            onPressed: () {
                                                                              Navigator.of(
                                                                                      context)
                                                                                  .pop();
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
                                                            } else {
                                                              showDialog(
                                                                context: context,
                                                                builder:
                                                                    (BuildContext context) {
                                                                      return AlertDialog(
                                                                        title: Text(
                                                                            "Failed".tr()),
                                                                        content: Text(
                                                                            "Please try again"
                                                                                .tr()),
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
                                                            }
                                                          }
                                                          
                                                        },
                                                        child: Text(
                                                          "Create".tr(),
                                                          style: const TextStyle(
                                                              color: Colors.blue),
                                                        )),
                                                  ],)
                                                ],
                                              ),
                                            ),
                                          ),
                                         ); 
                                        })
                                      );
                                    },
                                    child: Container(
                                      height: 90,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              style: BorderStyle.solid),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Center(
                                          child: Column(children: [
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          width: 30,
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 2),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.add_rounded),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Suggest topic".tr(),
                                          style: TextStyle(fontSize: 20),
                                        )
                                      ])),
                                    ),
                                  ),
                                );
                              }
                            }),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 30, left: 15, right: 15, bottom: 20),
                        child: GestureDetector(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString(TOPIC_ID, state.topic['topicId']);
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return TaskScreen();
                            }));
                          },
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
                        ),
                      );
                    }
                  } else {
                    return Expanded(
                      child: Column(
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
                                      "topic_list".tr(),
                                      style: TextStyle(
                                          fontSize: 18, color: topicText),
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
                                      "student_list".tr(),
                                      style: TextStyle(
                                          fontSize: 18, color: studentText),
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

                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setString(TOPIC_ID, state.topicList[index]['topicId']);
                                        if (studentListOfTopic.statusCode ==
                                            200) {
                                          List<dynamic> studentList =
                                              jsonDecode(utf8.decode(
                                                  studentListOfTopic
                                                      .bodyBytes));
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return StudentListOfTopic(
                                                studentList,
                                                state.topicList[index]);
                                          }));
                                        } else {
                                          return null;
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15, bottom: 20),
                                        child: GestureDetector(
                                          onLongPress: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    ((BuildContext context) {
                                                  return Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: Container(
                                                      height: 250,
                                                      width: 250,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 15,
                                                                right: 15),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            Center(
                                                              child: Text(
                                                                state.topicList[
                                                                        index][
                                                                    'topicName'],
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Text(
                                                                "${"description".tr()} : ${state.topicList[index]['topicDescription'] ?? " "}"),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Text(
                                                                "${"amount"} : ${state.topicList[index]['studentList'] != null ? state.topicList[index]['studentList'].length : 0}")
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }));
                                          },
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
                                                Text(
                                                  state.topicList[index]
                                                      ['topicName'],
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ), 
                                                const Spacer(),
                                                GestureDetector(
                                                  onTap: () async {
                                                    editTopicController.text = state.topicList[index]['topicName'];
                                                    if(state.topicList[index]['topicDescription'] != null) {
                                                      editDescriptionController.text = state.topicList[index]['topicDescription'];
                                                    }
                                                    showDialog(context: context, builder: (context) {
                                                      return Dialog(
                                                        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15),),
                                                        child: Container(
                                                          height: 300,
                                                          width: 250,
                                                          child: Padding(padding: const EdgeInsets.only(left: 15, right: 15),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    const SizedBox(height: 15,),
                                                                    Center(
                                                                      child: Text(
                                                                        "Create Task".tr(),
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
                                                                    Text("topic_name".tr(), style: TextStyle(color: Colors.black, fontSize: 18),),
                                                                    TextField(controller: editTopicController ,decoration: InputDecoration(border: InputBorder.none, hintStyle: TextStyle(color: Colors.grey, fontSize: 20)),),
                                                                    Text("Description".tr(), style: TextStyle(color: Colors.black, fontSize: 18),),
                                                                    TextField(controller: editDescriptionController ,decoration: InputDecoration(hintText: "Add description for topic",border: InputBorder.none, hintStyle: TextStyle(color: Colors.grey, fontSize: 14),))  ,
                                                                    const SizedBox(height: 20,),
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
                                                                          side:
                                                                              MaterialStateBorderSide
                                                                                  .resolveWith(
                                                                            (states) {
                                                                              return const BorderSide(
                                                                                  color:
                                                                                      Colors.red);
                                                                            },
                                                                          ),
                                                                          shape: MaterialStateProperty
                                                                              .all<
                                                                                  RoundedRectangleBorder>(
                                                                            RoundedRectangleBorder(
                                                                              borderRadius:
                                                                                  BorderRadius
                                                                                      .circular(10),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        onPressed: () {
                                                                          editTopicController.clear();
                                                                          editDescriptionController.clear();
                                                                          Navigator.of(context)
                                                                              .pop();
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
                                                                            side:
                                                                                MaterialStateBorderSide
                                                                                    .resolveWith(
                                                                              (states) {
                                                                                return const BorderSide(
                                                                                    color:
                                                                                        Colors.blue);
                                                                              },
                                                                            ),
                                                                            shape: MaterialStateProperty
                                                                                .all<
                                                                                    RoundedRectangleBorder>(
                                                                              RoundedRectangleBorder(
                                                                                borderRadius:
                                                                                    BorderRadius
                                                                                        .circular(10),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          onPressed: () async {
                                                                            String newTopicName;
                                                                            String newDescription;
                                                                            if(editTopicController.text == null) {
                                                                              newTopicName = state.topicList[index]['topicName'];
                                                                            } else {
                                                                              newTopicName = editTopicController.text;
                                                                            }
                                                                            if(editDescriptionController.text == null) {
                                                                              newDescription = "";
                                                                            } else {
                                                                              newDescription = editDescriptionController.text;
                                                                            }
                                                                            editTopicController.clear();
                                                                            editDescriptionController.clear();
                                                                            Navigator.of(context)
                                                                              .pop();
                                                                            bloc.add(EditTopicEvent(index, newTopicName, newDescription));
                                                                          },
                                                                          child: Text(
                                                                            "Ok".tr(),
                                                                            style: const TextStyle(
                                                                                color: Colors.blue),
                                                                          )),
                                                                    ],)
                                                                  ],
                                                            ),
                                                          )
                                                        )
                                                      );
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.edit_document, 
                                                    color: Colors.blue, 
                                                    size: 26,
                                                  )),
                                                const SizedBox(width: 5,),
                                                GestureDetector(
                                                  onTap: () {
                                                    if(state.topicList[index]['studentList'] != null) {
                                                      showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext
                                                                context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "Failed"
                                                                    .tr()),
                                                            content: Text(
                                                                "Student registered this topic"
                                                                    .tr()),
                                                            actions: [
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    "OK"),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                    else {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: Text('delete_topic'.tr()),
                                                          content: Text(
                                                              'Confirm delete topic'
                                                                  .tr()),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.of(context)
                                                                      .pop(false),
                                                              child: Text(
                                                                'Cancel'.tr(),
                                                                style: const TextStyle(
                                                                    color: Colors.red),
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () async {
                                                                Navigator.of(context)
                                                                      .pop(false);
                                                                bloc.add(DeleteTopicEvent(index));
                                                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                                                                  return TopicScreen();
                                                                }));
                                                              },
                                                              child: Text('Yes'.tr(),
                                                                  style: const TextStyle(
                                                                      color: Colors.blue)),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Icon(Icons.delete, color: Colors.red, size: 26,)),
                                                const SizedBox(width: 15,)
                                              ],
                                            ),
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
                                                "assets/images/avatar_default.jpg",
                                                width: 65,
                                                height: 65,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${state.studentList[index]['userName']} - ${state.studentList[index]["userNumber"]}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "topic".tr() + " : " ,
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                            ),
                                                            for(var i = 0; i < state.topicList.length; i++)
                                                              if(state.studentList[index]['topicList'].contains(state.topicList[i]["topicId"]))
                                                                Text(state.topicList[i]["topicName"]),
                                                          ],
                                                        ),
                                                        
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        state.topic != null
                                                            ? (state.topic[
                                                                "topicName"])
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
                      ),
                    );
                  }
                },
              )
            ]);
          }),
    );
  }
}
