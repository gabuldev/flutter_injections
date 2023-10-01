import 'package:example/modules/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';

import 'splash_controller.dart';

class SplashModule extends FlutterModule {
  const SplashModule({Key? key}) : super(key: key);

  @override
  Widget get child => const SplashPage();

  @override
  List<Inject<Object>> get injections =>
      [Inject<SplashController>.singleton((i) => SplashController())];
}
