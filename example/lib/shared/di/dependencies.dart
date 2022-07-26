import 'package:flutter/material.dart';

class Dependencie<T> {
  final T Function(Dependencies i) call;
  T? instance;
  Dependencie(this.call);

  T get(Dependencies i) {
    instance ??= call(i);
    return instance!;
  }
}

class Dependencies extends InheritedWidget {
  final List<Dependencie> dependencies;

  const Dependencies({
    Key? key,
    required this.dependencies,
    required Widget child,
  }) : super(key: key, child: child);

  static Dependencies? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Dependencies>();
  }

  T find<T>(BuildContext context) {
    return _find(dependencies: dependencies, d: this, context: context);
  }

  static T _find<T>(
      {required List<Dependencie> dependencies,
      Dependencies? d,
      BuildContext? context}) {
    try {
      final instance = dependencies.whereType<Dependencie<T>>().first;
      return instance.get(d!);
    } catch (e) {
      final d = of(context!)!;
      final instance = d.dependencies.whereType<Dependencie<T>>().first;
      return instance.get(d);
    }
  }

  static T get<T>(BuildContext context) {
    final i = of(context)!;
    return _find(dependencies: i.dependencies, context: context, d: i);
  }

  @override
  bool updateShouldNotify(Dependencies oldWidget) {
    return false;
  }
}
