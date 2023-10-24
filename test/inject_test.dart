import 'package:flutter_injections/flutter_injections.dart';
import 'package:flutter_test/flutter_test.dart';

class TestClass {}

void main() {
  final provider = FlutterInjections();
  group('Inject', () {
    test('get() returns the same instance for singleton', () {
      final inject = Inject.singleton((_) => TestClass());
      final instance1 = inject.get(provider);
      final instance2 = inject.get(provider);
      expect(instance1, equals(instance2));
    });

    test('get() returns a new instance for factory', () {
      final inject = Inject.factory((_) => TestClass());
      final instance1 = inject.get(provider);
      final instance2 = inject.get(provider);
      expect(instance1, isNot(equals(instance2)));
    });

    test('get() returns the same instance until disposed for lazy singleton',
        () {
      final inject = Inject.lazySingleton((_) => TestClass());
      final instance1 = inject.get(provider);
      final instance2 = inject.get(provider);
      expect(instance1, equals(instance2));
      inject.dispose();
      final instance3 = inject.get(provider);
      expect(instance1, isNot(equals(instance3)));
    });
  });
}
