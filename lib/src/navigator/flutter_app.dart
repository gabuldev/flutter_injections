import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';

class FlutterApp extends StatelessWidget {
  final List<FlutterModule> modules;
  final List<Inject<Object>> injections;
  final String initialRoute;
  final ThemeData? theme;
  final String title;
  final Widget? home;

  const FlutterApp({
    super.key,
    required this.modules,
    required this.injections,
    this.initialRoute = '/',
    this.theme,
    this.title = '',
    this.home,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterInjectionsWidget(
      injections: injections,
      builder: (context) => MaterialApp(
        title: title,
        theme: theme,
        home: home,
        initialRoute: home == null ? initialRoute : null,
        onGenerateRoute: (settings) {
          for (final module in modules) {
            if (module is FlutterNavigatorModule) {
              final route = module.onGenerateRoute(settings);
              if (route != null) return route;
            }
          }
          return null;
        },
      ),
    );
  }
}
