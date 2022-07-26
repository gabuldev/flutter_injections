import 'package:flutter/foundation.dart';

import 'state.dart';

abstract class BaseState extends ChangeNotifier {
  AppState _state = AppState.none;
  AppState get state => _state;
  set state(AppState value) {
    _state = value;
    notifyListeners();
  }

  Future<T?> execute<T>(Future<T> Function() value) async {
    state = AppState.loading;
    try {
      final T response = await value();
      state = AppState.success;
      return response;
    } catch (e) {
      state = AppState.error;
      return null;
    }
  }
}
