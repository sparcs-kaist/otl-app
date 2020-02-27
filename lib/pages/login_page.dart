import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/constants/url.dart';
import 'package:timeplanner_mobile/providers/auth_model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
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
    final authModel = Provider.of<AuthModel>(context, listen: false);

    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: _isVisible,
      child: InAppWebView(
        initialUrl: SESSION_LOGIN_URL,
        initialOptions: InAppWebViewWidgetOptions(),
        onLoadStart: (controller, url) {
          if (url.startsWith(MAIN_URL)) {
            setState(() {
              _isVisible = false;
            });
          }
        },
        onLoadStop: (controller, url) {
          if (url.startsWith(MAIN_URL)) authModel.authenticate(MAIN_URL);
        },
      ),
    );
  }
}
