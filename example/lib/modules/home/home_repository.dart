import 'package:dio/dio.dart';

import 'models/post_model.dart';

class HomeRepository {
  final Dio client;
  HomeRepository({
    required this.client,
  });

  Future<List<PostModel>> getPosts() async {
    try {
      final response = await client.get("/posts");
      return (response.data as List<dynamic>)
          .map((e) => PostModel.fromMap(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PostModel>> getPhotos() async {
    try {
      final response = await client.get("/photos");
      return (response.data as List<dynamic>)
          .map((e) => PostModel.fromMap(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
