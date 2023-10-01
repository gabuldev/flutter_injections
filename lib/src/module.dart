import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';

abstract class FlutterModule extends StatelessWidget {
  List<Inject<Object>> get injections;
  Widget get child;
  const FlutterModule({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterInjections(child: child, injections: injections);
  }
}
