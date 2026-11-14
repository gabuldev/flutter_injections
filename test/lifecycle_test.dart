import 'package:flutter/widgets.dart';
import 'package:flutter_injections/flutter_injections.dart';
import 'package:flutter_injections/src/exception.dart';
import 'package:flutter_test/flutter_test.dart';

class Counter {
  static int created = 0;
  Counter() {
    created++;
  }
}

class Parent {}

/// A module whose parent passes a value that changes, so it is rebuilt.
class CounterModule extends FlutterModule {
  const CounterModule({super.key, required this.label});

  final String label;

  @override
  List<Inject<Object>> get injections => [Inject<Counter>((_) => Counter())];

  @override
  Widget get child => Builder(builder: (_) {
        FlutterInjections.get<Counter>();
        return Text(label, textDirection: TextDirection.ltr);
      });
}

void main() {
  setUp(() => Counter.created = 0);

  group('module lifecycle', () {
    testWidgets('rebuilding a module keeps the same instances', (tester) async {
      await tester.pumpWidget(const CounterModule(label: 'a'));
      final first = FlutterInjections.get<Counter>();

      await tester.pumpWidget(const CounterModule(label: 'b'));
      await tester.pumpWidget(const CounterModule(label: 'c'));

      expect(Counter.created, 1, reason: 'one lazySingleton for the whole life of the module');
      expect(identical(FlutterInjections.get<Counter>(), first), isTrue);
    });

    testWidgets('after the module leaves the tree its injections stop resolving',
        (tester) async {
      await tester.pumpWidget(const CounterModule(label: 'a'));
      await tester.pumpWidget(const CounterModule(label: 'b'));
      await tester.pumpWidget(const SizedBox());

      expect(() => FlutterInjections.get<Counter>(), throwsA(isA<InjectException>()));
    });

    testWidgets('a nested module sees the parent, and leaving it keeps the parent',
        (tester) async {
      Widget tree({required bool withChild}) => FlutterInjectionsWidget(
            injections: [Inject<Parent>((_) => Parent())],
            builder: (_) => withChild ? const CounterModule(label: 'child') : const SizedBox(),
          );

      await tester.pumpWidget(tree(withChild: true));
      final parent = FlutterInjections.get<Parent>();
      expect(FlutterInjections.get<Counter>(), isA<Counter>());

      await tester.pumpWidget(tree(withChild: false));

      expect(() => FlutterInjections.get<Counter>(), throwsA(isA<InjectException>()));
      expect(identical(FlutterInjections.get<Parent>(), parent), isTrue,
          reason: 'the parent module was only rebuilt, never left');
    });

    testWidgets('hot reload keeps the instances', (tester) async {
      await tester.pumpWidget(const CounterModule(label: 'a'));
      final first = FlutterInjections.get<Counter>();

      // The reassemble waits for a frame, and frames only happen when the test pumps.
      final reassembled = tester.binding.reassembleApplication();
      await tester.pump();
      await reassembled;

      expect(Counter.created, 1);
      expect(identical(FlutterInjections.get<Counter>(), first), isTrue);
    });
  });
}
