import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';

import 'home_controller.dart';
import 'home_page.dart';
import 'home_repository.dart';
import 'widgets/home_alert_dialog/home_alert_dialog.dart';

class HomeModule extends FlutterNavigatorModule {
  const HomeModule({Key? key}) : super(key: key);

  @override
  List<Inject<Object>> get injections => [
        Inject<HomeRepository>((i) => HomeRepository(client: i.find<Dio>())),
        Inject<HomeController>(
          (i) => HomeController(repository: i.find<HomeRepository>()),
        ),
      ];

  @override
  Map<String, Widget Function(BuildContext context, Object? args)> get routes =>
      {
        '/home': (context, _) => const HomePage(),
        '/home/alert': (context, args) => const HomeAlertWidget(),
      };
}
