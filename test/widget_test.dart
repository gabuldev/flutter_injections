import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';
import 'package:flutter_injections/src/exception.dart';
import 'package:flutter_test/flutter_test.dart';

class TestClass {
  final String name = "name";
}

void main() {
  group('FlutterInjectionsWidget', () {
    testWidgets('injected object is available in child widget tree',
        (WidgetTester tester) async {
      await tester.pumpWidget(FlutterInjectionsWidget(
        builder: (context) => MaterialApp(
          home: Center(child: Text(FlutterInjections.get<TestClass>().name)),
        ),
        injections: [Inject<TestClass>((_) => TestClass())],
      ));

      expect(FlutterInjections.get<TestClass>(), isA<TestClass>());
    });

    testWidgets('injected object is available in child widget tree',
        (WidgetTester tester) async {
      await tester.pumpWidget(FlutterInjectionsWidget(
        builder: (_) => Container(),
        injections: [Inject<TestClass>((_) => TestClass())],
      ));

      expect(FlutterInjections.get<TestClass>(), isA<TestClass>());
    });

    testWidgets('disposeAll() disposes all instances',
        (WidgetTester tester) async {
      await tester.pumpWidget(FlutterInjectionsWidget(
        builder: (_) => Container(),
        injections: const [],
      ));

      expect(() => FlutterInjections.get<TestClass>(),
          throwsA(isA<InjectException>()));
    });
  });
}
