import 'package:dio/dio.dart';
import 'package:example/modules/home/widgets/home_alert_dialog/home_alert_dialog.dart';
import 'package:example/modules/splash/splash_injections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';

import 'modules/home/home_injections.dart';
import 'shared/services/custom_dio/custom_dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterInjections(
        injections: [
          Inject<Dio>((i) => CustomDio()),
        ],
        child: MaterialApp(
          title: 'Flutter Offline First',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          initialRoute: "/splash",
          routes: {
            "/splash": (context) => const SplashInjections(),
            "/home": (context) => const HomeInjections(),
            "/alert": (context) => const HomeAlertWidget()
          },
        ));
  }
}
