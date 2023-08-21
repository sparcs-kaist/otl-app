import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/widgets/responsive_button.dart';
import 'package:otlplus/widgets/otl_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/providers/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends StatefulWidget {
  static String route = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if (!((await SharedPreferences.getInstance()).getBool('hasAccount') ??
            true)) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('user.account_deleted'.tr()),
              content: Text('user.deleted_account'.tr()),
              actions: [
                IconTextButton(
                  padding: EdgeInsets.all(12),
                  text: 'common.close'.tr(),
                  color: OTLColor.pinksMain,
                  onTap: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return OTLScaffold(
      child: Material(
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
    const AUTHORITY = 'otl.sparcs.org';
    Map<String, dynamic> query = {'next': 'https://otl.sparcs.org/'};
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
