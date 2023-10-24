import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_injections/flutter_injections.dart';

import 'shared/services/custom_dio/custom_dio.dart';

class AppModule extends FlutterModule {
  const AppModule({Key? key}) : super(key: key);

  @override
  Widget get child => throw UnimplementedError();

  @override
  List<Inject<Object>> get injections => [
        Inject<Dio>((i) => CustomDio()),
      ];
}
