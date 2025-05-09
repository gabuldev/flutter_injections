import '../flutter_injections.dart';
import 'bind.dart';
import 'dart:developer';

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
  bool _canDispose = false;

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
    _checkIfDisposable(value);
    return value!;
  }

  void dispose() {
    value = null;
  }

  /// Verifica se a instância tem um método `close` ou `dispose`.
  void _checkIfDisposable(T? instance) {
    if (instance == null) return;
    _canDispose = false;
    // Tenta verificar se existe o método close() ou dispose()
    try {
       (instance as dynamic).close;
       _canDispose = true;
       log("Inject - Instância $T possui método close().");
       return;
    } catch (_) {}
    try {
       (instance as dynamic).dispose;
       _canDispose = true;
       log("Inject - Instância $T possui método dispose().");
    } catch (_) {
      log("Inject - Instância $T não possui close() nem dispose().");
    }
  }
  
  /// Descarta a instância interna se for um singleton e tiver método dispose/close.
  void disposeInstance() {
     if (type == InjectType.singleton && value != null && _canDispose) {
        log("Inject - Chamando dispose/close para singleton $T");
        try {
           // Tenta chamar close() primeiro (comum em Blocs/Cubits)
           (value as dynamic).close();
           log("Inject - Singleton $T close() chamado.");
        } catch (e) {
           // Se close falhar, tenta dispose()
           try {
              (value as dynamic).dispose();
              log("Inject - Singleton $T dispose() chamado.");
           } catch (e2) {
              log("Inject - Falha ao chamar close() ou dispose() para $T: $e, $e2");
           }
        }
        value = null; // Limpa a referência após dispose
     } else if (type == InjectType.singleton) {
         log("Inject - Singleton $T não precisa/pode ser descartado ou já é nulo.");
         value = null; // Garante que a referência seja limpa
     }
     // Factories não precisam ter o dispose chamado aqui, pois são criadas e usadas externamente.
  }
}
