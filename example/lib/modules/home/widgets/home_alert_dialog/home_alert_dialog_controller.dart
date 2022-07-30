import 'package:example/modules/home/home_repository.dart';

class HomeAlertDialogController {
  final HomeRepository repository;
  HomeAlertDialogController({
    required this.repository,
  });

  Future<void> getPhotos() async {
    final response = await repository.getPhotos();
    print(response);
  }
}
