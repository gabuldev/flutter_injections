import 'dart:developer';
import 'package:flutter/material.dart';

import '../flutter_injections.dart';

/// A widget that provides dependency injection to its child widget tree.
class FlutterInjectionsWidget extends StatefulWidget {
  final WidgetBuilder builder;
  final List<Inject<Object>> injections;

  // Guarda a referência para a instância global
  final FlutterInjections instance;

  FlutterInjectionsWidget({
    Key? key,
    required this.builder,
    required this.injections,
  }) : instance = FlutterInjections.getInstance(), // Sempre pega a instância global
       super(key: key) {
    log("FlutterInjectionsWidget - Construindo com ${injections.length} injeções.");
    // Adiciona as injeções à instância global
    // A lógica de não duplicar singletons está no FlutterInstance.set()
    instance.addInjections(injections);
  }

  @override
  State<FlutterInjectionsWidget> createState() =>
      _FlutterInjectionsWidgetState();
}

class _FlutterInjectionsWidgetState extends State<FlutterInjectionsWidget> {
  @override
  void initState() {
    super.initState();
    log("FlutterInjectionsWidget - initState");
  }

  @override
  void dispose() {
    log("FlutterInjectionsWidget - dispose. NÃO chamando disposeAll na instância global.");
    // IMPORTANTE: Não chamar widget.instance.disposeAll() aqui,
    // pois "instance" agora é a instância global e não deve ser descartada
    // pelo ciclo de vida de um widget específico.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("FlutterInjectionsWidget - build");
    return widget.builder(context);
  }
}
