import 'package:flutter/widgets.dart';

import '../flutter_injections.dart';

/// A widget that provides dependency injection to its child widget tree.
///
/// The [injections] are registered once, when the widget enters the tree, and
/// stay the same for as long as it is there: rebuilding it (a parent that
/// rebuilds, a hot reload) keeps the instances already created and ignores the
/// list of the new widget. When it leaves the tree, its injections are removed
/// and stop resolving.
class FlutterInjectionsWidget extends StatefulWidget {
  final WidgetBuilder builder;
  final List<Inject<Object>> injections;

  const FlutterInjectionsWidget({
    Key? key,
    required this.builder,
    required this.injections,
  }) : super(key: key);

  @override
  State<FlutterInjectionsWidget> createState() =>
      _FlutterInjectionsWidgetState();
}

class _FlutterInjectionsWidgetState extends State<FlutterInjectionsWidget> {
  // Registered here, not in the widget's constructor: a widget is created on
  // every rebuild, and each one used to push a new level that `dispose` never
  // removed.
  late final FlutterInjections _instance = FlutterInjections()
    ..addInjections(widget.injections);

  @override
  void initState() {
    super.initState();
    _instance;
  }

  @override
  void dispose() {
    _instance.disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
