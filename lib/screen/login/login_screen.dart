import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                decoration: const InputDecoration(
                    labelText: "Email", hintText: "Nhập địa chỉ email"),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                    labelText: "Password", hintText: "Nhập mật khẩu"),
                obscureText: true,
              ),
            ),
            const SizedBox(
              height: 30,
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

  void _login() {
    String email = emailController.text;
    String password = passwordController.text;
  }
}
