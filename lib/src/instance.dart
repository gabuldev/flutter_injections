import 'dart:developer';

import 'exception.dart';
import 'flutter_injections.dart';
import 'helpers.dart';
import 'inject.dart';

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
    instances.remove(T.toString());
    log("FlutterInstance - Dispose injection ${T.toString()}");
  }

  //Used for dispose specific instance
  void disposeAll() {
    log("FlutterInstance - Removed injections: ${instances.keys.toList()}");
    instances.clear();
  }
}
