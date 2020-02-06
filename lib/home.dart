import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:timeplanner_mobile/constants/url.dart';

class TimeplannerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTL PLUS Mobile"),
      ),
      body: InAppWebView(
        initialUrl: LOGIN_URL,
        initialOptions: InAppWebViewWidgetOptions(),
        onLoadStop: (controller, url) async {
          if (url.startsWith(MAIN_URL)) {
            final cookieManager = CookieManager.instance();
            final cookies = await cookieManager.getCookies(url: MAIN_URL);
            cookies
                .forEach((cookie) => print("${cookie.name}: ${cookie.value}"));
          }
        },
      ),
    );
  }
}
