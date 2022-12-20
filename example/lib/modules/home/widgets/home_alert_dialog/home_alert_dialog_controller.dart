import 'package:example/modules/home/home_repository.dart';

import '../../models/post_model.dart';

class HomeAlertDialogController {
  final HomeRepository repository;

  HomeAlertDialogController({
    required this.repository,
  });

  Future<List<PostModel>> getPhotos() async {
    return await repository.getPhotos();
  }
}
