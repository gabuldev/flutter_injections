import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';

import 'interceptors/cache_interceptor.dart';

class CustomDio extends DioForNative {
  CustomDio() {
    options.baseUrl = "https://jsonplaceholder.typicode.com";
    interceptors.add(CacheInterceptor());
  }
}

Dio get dioInstance => CustomDio();
