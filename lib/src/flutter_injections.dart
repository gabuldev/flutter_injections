import 'exception.dart';
import 'inject.dart';
import 'instance.dart';

export 'instance.dart';

/// A class that manages a list of injections and provides a way to retrieve them.
///
/// The injections are added to a [FlutterInstance] object, which is then added to a list of instances.
/// The [find] method retrieves the last added instance and returns the injection of the specified type.
/// The [disposeAll] method disposes all injections in the current instance.
/// The [get] method is a static method that retrieves the injection of the specified type from the last added instance.
class FlutterInjections {
  FlutterInstance? _current;

  static final List<FlutterInstance> _instances = [];

  FlutterInjections() {
    _current = FlutterInstance(provider: this);
    FlutterInjections._instances.add(_current!);
  }

  /// Adds a list of injections to the injection container.
  void addInjections(List<Inject<Object>> injections) {
    for (var k = 0; k < injections.length; k++) {
      final inject = injections[k];
      _current!.set(inject);
    }
  }

  /// Finds and returns an instance of type [T] from the list of registered instances.
  /// Throws an [InjectException] if no instance of type [T] is found.
  static T _find<T>() {
    T? _instance;
    for (var k = _instances.length - 1; k >= 0; k--) {
      final _i = _instances[k];
      _instance ??= _i.get<T>();
      if (_instance != null) {
        break;
      }
    }
    if (_instance == null) {
      throw InjectException(message: "$T DON'T EXIST");
    }

    return _instance;
  }

  /// Retrieves the injection of the specified type from the last added instance.
  T find<T>() {
    return FlutterInjections._find<T>();
  }

  /// Disposes all injections in the current instance.
  void disposeAll() {
    _instances.remove(_current);
    _current?.disposeAll();
  }

  /// Disposes the instance of type T that was last registered with the [register] method.
  ///
  /// This method searches for the last registered instance of type T and disposes it.
  /// If no instance of type T was registered, this method does nothing.
  ///
  /// Example usage:
  /// ```
  /// FlutterInjections.dispose<MyService>();
  /// ```
  void dispose<T>() => _dispose<T>();

  /// Disposes the instance of type T that was last registered with the [register] method.

  static void _dispose<T>() {
    T? _instance;
    for (var k = _instances.length - 1; k >= 0; k--) {
      final _i = _instances[k];
      _instance ??= _i.get<T>();
      if (_instance != null) {
        _i.dispose<T>();
        return;
      }
    }
    throw NotDisposeException(message: "$T DON'T EXIST");
  }

  /// Retrieves the injection of the specified type from the last added instance.
  static T get<T>() {
    return _find<T>();
  }
}
