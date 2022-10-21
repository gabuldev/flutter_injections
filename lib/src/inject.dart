import '../flutter_instance.dart';
import 'bind.dart';

enum InjectType { factory, singleton, lazySingleton }

class Inject<T> {
  late final Bind<T> _call;
  final InjectType type;
  T? value;
  Inject(this._call, {this.type = InjectType.lazySingleton});

  factory Inject.singleton(Bind<T> _call) =>
      Inject(_call, type: InjectType.singleton);
  factory Inject.factory(Bind<T> _call) =>
      Inject(_call, type: InjectType.factory);
  factory Inject.lazySingleton(Bind<T> _call) =>
      Inject(_call, type: InjectType.lazySingleton);

  T get(FlutterInstance i) {
    if (type == InjectType.factory) {
      value = null;
    }
    value ??= _call(i);
    return value!;
  }
}
