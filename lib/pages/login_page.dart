import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/constants/url.dart';
import 'package:timeplanner_mobile/providers/auth_model.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<AuthModel>(context, listen: false);

    return SafeArea(
      child: InAppWebView(
        initialUrl: LOGIN_URL,
        initialOptions: InAppWebViewWidgetOptions(),
        onLoadStop: (controller, url) {
          if (url.startsWith(MAIN_URL)) authModel.authenticate(MAIN_URL);
        },
      ),
    );
  }
}
