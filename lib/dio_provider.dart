import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:otlplus/constants/url.dart';

class DioProvider {
  static DioProvider? _instance;
  factory DioProvider() => _instance ??= DioProvider._internal();

  Dio _dio = Dio();
  Dio get dio => _dio;

  DioProvider._internal();

  void authenticate(List<Cookie> cookies) {
    _dio.options.baseUrl = BASE_URL;
    _dio.options.headers["cookie"] =
        cookies.map((cookie) => "${cookie.name}=${cookie.value}").join("; ");
    _dio.options.headers["X-CSRFToken"] =
        cookies.firstWhere((cookie) => cookie.name == "csrftoken").value;
  }
}
