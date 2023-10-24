import 'package:flutter_injections/flutter_injections.dart';
import 'package:flutter_injections/src/exception.dart';
import 'package:flutter_test/flutter_test.dart';

class TestClass {}

void main() {
  group('FlutterInstance', () {
    late FlutterInstance instance;

    setUp(() {
      instance = FlutterInstance(provider: FlutterInjections());
    });

    test('get() returns null when instance is not set', () {
      final result = instance.get<TestClass>();

      expect(result, isNull);
    });

    test('get() returns instance when instance is set', () {
      final testInstance = TestClass();
      instance.set(Inject<TestClass>((_) => testInstance));

      final result = instance.get<TestClass>();

      expect(result, equals(testInstance));
    });

    test('get() throws InjectException when type is dynamic', () {
      expect(() => instance.get<dynamic>(), throwsA(isA<InjectException>()));
    });

    test('set() adds instance to instances map', () {
      final testInstance = TestClass();
      instance.set(Inject<TestClass>((_) => testInstance));

      final result = instance.instances["TestClass"];

      expect(result, isNotNull);
      expect(result!.get(instance.provider), equals(testInstance));
    });

    test('dispose() removes instance from instances map', () {
      final testInstance = TestClass();
      instance.set(Inject<TestClass>((_) => testInstance));

      instance.dispose<TestClass>();

      final result = instance.instances[TestClass().toString()];

      expect(result, isNull);
    });

    test('disposeAll() removes all instances from instances map', () {
      final testInstance1 = TestClass();
      final testInstance2 = TestClass();
      instance.set(Inject<TestClass>((_) => testInstance1));
      instance.set(Inject<TestClass>((_) => testInstance2));

      instance.disposeAll();

      expect(instance.instances, isEmpty);
    });
  });
}
