import 'package:example/modules/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';

import 'splash_controller.dart';

class SplashInjections extends StatelessWidget {
  const SplashInjections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterInjections(
      child: const SplashPage(),
      injections: [
        Inject<SplashController>.singleton((i) => SplashController())
      ],
    );
  }
}
