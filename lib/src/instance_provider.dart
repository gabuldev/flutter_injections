import 'package:flutter/material.dart';
import 'package:flutter_instance/src/exception.dart';

import 'inject.dart';
import 'instance.dart';

export 'instance.dart';

class InstanceProvider extends InheritedWidget {
  final BuildContext context;
  final List<Inject<Object>> injections;

  static final List<Instance> _instances = [];

  Instance get i => _instances.last;

  InstanceProvider({
    Key? key,
    required Widget child,
    required this.context,
    required this.injections,
  }) : super(key: key, child: child) {
    _instances.add(Instance(provider: this));
    for (var k = 0; k < injections.length; k++) {
      i.set(injections[k]);
    }
  }

  static InstanceProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InstanceProvider>();
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
    print(
        "$T operations -> $_operations Time: ${end.millisecond - now.millisecond}ms");
    return _instance;
  }

  static T get<T>() {
    return _find<T>();
  }

  @override
  bool updateShouldNotify(InstanceProvider oldWidget) {
    return oldWidget.injections != injections;
  }
}
