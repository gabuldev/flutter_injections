// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';
import 'package:flutter_injections/src/exception.dart';
import 'package:flutter_test/flutter_test.dart';

class TestClass {
  final String name = "name";
}

class TestClassA {
  final TestClass testClass;
  TestClassA({
    required this.testClass,
  });
}

class TestClassB {
  final TestClass testClass;
  TestClassB({
    required this.testClass,
  });
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

    testWidgets('disposeAll() disposes once last instance is disposed',
        (WidgetTester tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      home() => Builder(
            builder: (context) {
              FlutterInjections.get<TestClass>().name;
              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.pushReplacementNamed(context, "/page1");
              });
              return Container();
            },
          );
      page1() => FlutterInjectionsWidget(
            builder: (context) {
              Future.delayed(const Duration(seconds: 3), () {
                FlutterInjections.get<TestClassA>().testClass.name;
                Navigator.pushReplacementNamed(context, "/page2");
              });
              return Container();
            },
            injections: [
              Inject<TestClassA>(
                  (i) => TestClassA(testClass: i.find<TestClass>()))
            ],
          );
      page2() => FlutterInjectionsWidget(
            builder: (_) {
              FlutterInjections.get<TestClassB>().testClass.name;
              return Container();
            },
            injections: [
              Inject<TestClassB>(
                  (i) => TestClassB(testClass: i.find<TestClass>()))
            ],
          );
      await tester.pumpWidget(FlutterInjectionsWidget(
          injections: [
            Inject<TestClass>((_) => TestClass()),
          ],
          builder: (context) {
            return MaterialApp(
              initialRoute: "/home",
              navigatorKey: navigatorKey,
              routes: {
                "/home": (context) => home(),
                "/page1": (context) => page1(),
                "/page2": (context) => page2(),
              },
            );
          }));
      expect(FlutterInjections.get<TestClass>(), isA<TestClass>());
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(FlutterInjections.get<TestClassA>(), isA<TestClassA>());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(FlutterInjections.get<TestClassB>(), isA<TestClassB>());
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
