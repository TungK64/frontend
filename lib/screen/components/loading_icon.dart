import 'package:flutter/material.dart';

class LoadingIcon extends StatelessWidget {
  final String text;

  const LoadingIcon({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/loading_fl3.gif"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 25,
                  decoration: TextDecoration.none),
            ),
          ),
        ],
      ),
    );
  }
}