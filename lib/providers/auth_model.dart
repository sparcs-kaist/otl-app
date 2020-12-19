import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:timeplanner_mobile/dio_provider.dart';

enum AuthState {
  progress,
  error,
  done,
}

class AuthModel extends ChangeNotifier {
  AuthState _state = AuthState.progress;
  AuthState get state => _state;

  Future<void> authenticate(String url) async {
    try {
      final cookieManager = CookieManager.instance();
      final cookies = await cookieManager.getCookies(url: url);
      DioProvider().authenticate(cookies);
      _state = AuthState.done;
    } catch (exception) {
      print(exception);
      _state = AuthState.error;
    }
    notifyListeners();
  }
}
