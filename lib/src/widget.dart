import 'package:flutter/material.dart';

import '../flutter_injections.dart';

/// A widget that provides dependency injection to its child widget tree.
class FlutterInjectionsWidget extends StatefulWidget {
  final WidgetBuilder builder;
  final List<Inject<Object>> injections;

  static final FlutterInjections instance = FlutterInjections();

  FlutterInjectionsWidget({
    Key? key,
    required this.builder,
    required this.injections,
  }) : super(key: key) {
    instance.addInjections(injections);
  }

  @override
  State<FlutterInjectionsWidget> createState() =>
      _FlutterInjectionsWidgetState();
}

class _FlutterInjectionsWidgetState extends State<FlutterInjectionsWidget> {
  @override
  void dispose() {
    FlutterInjectionsWidget.instance.disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
