import '../flutter_injections.dart';
import 'bind.dart';

enum InjectType { factory, singleton, lazySingleton }

/// A class that represents an injection of a dependency.
///
/// An injection can be of three types: factory, singleton, and lazySingleton.
/// The type of injection is determined by the [type] parameter passed to the constructor.
///
/// The [Inject] class has three factory constructors: [Inject.factory], [Inject.singleton], and [Inject.lazySingleton].
/// Each constructor creates an instance of [Inject] with the corresponding [InjectType].
///
/// The [get] method returns the value of the injected dependency.
/// If the injection is of type factory, the value is always recomputed.
/// If the injection is of type singleton or lazySingleton, the value is computed only once and cached for future use.
///
/// The injected dependency is computed by calling the [_call] function passed to the constructor.
/// The [_call] function takes a [FlutterInjections] instance as a parameter and returns an instance of type [T].
///
/// Example usage:
///
/// ```dart
/// final myInject = Inject.singleton((i) => MyDependency());
/// final myDependency = myInject.get(myFlutterInjections);
/// ```

class Inject<T> {
  late final Bind<T> _call;
  final InjectType type;
  T? value;
  Inject(this._call, {this.type = InjectType.lazySingleton});

  ///Factory to create a singleton bind
  factory Inject.singleton(Bind<T> _call) =>
      Inject(_call, type: InjectType.singleton);
  factory Inject.factory(Bind<T> _call) =>
      Inject(_call, type: InjectType.factory);
  factory Inject.lazySingleton(Bind<T> _call) =>
      Inject(_call, type: InjectType.lazySingleton);

  T get(FlutterInjections i) {
    if (type == InjectType.factory) {
      value = null;
    }
    value ??= _call(i);
    return value!;
  }

  void dispose() {
    value = null;
  }
}
