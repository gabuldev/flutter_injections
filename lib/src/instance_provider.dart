import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_instance/src/exception.dart';

import 'inject.dart';
import 'instance.dart';

export 'instance.dart';

class FlutterInstance extends InheritedWidget {
  final List<Inject<Object>> injections;

  static final List<Instance> _instances = [];

  Instance get i => _instances.last;

  FlutterInstance({
    Key? key,
    required Widget child,
    required this.injections,
  }) : super(key: key, child: child) {
    _instances.add(Instance(provider: this));
    for (var k = 0; k < injections.length; k++) {
      i.set(injections[k]);
    }
  }

  T find<T>() {
    return _find<T>();
  }

  static T _find<T>() {
    var _operations = 1;
    var now = DateTime.now();
    T? _instance;
    for (var k = _instances.length - 1; k >= 0; k--) {
      final _i = _instances[k];
      _instance ??= _i.get<T>();
      if (_instance != null) {
        break;
      }
      _operations++;
    }
    if (_instance == null) {
      throw InjectException(message: "$T DONT EXIST");
    }
    var end = DateTime.now();
    log("$T operations -> $_operations Time: ${end.millisecond - now.millisecond}ms");
    return _instance;
  }

  static T get<T>() {
    return _find<T>();
  }

  @override
  bool updateShouldNotify(FlutterInstance oldWidget) {
    return oldWidget.injections != injections;
  }
}
