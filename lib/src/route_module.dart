import 'package:flutter/material.dart';

import 'inject.dart';
import 'widget.dart';

/// An abstract class that represents a Flutter module.
///
/// A Flutter module is a collection of dependencies that can be injected into a widget tree.
///
/// To create a Flutter module, extend this class and provide a list of `Inject` objects
/// in the `injections` getter. Also, provide a `child` widget that represents the root
/// of the widget tree that will use the injected dependencies.
///
/// Example:
/// ```dart
/// class MyModule extends FlutterModule {
///   @override
///   List<Inject<Object>> get injections => [
///     Inject<MyDependency>(() => MyDependency()),
///   ];
///
///   @override
///   Widget get child => MyWidget();
/// }
/// ```
///

class RouteFlutter {
  final String path;
  final Widget Function(BuildContext context) builder;
  const RouteFlutter(this.path, this.builder);
}

abstract class RouteFlutterModule extends StatelessWidget {
  /// Returns a list of [Inject] objects that define the dependencies to be
  /// injected into the widget tree.
  List<Inject<Object>> get injections;

  List<RouteFlutter> get routes;

  const RouteFlutterModule({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterInjectionsWidget(
      builder: (_) => Navigator(
        onGenerateRoute: (settings) {
          final indexRoute = routes.indexWhere(
            (route) => route.path == settings.name,
          );
          if (indexRoute == -1) {
            return null;
          }
          return MaterialPageRoute(
            builder: (context) => routes[indexRoute].builder(context),
          );
        },
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          return true;
        },
      ),
      injections: injections,
    );
  }
}
