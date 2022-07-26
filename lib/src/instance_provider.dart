import 'package:flutter/material.dart';
import 'package:instance/src/inject.dart';

import 'instance.dart';

export 'instance.dart';

class InstanceProvider extends InheritedWidget {
  final Instance i = Instance();
  final BuildContext context;
  final List<Inject<Object>> injections;

  InstanceProvider({
    Key? key,
    required Widget child,
    required this.context,
    required this.injections,
  }) : super(key: key, child: child) {
    for (var k = 0; k < injections.length; k++) {
      i.set(injections[k]);
    }
  }

  static InstanceProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InstanceProvider>();
  }

  T find<T>() {
    return _find(i: i, context: context);
  }

  static T _find<T>({required Instance i, BuildContext? context}) {
    try {
      final instance = i.get<T>();
      return instance;
    } catch (e) {
      final d = of(context!)!;
      final instance = d.i.get<T>();
      return instance;
    }
  }

  static T get<T>(BuildContext context) {
    final d = of(context)!;
    return _find(i: d.i, context: context);
  }

  @override
  bool updateShouldNotify(InstanceProvider oldWidget) {
    return false;
  }
}
