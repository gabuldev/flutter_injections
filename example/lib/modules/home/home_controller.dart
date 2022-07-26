import 'home_repository.dart';
import 'home_state.dart';

class HomeController extends HomeState {
  final HomeRepository repository;
  HomeController({
    required this.repository,
  });
  Future<void> getPosts() async {
    final response = await execute(() => repository.getPosts());
    if (response != null) {
      posts = response;
    }
  }
}
