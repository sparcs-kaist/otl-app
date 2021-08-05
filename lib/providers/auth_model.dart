import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:otlplus/dio_provider.dart';

class AuthModel extends ChangeNotifier {
  bool _isLogined = false;
  bool get isLogined => _isLogined;

  Future<void> authenticate(Uri url) async {
    try {
      final cookieManager = CookieManager.instance();
      final cookies = await cookieManager.getCookies(url: url);
      DioProvider().authenticate(cookies);
      _isLogined = true;
      notifyListeners();
    } catch (exception) {
      print(exception);
    }
  }
}
