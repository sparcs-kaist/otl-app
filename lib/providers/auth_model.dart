import 'dart:io';

import 'package:flutter/material.dart';
import 'package:otlplus/dio_provider.dart';
import 'package:otlplus/extensions/storage_model.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

class AuthModel extends StorageModel {
  bool _isLogined = false;
  bool get isLogined => _isLogined;

  Future<void> authenticate(String url) async {
    try {
      final cookieManager = WebviewCookieManager();
      final cookies = await cookieManager.getCookies(url);
      DioProvider().authenticate(cookies);
      _isLogined = true;
      notifyListeners();
      save('cookies', cookies.map((cookie) => cookie.toString()).join(';'));
    } catch (exception) {
      print(exception);
    }
  }

  Future<void> authenticateWithCookies(List<Cookie> cookies) async {
    try {
      DioProvider().authenticate(cookies);
      _isLogined = true;
      notifyListeners();
    } catch (exception) {
      print(exception);
    }
  }

  Future<void> authenticateFromStorage() async {
    try {
      final cookies_string = await read('cookies');
      print("IT CALLED");
      print(cookies_string);
      if (cookies_string != null) {
        final cookies = cookies_string //
            .split(';')
            .map((cookie) => Cookie.fromSetCookieValue(cookie))
            .toList();

        authenticateWithCookies(cookies);
      }
    } catch (exception) {
      print(exception);
    }
  }

  void logout() {
    try {
      final cookieManager = WebviewCookieManager();
      // cookieManager.removeCookie(url);
      cookieManager.clearCookies();
      DioProvider().logout();
      delete('cookies');
      _isLogined = false;
      notifyListeners();
    } catch (exception) {
      print(exception);
    }
  }
}
