import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AuthModel extends ChangeNotifier {
  List<Cookie> _cookies;
  List<Cookie> get cookies => _cookies;

  bool get isLogined => cookies != null && cookies.length > 0;

  Future<void> authenticate(String url) async {
    final cookieManager = CookieManager.instance();
    final cookies = await cookieManager.getCookies(url: url);
    _cookies = cookies;

    notifyListeners();
  }
}
