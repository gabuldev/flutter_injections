import '../flutter_injections.dart';

/// A function type that takes a [FlutterInjections] instance and returns an object of type [T].
typedef Bind<T> = T Function(FlutterInjections i);
