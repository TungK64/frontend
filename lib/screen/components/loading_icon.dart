import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingIcon extends StatelessWidget {
  const LoadingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Lottie.asset("assets/animation/Loading.json"),
      ),
    );
  }
}
