import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';

import 'modules/home/home_module.dart';
import 'modules/home/widgets/home_alert_dialog/home_alert_dialog.dart';
import 'modules/splash/splash_module.dart';
import 'shared/services/custom_dio/custom_dio.dart';

class AppModule extends RouteFlutterModule {
  const AppModule({Key? key}) : super(key: key);

  @override
  List<Inject<Object>> get injections => [
        Inject<Dio>((i) => CustomDio()),
      ];

  @override
  List<RouteFlutter> get routes => [
        RouteFlutter("/splash", (context) => const SplashModule()),
        RouteFlutter("/home", (context) => const HomeModule()),
        RouteFlutter("/alert", (context) => const HomeAlertWidget())
      ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Offline First',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: "/splash",
      home: super.build(context),
    );
  }
}
