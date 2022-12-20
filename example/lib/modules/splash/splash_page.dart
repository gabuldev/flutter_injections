import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';

import 'splash_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = FlutterInjections.get<SplashController>();
    controller
        .syncData()
        .then((value) => Navigator.pushReplacementNamed(context, "/home"));

    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
