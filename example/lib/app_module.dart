import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_injections/flutter_injections.dart';

import 'app_widget.dart';
import 'shared/services/custom_dio/custom_dio.dart';

class AppModule extends FlutterModule {
  const AppModule({Key? key}) : super(key: key);

  @override
  Widget get child => const AppWidget();

  @override
  List<Inject<Object>> get injections => [
        Inject<Dio>((i) => CustomDio()),
      ];
}
