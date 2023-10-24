import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';

import 'home_controller.dart';
import 'home_page.dart';
import 'home_repository.dart';

class HomeModule extends FlutterModule {
  const HomeModule({Key? key}) : super(key: key);

  @override
  Widget get child => const HomePage();

  @override
  List<Inject<Object>> get injections => [
        Inject<HomeRepository>((i) => HomeRepository(client: i.find<Dio>())),
        Inject<HomeController>(
            (i) => HomeController(repository: i.find<HomeRepository>())),
      ];
}
