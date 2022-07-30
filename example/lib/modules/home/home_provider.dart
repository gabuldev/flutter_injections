import 'package:dio/dio.dart';
import 'package:example/modules/home/widgets/home_alert_dialog/home_alert_dialog_controller.dart';
import 'package:flutter/material.dart';

import 'package:flutter_instance/flutter_instance.dart';
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
          Inject<HomeRepository>((i) => HomeRepository(client: i.find<Dio>())),
          Inject<HomeController>(
              (i) => HomeController(repository: i.find<HomeRepository>())),
        ],
        child: const HomePage());
  }
}
