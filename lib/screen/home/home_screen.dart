import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {}

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
            child: Column(
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
                    Icon(iconClick ? iconArrowRight : iconArrowDown),
                    const Text(
                      "Class",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            // ListView.builder(itemBuilder: itemBuilder)
          ],
        ))
      ]),
    );
  }
}
