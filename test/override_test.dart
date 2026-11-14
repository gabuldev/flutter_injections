import 'package:flutter/widgets.dart';
import 'package:flutter_injections/flutter_injections.dart';
import 'package:flutter_test/flutter_test.dart';

abstract class Repository {
  String get name;
}

class RealRepository implements Repository {
  @override
  String get name => 'real';
}

class FakeRepository implements Repository {
  @override
  String get name => 'fake';
}

class Usecase {
  Usecase(this.repository);
  final Repository repository;
}

class Config {
  final String value = 'config';
}

class ScreenModule extends FlutterModule {
  const ScreenModule({super.key});

  @override
  List<Inject<Object>> get injections => [
        Inject<Repository>((_) => RealRepository()),
        Inject<Usecase>((i) => Usecase(i.find<Repository>())),
      ];

  @override
  Widget get child => const SizedBox();
}

void main() {
  tearDown(FlutterInjections.resetOverrides);

  testWidgets('an override wins over what the module registers', (tester) async {
    FlutterInjections.overrideForTesting([Inject<Repository>((_) => FakeRepository())]);

    await tester.pumpWidget(const ScreenModule());

    expect(FlutterInjections.get<Repository>().name, 'fake');
    expect(FlutterInjections.get<Usecase>().repository.name, 'fake',
        reason: "the module's own injections resolve the fake too");
  });

  testWidgets('an override resolves its dependencies from the modules', (tester) async {
    FlutterInjections.overrideForTesting([
      Inject<Repository>((i) => i.find<Config>().value == 'config' ? FakeRepository() : RealRepository()),
    ]);

    await tester.pumpWidget(FlutterInjectionsWidget(
      injections: [Inject<Config>((_) => Config())],
      builder: (_) => const ScreenModule(),
    ));

    expect(FlutterInjections.get<Repository>().name, 'fake');
  });

  testWidgets('after resetOverrides the module registers its own again', (tester) async {
    FlutterInjections.overrideForTesting([Inject<Repository>((_) => FakeRepository())]);
    FlutterInjections.resetOverrides();

    await tester.pumpWidget(const ScreenModule());

    expect(FlutterInjections.get<Repository>().name, 'real');
  });

  testWidgets('a type without override still throws when nothing registers it',
      (tester) async {
    FlutterInjections.overrideForTesting([Inject<Repository>((_) => FakeRepository())]);

    expect(() => FlutterInjections.get<Config>(), throwsA(isA<InjectException>()));
  });
}
