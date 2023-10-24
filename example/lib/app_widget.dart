import 'package:flutter/material.dart';

import 'modules/home/home_module.dart';
import 'modules/home/widgets/home_alert_dialog/home_alert_dialog.dart';
import 'modules/splash/splash_module.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Offline First',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: "/splash",
      routes: {
        "/splash": (context) => const SplashModule(),
        "/home": (context) => const HomeModule(),
        "/alert": (context) => const HomeAlertWidget()
      },
    );
  }
}
