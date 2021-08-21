import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/url.dart';
import 'package:otlplus/providers/auth_model.dart';

class LoginPage extends StatefulWidget {
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
            Center(child: const CircularProgressIndicator()),
            _buildBody(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    const AUTHORITY = 'otl.kaist.ac.kr';
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: _isVisible,
      child: InAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.https(AUTHORITY, '/session/login/', {'next': BASE_URL})),
        initialOptions: InAppWebViewGroupOptions(),
        onLoadStart: (controller, url) {
          if (url.authority == AUTHORITY) {
            setState(() {
              _isVisible = false;
            });
          }
        },
        onLoadStop: (controller, url) {
          if (url.authority == AUTHORITY) {
            context.read<AuthModel>().authenticate(Uri.https(AUTHORITY, '/'));
          } else if (url.authority == 'sparcssso.kaist.ac.kr') {
            setState(() {
              _isVisible = true;
            });
          }
        },
      ),
    );
  }
}
