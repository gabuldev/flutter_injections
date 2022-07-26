import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheInterceptor implements InterceptorsWrapper {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // if (options.data['useCache'] == true) {
    //   final instance = await SharedPreferences.getInstance();
    //   if (instance.containsKey(options.path)) {
    //     final json = instance.getString(options.path);
    //     if (json != null) {
    //       final data = jsonDecode(json);
    //       handler.resolve(Response(requestOptions: options, data: data));
    //     }
    //   }
    // }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.requestOptions.method == "GET") {
      final instance = await SharedPreferences.getInstance();
      instance.setString(
          response.requestOptions.path, jsonEncode(response.data));
    }
    handler.resolve(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    final instance = await SharedPreferences.getInstance();
    if (instance.containsKey(err.requestOptions.path)) {
      final json = instance.getString(err.requestOptions.path);
      if (json != null) {
        final data = jsonDecode(json);
        return handler
            .resolve(Response(requestOptions: err.requestOptions, data: data));
      }
    }
  }
}
