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
      try {
         return _instance.get(provider);
      } catch (e) {
         log("FlutterInstance.get - Error calling get on Inject for $B: $e");
         throw InjectException(message: "Error retrieving instance $B: $e");
      }
    } else {
      log("FlutterInstance.get - Instance $B not found in this FlutterInstance");
      return null; // Ou talvez lançar erro aqui? Por enquanto retorna null.
    }
  }

  /// Used for add new Inject
  /// Prevents adding duplicate singletons.
  void set<T>(Inject<T> inject) {
    final type = Helpers.sanitize(inject.toString());
    
    // CRUCIAL: Evita adicionar/sobrescrever singletons que já existem nesta instância.
    if (inject.type == InjectType.singleton && instances.containsKey(type)) {
      log("FlutterInstance.set - Ignorando adição do singleton $type pois já existe.");
      return; // Não faz nada se o singleton já existe
    }
    
    // Adiciona a injeção (factory ou singleton novo)
    instances[type] = inject; // Usar atribuição direta para garantir que sobrescreva se necessário (embora não deva para singletons)
    log("FlutterInstance.set - Adicionada injeção $type");
  }

  //Used for dispose specific instance
  void dispose<T>() {
    final type = Helpers.sanitize(T.toString());
    if (instances.containsKey(type)) {
      // Tenta chamar o dispose do Inject, se ele tiver um (útil para Blocs, etc)
      try {
         instances[type]?.disposeInstance(); 
      } catch(e) {
         log("FlutterInstance.dispose<$T> - Erro ao chamar disposeInstance no Inject: $e");
         // Continua para remover a referência
      }
      instances.remove(type);
      log("FlutterInstance.dispose - Injeção ${T.toString()} removida.");
    } else {
       log("FlutterInstance.dispose - Injeção ${T.toString()} não encontrada para remover.");
    }
  }

  //Used for dispose all instances
  void disposeAll() {
    log("FlutterInstance.disposeAll - Removendo todas as ${instances.length} injeções: ${instances.keys.toList()}");
    // Chama dispose para cada Inject antes de limpar
    final typesToRemove = instances.keys.toList(); // Copia as chaves para evitar erro de modificação durante iteração
    for (var type in typesToRemove) {
      try {
        instances[type]?.disposeInstance(); // Chama o dispose interno do Inject
      } catch (e) {
        log("FlutterInstance.disposeAll - Erro ao chamar disposeInstance para o tipo $type: $e");
      }
    }
    instances.clear();
    log("FlutterInstance.disposeAll - Injeções removidas.");
  }

  @override
  bool operator ==(covariant FlutterInstance other) {
    if (identical(this, other)) return true;
    // Compara pela referência do provider (FlutterInjections) e talvez o mapa?
    // A comparação de mapa pode ser custosa. Talvez baste a referência do provider.
    return other.provider == provider;
  }

  @override
  int get hashCode => provider.hashCode;
}
