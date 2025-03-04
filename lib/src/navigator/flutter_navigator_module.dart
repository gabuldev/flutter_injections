import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';

abstract class FlutterNavigatorModule extends FlutterModule {
  const FlutterNavigatorModule({super.key});

  Map<String, Widget Function(BuildContext context, Object? args)> get routes;

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final builder = routes[settings.name];
    if (builder == null) return null;

    return MaterialPageRoute(
      builder: (context) => FlutterInjectionsWidget(
        builder: (_) => builder(context, settings.arguments),
        injections: injections,
      ),
      settings: settings,
    );
  }

  @override
  Widget get child =>
      const SizedBox.shrink(); // Empty widget since we use routes
}
