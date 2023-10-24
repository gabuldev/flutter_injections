import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';
import 'package:flutter_test/flutter_test.dart';

class TestClass {
  final String name = "name";
}

class TestModule extends FlutterModule {
  const TestModule({Key? key}) : super(key: key);

  @override
  List<Inject<Object>> get injections =>
      [Inject<TestClass>((_) => TestClass())];

  @override
  Widget get child => Center(
        child: Text(FlutterInjections.get<TestClass>().name),
      );
}

void main() {
  group('FlutterModule', () {
    testWidgets('injected object is available in child widget tree',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: TestModule(
          key: Key("value"),
        ),
      ));

      expect(FlutterInjections.get<TestClass>(), isA<TestClass>());
    });
  });
  testWidgets('FlutterModule has a non-null key', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: TestModule(key: ValueKey('test')),
    ));

    final moduleFinder = find.byType(TestModule);
    expect(moduleFinder, findsOneWidget);

    final module = tester.widget(moduleFinder) as TestModule;
    expect(module.key, isNotNull);
  });
}
