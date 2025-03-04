import 'package:dio/dio.dart';
import 'package:example/shared/services/custom_dio/custom_dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';

import 'modules/home/home_module.dart';
import 'modules/splash/splash_module.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterApp(
      title: 'Flutter Injections Example',
      initialRoute: '/splash',
      injections: [
        Inject<Dio>((i) => dioInstance),
      ],
      modules: const [
        HomeModule(),
        SplashModule(),
      ],
    );
  }
}
