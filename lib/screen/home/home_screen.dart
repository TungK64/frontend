import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pHUST/constants/constant.dart';
import 'package:pHUST/screen/account/account_screen.dart';
import 'package:pHUST/screen/components/loading_icon.dart';
import 'package:pHUST/screen/home/bloc/home_bloc.dart';
import 'package:pHUST/screen/notifications/notification_screen.dart';
import 'package:pHUST/screen/setting/setting_screen.dart';
import 'package:pHUST/screen/topic/topic_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  IconData iconArrowDown = Icons.keyboard_arrow_down;
  IconData iconArrowRight = Icons.keyboard_arrow_right;
  bool iconClick = false;
  late HomeBloc bloc;
  ScrollController _controller = new ScrollController();
  final TextEditingController classCodeController = TextEditingController();
  Random random = Random();
  bool homePointer = true;
  Color homeIconColor = Colors.red;
  Color accountIconColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(HomeInitialEvent()),
      child: Builder(
        builder: (context) => _buildViewChild(context),
      ),
    );
  }

  Widget _buildViewChild(BuildContext context) {
    bloc = BlocProvider.of<HomeBloc>(context);
    return Scaffold(
      body: Column(children: [
        Container(
          height: 100,
          color: Color.fromARGB(255, 191, 29, 45),
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/Logo_HUST.png",
                  width: 60,
                  height: 60,
                ),
                homePointer
                    ? Text(
                        "pHUST",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        "account_info".tr(),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return NotificationScreen();
                          }));
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                        Positioned(
                          right: -4,
                          top: -8,
                          child: BlocBuilder<HomeBloc, HomeState>(
                            bloc: bloc,
                            builder: (context, state) {
                              return Text(state.unread, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),);
                            },
                        ))
                        ]
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SettingScreen();
                            },
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<HomeBloc, HomeState>(
            bloc: bloc,
            builder: (context, state) {
              if (state.status == HomeStatus.loading) {
                return const Center(
                  child: LoadingIcon(),
                );
              }
              return homePointer
                ? (state.items.isEmpty || state.lecName.isEmpty)  
                ? Center(
                  child: Text(
                    "not_register_yet".tr(),
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ) 
                : Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              iconClick = !iconClick;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0, left: 10),
                            child: Row(
                              children: [
                                Icon(
                                    iconClick ? iconArrowRight : iconArrowDown),
                                Text(
                                  "Class".tr(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.items.length + 1,
                            controller: _controller,
                            itemBuilder: (context, index) {
                              if (!iconClick) {
                                if(index < state.items.length) {
                                  
                                  return GestureDetector(
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString(PROJECT_ID,
                                        state.items[index]['projectId']);
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return TopicScreen();
                                    }));
                                  },
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        child: Container(
                                          height: 100,
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
                                                "assets/images/logo${index + 1}.jpg",
                                                width: 65,
                                                height: 65,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    '${state.items[index]['projectName']} - ${state.items[index]['classCode']}',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    state.lecName[index],
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, bottom: 30, top: 15),
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
                                            height: 400,
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
                                                      "Add Class".tr(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10,),
                                                  Center(child: Image.asset(
                                                    "assets/images/add_class.jpg",
                                                    height: 150,
                                                    width: 200,
                                                  ),),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Center(child: Text("Add_class_text".tr(), style: TextStyle(fontWeight: FontWeight.bold),)),
                                                  const SizedBox(height: 20,),
                                                  TextField(controller: classCodeController,decoration: InputDecoration(hintText: "Class Code", border: InputBorder.none, hintStyle: TextStyle(color: Colors.grey, fontSize: 20)),),
                                                  const SizedBox(height: 20,),
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
                                                        classCodeController.clear();
                                                        Navigator.of(context).pop();
                                                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                                                            return HomeScreen();
                                                          }));
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
                                                          String classCode = classCodeController.text;
                                                          if(classCode.isNotEmpty) {
                                                            bloc.add(AddClassEvent(classCode, context));
                                                            classCodeController.clear();
                                                            
                                                          }
                                                        },
                                                        child: Text(
                                                          "Add".tr(),
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
                                          "Add Class".tr(),
                                          style: TextStyle(fontSize: 20),
                                        )
                                      ])),
                                    ),
                                  )
                                );

                              }
                              }
                            },
                          ),
                          
                        ),
                      ],
                    )
                  : AccountScreen();
            },
          ),
        ),
        Container(
          height: 80,
          decoration: BoxDecoration(
              border: Border(top: BorderSide(width: 1, color: Colors.grey))),
          child: Padding(
            padding: const EdgeInsets.only(left: 90, right: 90),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      homePointer = true;
                      homeIconColor = Colors.red;
                      accountIconColor = Colors.black;
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.home_outlined,
                        size: 50,
                        color: homeIconColor,
                      ),
                      Text(
                        "Home".tr(),
                        style: TextStyle(fontSize: 14, color: homeIconColor),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      homePointer = false;
                      accountIconColor = Colors.red;
                      homeIconColor = Colors.black;
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.people_alt_outlined,
                        size: 50,
                        color: accountIconColor,
                      ),
                      Text(
                        "Account".tr(),
                        style: TextStyle(fontSize: 14, color: accountIconColor),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
