import 'package:flutter_injections/flutter_injections.dart';
import 'package:flutter_injections/src/exception.dart';
import 'package:flutter_test/flutter_test.dart';

class ClassA {}

class ClassB {
  ClassB(ClassA a);
}

class ClassC {
  ClassC(ClassB b);
}

class ClassD {
  ClassD(ClassC c);
}

class ClassE {
  ClassE(
    ClassD d,
    ClassC c,
    ClassB b,
    ClassA a,
  );
}

void main() {
  group('FlutterInjections', () {
    test('find() returns correct instance', () {
      final instance = FlutterInjections();
      instance.addInjections([
        Inject<ClassA>((_) => ClassA()),
        Inject<ClassB>((_) => ClassB(instance.find<ClassA>())),
        Inject<ClassC>((_) => ClassC(instance.find<ClassB>())),
        Inject<ClassD>((_) => ClassD(instance.find<ClassC>())),
        Inject<ClassE>((_) => ClassE(
              instance.find<ClassD>(),
              instance.find<ClassC>(),
              instance.find<ClassB>(),
              instance.find<ClassA>(),
            )),
      ]);

      expect(instance.find<ClassA>(), isA<ClassA>());
      expect(instance.find<ClassB>(), isA<ClassB>());
      expect(instance.find<ClassC>(), isA<ClassC>());
      expect(instance.find<ClassD>(), isA<ClassD>());
    });

    test('disposeAll() disposes all instances', () {
      final instance = FlutterInjections();
      instance.addInjections([
        Inject<ClassE>((_) => ClassE(
              instance.find<ClassD>(),
              instance.find<ClassC>(),
              instance.find<ClassB>(),
              instance.find<ClassA>(),
            )),
        Inject<ClassB>((_) => ClassB(instance.find<ClassA>())),
        Inject<ClassD>((_) => ClassD(instance.find<ClassC>())),
        Inject<ClassA>((_) => ClassA()),
        Inject<ClassC>((_) => ClassC(instance.find<ClassB>())),
      ]);

      expect(instance.find<ClassA>(), isA<ClassA>());
      expect(instance.find<ClassB>(), isA<ClassB>());
      expect(instance.find<ClassC>(), isA<ClassC>());
      expect(instance.find<ClassD>(), isA<ClassD>());

      try {
        instance.disposeAll();
        instance.find<ClassA>();
      } catch (e) {
        expect(e, isA<InjectException>());
      }
    });
  });
  test('dispose() disposes the correct instance', () {
    final instance = FlutterInjections();
    instance.addInjections([
      Inject<ClassA>((_) => ClassA()),
      Inject<ClassB>((_) => ClassB(instance.find<ClassA>())),
      Inject<ClassC>((_) => ClassC(instance.find<ClassB>())),
      Inject<ClassD>((_) => ClassD(instance.find<ClassC>())),
      Inject<ClassE>((_) => ClassE(
            instance.find<ClassD>(),
            instance.find<ClassC>(),
            instance.find<ClassB>(),
            instance.find<ClassA>(),
          )),
    ]);

    final classA1 = instance.find<ClassA>();
    final classA2 = instance.find<ClassA>();
    expect(classA1, equals(classA2));

    instance.dispose<ClassA>();
    final classA3 = instance.find<ClassA>();
    expect(classA1, isNot(equals(classA3)));
  });

  test('dispose() throws InjectException if instance not found', () {
    final instance = FlutterInjections();
    try {
      instance.dispose<ClassA>();
    } catch (e) {
      expect(e.toString(), equals('NotDisposeException: ClassA DON\'T EXIST'));
      expect(e, isA<NotDisposeException>());
    }
  });
}
