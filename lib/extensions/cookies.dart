import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

extension CookiesParsing on List<Cookie> {
  String toRawString() {
    return map((cookie) => "${cookie.name}=${cookie.value}").join("; ");
  }

  void pushToDio(Dio dio) {
    dio.options.headers["cookie"] = toRawString();
    dio.options.headers["X-CSRFToken"] =
        firstWhere((cookie) => cookie.name == "csrftoken").value;
  }
}
