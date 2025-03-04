import 'package:dio/browser_imp.dart';
import 'package:dio/dio.dart';

import 'interceptors/cache_interceptor.dart';

class CustomDio extends DioForBrowser {
  CustomDio() {
    options.baseUrl = "https://jsonplaceholder.typicode.com";
    interceptors.add(CacheInterceptor());
  }
}

Dio get dioInstance => CustomDio();
