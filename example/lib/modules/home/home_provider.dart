import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:instance/instance.dart';

import 'home_controller.dart';
import 'home_page.dart';
import 'home_repository.dart';

class HomeProvider extends StatelessWidget {
  const HomeProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InstanceProvider(
        context: context,
        injections: [
          Inject<HomeRepository>((i) => HomeRepository(client: i.get<Dio>())),
          Inject<HomeController>(
              (i) => HomeController(repository: i.get<HomeRepository>()))
        ],
        child: const HomePage());
  }
}
