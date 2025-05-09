import 'dart:developer';

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
  FlutterInstance? _current; // Instância associada a este FlutterInjections (pode não ser a global)

  // ----- Instância Global Singleton -----
  static FlutterInjections? _globalInstance;
  static final List<FlutterInstance> _instances = []; // Lista de todas as instâncias FlutterInstance criadas

  /// Garante que a instância global seja criada apenas uma vez.
  static FlutterInjections getInstance() {
    if (_globalInstance == null) {
      log("FlutterInjections - Criando instância global");
      _globalInstance = FlutterInjections._internal();
    } else {
      log("FlutterInjections - Usando instância global existente");
    }
    return _globalInstance!;
  }

  /// Construtor interno para o singleton global.
  FlutterInjections._internal() {
    log("FlutterInjections - Construtor interno (_internal)");
    _current = FlutterInstance(provider: this);
    // Adiciona a instância FlutterInstance criada à lista global _instances
    // Esta lista é usada pelo _find para buscar em todas as instâncias conhecidas.
    if (!_instances.contains(_current)) {
       FlutterInjections._instances.add(_current!);
       log("FlutterInjections - Nova FlutterInstance adicionada a _instances. Total: ${_instances.length}");
    }
  }

  /// Construtor público que retorna a instância global.
  factory FlutterInjections() {
    return getInstance();
  }
  // ----- Fim Instância Global Singleton -----


  /// Adds a list of injections to the injection container.
  /// Agora, apenas adiciona ao _current FlutterInstance. A lógica de duplicatas
  /// está no FlutterInstance.set().
  void addInjections(List<Inject<Object>> injections) {
    log("FlutterInjections.addInjections - Adicionando ${injections.length} injeções para $_current");
    if (_current == null) {
       log("FlutterInjections.addInjections - ERRO: _current é nulo!");
       // Talvez reinicializar? Ou lançar erro? Por agora, vamos tentar criar.
       _current = FlutterInstance(provider: this);
       if (!_instances.contains(_current)) {
          _instances.add(_current!);
       }
    }
    for (var k = 0; k < injections.length; k++) {
      final inject = injections[k];
      _current!.set(inject); // Confia no set() para lidar com singletons existentes
    }
  }

  /// Finds and returns an instance of type [T] from the list of registered instances.
  /// Busca em todas as instâncias conhecidas (_instances), da mais recente para a mais antiga.
  static T _find<T>() {
    log("FlutterInjections._find - Buscando por $T em ${_instances.length} instâncias");
    T? _instance;
    // Itera sobre a lista global de FlutterInstances
    for (var k = _instances.length - 1; k >= 0; k--) {
      final _i = _instances[k];
      try {
        _instance ??= _i.get<T>(); // Tenta obter da instância atual
        if (_instance != null) {
          log("FlutterInjections._find - Instância $T encontrada em $_i");
          break; // Para na primeira instância que encontrar
        }
      } catch (e) {
         log("FlutterInjections._find - Erro ao buscar $T em $_i: $e");
         // Continua para a próxima instância
      }
    }
    if (_instance == null) {
      log("FlutterInjections._find - ERRO: Instância $T NÃO ENCONTRADA em nenhuma instância!");
      log("FlutterInjections._find - Estado das instâncias: ${_instances.map((i) => i.instances.keys).toList()}");
      throw InjectException(message: "$T DON'T EXIST");
    }

    return _instance;
  }

  /// Retrieves the injection of the specified type from the last added instance.
  T find<T>() {
    return FlutterInjections._find<T>();
  }

  /// Disposes all injections in the current instance.
  /// Evita descartar a instância global.
  void disposeAll() {
    // Só remove/descarta se NÃO for a instância global
    if (this != _globalInstance && _current != null) {
       log("FlutterInjections.disposeAll - Removendo instância não global: $_current");
      _instances.remove(_current);
      _current?.disposeAll(); // Chama o disposeAll da FlutterInstance
      _current = null; // Libera a referência
    } else {
       log("FlutterInjections.disposeAll - Ignorando descarte da instância global ou _current nulo.");
    }
  }

  /// Disposes the instance of type T that was last registered with the [register] method.
  void dispose<T>() => _dispose<T>();

  /// Disposes the instance of type T that was last registered.
  /// Busca em todas as instâncias e remove da primeira que encontrar.
  static void _dispose<T>() {
    log("FlutterInjections._dispose - Tentando descartar $T");
    String typeString = T.toString();
    for (var k = _instances.length - 1; k >= 0; k--) {
      final _i = _instances[k];
      // Verifica se a instância _i *contém* a chave para o tipo T
      if (_i.instances.containsKey(typeString)) { 
        try {
           _i.dispose<T>(); // Chama o dispose da FlutterInstance específica
           log("FlutterInjections._dispose - $T descartado da instância $_i");
           return; // Para após descartar da primeira encontrada
        } catch (e) {
           log("FlutterInjections._dispose - Erro ao descartar $T de $_i: $e");
           // Continua buscando em outras instâncias caso haja erro inesperado no dispose
        }
      }
    }
    log("FlutterInjections._dispose - ERRO: $T NÃO ENCONTRADO para descarte!");
    throw NotDisposeException(message: "$T NÃO EXISTE NAS INSTÂNCIAS PARA SER DESCARTADO"); // Mensagem mais clara
  }

  /// Retrieves the injection of the specified type. Static version.
  static T get<T>() {
    return _find<T>();
  }
}
