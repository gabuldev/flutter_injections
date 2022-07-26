import '../../shared/helpers/state.dart';
import 'splash_state.dart';

class SplashController extends SplashState {
  Future<void> syncData() async {
    state = AppState.loading;
    await Future.delayed(const Duration(seconds: 4));
    state = AppState.success;
  }
}
