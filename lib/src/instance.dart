import 'exception.dart';
import 'helpers.dart';
import 'inject.dart';
import 'instance_provider.dart';

class Instance {
  final instances = <String, Inject>{};
  final InstanceProvider provider;
  Instance({
    required this.provider,
  });

  /// Used for get instance
  B? get<B>([B? type]) {
    if (B.toString() == "dynamic") {
      throw InjectException(message: "NOT ALLOW FOR DYNAMIC VALUES");
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
  }

  //Used for dispose specific instance
  void dispose<T>() {
    instances.remove(T.toString());
  }
}
