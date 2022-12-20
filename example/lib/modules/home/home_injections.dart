import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';

import 'home_controller.dart';
import 'home_page.dart';
import 'home_repository.dart';

class HomeInjections extends StatelessWidget {
  const HomeInjections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterInjections(injections: [
      Inject<HomeRepository>((i) => HomeRepository(client: i.find<Dio>())),
      Inject<HomeController>(
          (i) => HomeController(repository: i.find<HomeRepository>())),
    ], child: const HomePage());
  }
}
