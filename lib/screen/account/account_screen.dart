import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pHUST/constants/constant.dart';
import 'package:pHUST/screen/account/bloc/account_bloc.dart';
import 'package:pHUST/screen/components/loading_icon.dart';
import 'package:pHUST/screen/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late AccountBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountBloc()..add(AccountInitialEvent()),
      child: Builder(
        builder: (context) => _buildViewChild(context),
      ),
    );
  }

  Widget _buildViewChild(BuildContext context) {
    bloc = BlocProvider.of<AccountBloc>(context);
    return BlocBuilder<AccountBloc, AccountState>(
      bloc: bloc,
      builder: (context, state) {
        if (state.status == AccountStatus.loading) {
          return const Center(
            child: LoadingIcon(),
          );
        }
        return Column(
          children: [
            Container(
              height: 140,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/account_image.jpg"),
                      fit: BoxFit.fitWidth),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black45,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0.0, 3))
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white70),
                  child: Row(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8, left: 8, bottom: 8),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Image.asset(
                                "assets/images/avatar_default.jpg")),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (state.items.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.items['userName'],
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${"phone_number".tr()}: ${state.items['phoneNumber']}",
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "email: ${state.items['email']}",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: const Color.fromARGB(255, 240, 249, 252),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        color: Colors.white),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 0.6,
                                              color: Colors.black))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${"code".tr()}: "),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if (state.items.isNotEmpty)
                                        Text(
                                          state.items['userNumber'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 0.6,
                                              color: Colors.black))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${"date_of_birth".tr()}: "),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if (state.items.isNotEmpty)
                                        Text(
                                          _formatDate(state.items['dateOfBirth']),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 0.6,
                                              color: Colors.black))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${"role".tr()}: "),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if (state.items.isNotEmpty)
                                        Text(
                                          state.items['role'].toString().tr(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 0.6,
                                              color: Colors.black))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${"phone_number".tr()}: "),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if (state.items.isNotEmpty)
                                        Text(
                                          state.items['phoneNumber'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 0.6, color: Colors.black),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${"university".tr()}: "),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "HUST".tr(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ))
                            ],
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: GestureDetector(
                              onTap: () async {
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(USER_NUMBER, "");
                                prefs.setString(PROJECT_ID, "");
                                prefs.setString(ROLE, "");
                                prefs.setString(TOPIC_ID, "");
                                prefs.setString(STUDENT_NUMBER, "");
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return LoginScreen();
                                }));
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        width: 2, color: Colors.red)),
                                child: Center(
                                    child: Text(
                                  "log_out".tr(),
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

String _formatDate(String date) {
    // Định dạng đầu vào
    DateTime parsedDate = DateTime.parse(date);
    // Định dạng đầu ra
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(parsedDate);
  }
