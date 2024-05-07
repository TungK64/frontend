import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/constants/constant.dart';
import 'package:frontend/screen/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String alertString = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login_gate.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(child: loginBox())
      ],
    ));
  }

  Widget loginBox() {
    return Container(
      height: 300,
      width: 300,
      decoration: BoxDecoration(
          color: Colors.white70, borderRadius: BorderRadius.circular(20)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Center(
                child: Text(
              "pHUST",
              style: TextStyle(color: Colors.red, fontSize: 24),
            )),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: TextField(
                controller: emailController,
                onChanged: (value) {
                  setState(() {
                    alertString = "";
                  });
                },
                decoration: const InputDecoration(
                    labelText: "Email", hintText: "abc@sis.hust.edu.vn"),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: TextField(
                controller: passwordController,
                onChanged: (value) {
                  setState(() {
                    alertString = "";
                  });
                },
                decoration: const InputDecoration(
                    labelText: "Password", hintText: "Nhập mật khẩu"),
                obscureText: true,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              alertString,
              style: TextStyle(color: Colors.red, fontSize: 17),
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: _login,
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(
                  const Size(250, 40),
                ),
              ),
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.black),
              ),
            )
          ]),
    );
  }

  void _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = emailController.text;
    String password = passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        alertString = "Please fill in all information";
      });
    } else {
      final url = Uri.parse("${HOST}login");
      Map<String, dynamic> jsonData = {'email': email, 'password': password};
      String jsonBody = jsonEncode(jsonData);

      final response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: jsonBody);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        prefs.setString(ROLE, jsonResponse['role']);
        prefs.setString(USER_NUMBER, jsonResponse['userNumber']);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      } else if (response.statusCode == 400) {
        setState(() {
          alertString = response.body;
        });
      }
    }
  }
}
