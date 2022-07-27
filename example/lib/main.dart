import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instance/flutter_instance.dart';

import 'modules/home/home_provider.dart';
import 'modules/splash/splash_page.dart';
import 'shared/services/custom_dio/custom_dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InstanceProvider(
        context: context,
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
            "/splash": (context) => const SplashPage(),
            "/home": (context) => const HomeProvider()
          },
        ));
  }
}
