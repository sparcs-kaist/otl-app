import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:timeplanner_mobile/constants/url.dart';
import 'package:timeplanner_mobile/models/user.dart';

class AuthModel extends ChangeNotifier {
  List<Cookie> _cookies;
  List<Cookie> get cookies => _cookies;

  User _user;
  User get user => _user;

  bool get isLogined => cookies != null && cookies.length > 0;

  String get cookiesAsRawString =>
      _cookies.map((cookie) => "${cookie.name}=${cookie.value}").join("; ");

  Future<void> authenticate(String url) async {
    final cookieManager = CookieManager.instance();
    final cookies = await cookieManager.getCookies(url: url);
    _cookies = cookies;

    _user = await getUser();

    notifyListeners();
  }

  Future<User> getUser() async {
    final dio = Dio();
    dio.options.headers["Cookie"] = cookiesAsRawString;

    final response = await dio.get(SESSION_INFO_URL);

    return User.fromJson(response.data);
  }
}
