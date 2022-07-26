import 'exception.dart';
import 'inject.dart';

class Instance {
  final instances = <String, Inject>{};

  /// Used for get instance
  B get<B>([B? type]) {
    if (B.toString() == "dynamic") {
      throw InjectException(message: "NOT ALLOW FOR DYNAMIC VALUES");
    }
    final _instance = instances[B.toString()];
    if (_instance != null) {
      return _instance.value(this);
    } else {
      throw InjectException(message: "$B DONT FOUND");
    }
  }

  /// Used for get instance
  B call<B>() {
    return get<B>();
  }

  /// Used for add new Inject
  void set<T>(Inject<T> inject) {
    final type = inject.toString().split("<").last.replaceAll(">'", '');
    instances.addAll({type: inject});
  }

  //Used for dispose specific instance
  void dispose<T>() {
    instances.remove(T);
  }
}
