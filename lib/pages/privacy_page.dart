import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/privacy.dart';
import 'package:otlplus/constants/text_styles.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text.rich(
              TextSpan(
                style: bodyRegular,
                children: <TextSpan>[
                  TextSpan(
                    text: privacyText0,
                    children: List.generate(
                      12,
                      (index) => TextSpan(
                        children: [
                          TextSpan(text: '\n'),
                          TextSpan(text: privacyTitles[index], style: bodyBold),
                          TextSpan(text: '\n'),
                          TextSpan(text: privacyTexts[index]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Theme(
        data: Theme.of(context).copyWith(
            appBarTheme: AppBarTheme(
          color: BACKGROUND_COLOR,
          elevation: 0.0,
          actionsIconTheme: IconThemeData(
            color: CONTENT_COLOR,
          ),
        )),
        child: AppBar(
          title: Text(
            '개인정보취급방침',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          centerTitle: true,
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Container(
                  color: PRIMARY_COLOR,
                  height: 5,
                ),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
