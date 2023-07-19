import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/url.dart';
import 'package:otlplus/providers/auth_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends StatefulWidget {
  static String route = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Material(
        child: Stack(
          children: <Widget>[
            Center(
              child: const CircularProgressIndicator(),
            ),
            _buildBody(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    const AUTHORITY = 'otl.kaist.ac.kr';
    Map<String, dynamic> query = {'next': BASE_URL};
    if (Platform.isIOS) {
      query['social_login'] = '0';
    }
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: _isVisible,
      child: WebView(
        initialUrl: Uri.https(AUTHORITY, '/session/login/', query).toString(),
        javascriptMode: JavascriptMode.unrestricted,
        onPageStarted: (url) {
          if (Uri.parse(url).authority == AUTHORITY) {
            setState(() {
              _isVisible = false;
            });
          }
        },
        onPageFinished: (url) {
          String authority = Uri.parse(url).authority;
          if (authority == AUTHORITY) {
            context.read<AuthModel>().authenticate('https://$AUTHORITY');
          } else if (authority == 'sparcssso.kaist.ac.kr') {
            setState(() {
              _isVisible = true;
            });
          } else {
            setState(() {
              _isVisible = true;
            });
          }
        },
      ),
    );
  }
}
