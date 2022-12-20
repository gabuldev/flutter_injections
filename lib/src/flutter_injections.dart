import 'package:flutter/material.dart';

import 'exception.dart';
import 'inject.dart';
import 'instance.dart';

export 'instance.dart';

class FlutterInjections extends StatefulWidget {
  final List<Inject<Object>> injections;
  final Widget child;

  late final FlutterInstance _current;

  static final List<FlutterInstance> _instances = [];

  FlutterInjections({
    Key? key,
    required this.child,
    required this.injections,
  }) : super(
          key: key,
        ) {
    _current = FlutterInstance(provider: this);
    FlutterInjections._instances.add(_current);
    for (var k = 0; k < injections.length; k++) {
      _current.set(injections[k]);
    }
  }

  static T _find<T>() {
    T? _instance;
    for (var k = _instances.length - 1; k >= 0; k--) {
      final _i = _instances[k];
      _instance ??= _i.get<T>();
      if (_instance != null) {
        break;
      }
    }
    if (_instance == null) {
      throw InjectException(message: "$T DONT EXIST");
    }

    return _instance;
  }

  T find<T>() {
    return FlutterInjections._find<T>();
  }

  void disposeAll() {
    _current.disposeAll();
  }

  static T get<T>() {
    return _find<T>();
  }

  @override
  State<FlutterInjections> createState() => _FlutterInjectionsState();
}

class _FlutterInjectionsState extends State<FlutterInjections> {
  @override
  void dispose() {
    widget.disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
