import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screen/components/loading_icon.dart';
import 'package:frontend/screen/home/bloc/home_bloc.dart';

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
  Random random = Random();
  bool homePointer = true;
  Color homeIconColor = Colors.red;
  Color accountIconColor = Colors.black;

  @override
  Widget build(Object context) {
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
                const Text(
                  "pHUST",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.settings,
                      color: Colors.white,
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
                  child: LoadingIcon(
                    text: '',
                  ),
                );
              }
              if (state.items.isEmpty || state.lecName.isEmpty) {
                return const Center(
                  child: Text(
                    "Bạn chưa đăng ký vào lớp nào hoặc hệ thống chưa cập nhật, vui lòng quay lại sau",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return homePointer
                  ? Column(
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
                                const Text(
                                  "Class",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.items.length,
                            controller: _controller,
                            itemBuilder: (context, index) {
                              if (!iconClick) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
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
                                        height: 10,
                                      )
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  : Container();
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
                        "Home",
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
                        "Account",
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
