// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'exception.dart';
import 'flutter_injections.dart';
import 'helpers.dart';
import 'inject.dart';

/// A class that manages instances of injected objects.
///
/// This class provides methods to get, set, and dispose of instances of injected objects.
///
/// The `get` method is used to retrieve an instance of an injected object. It takes an optional parameter of the type of the object to retrieve. If no type is provided, it returns `null`. If the type is not found in the instances map, it returns `null`.
///
/// The `set` method is used to add a new instance of an injected object to the instances map. It takes an `Inject` object as a parameter.
///
/// The `dispose` method is used to remove a specific instance of an injected object from the instances map. It takes the type of the object to remove as a parameter.
///
/// The `disposeAll` method is used to remove all instances of injected objects from the instances map.
class FlutterInstance {
  final instances = <String, Inject>{};
  final FlutterInjections provider;
  FlutterInstance({
    required this.provider,
  });

  /// Used for get instance
  B? get<B>([B? type]) {
    if (B.toString() == "dynamic") {
      throw InjectException(message: "DON'T ALLOW FOR DYNAMIC VALUES");
    }
    final _instance = instances[B.toString()];
    if (_instance != null) {
      return _instance.get(provider);
    } else {
      return null;
    }
  }

  /// Used for add new Inject
  void set<T>(Inject<T> inject) {
    final type = Helpers.sanitize(inject.toString());
    instances.addAll({type: inject});
    log("FlutterInstance - Add injection $type");
  }

  //Used for dispose specific instance
  void dispose<T>() {
    final type = Helpers.sanitize(T.toString());
    instances.remove(type);
    log("FlutterInstance - Dispose injection ${T.toString()}");
  }

  //Used for dispose specific instance
  void disposeAll() {
    log("FlutterInstance - Removed injections: ${instances.keys.toList()}");
    instances.clear();
  }

  @override
  bool operator ==(covariant FlutterInstance other) {
    if (identical(this, other)) return true;

    return other.instances == instances;
  }

  @override
  int get hashCode => provider.hashCode;
}
