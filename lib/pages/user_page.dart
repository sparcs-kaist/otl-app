import 'package:flutter/material.dart';
import 'package:otlplus/providers/auth_model.dart';
import 'package:otlplus/utils/build_page_route.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/providers/info_model.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<InfoModel>().user;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildContent("이름 ", "${user.firstName} ${user.lastName}"),
                  _buildContent("메일 ", user.email),
                  _buildContent("학번 ", user.studentId),
                  _buildContent(
                      "전공 ",
                      user.majors
                          .map((department) => department.name)
                          .join(", ")),
                  const Divider(color: DIVIDER_COLOR),
                  const SizedBox(height: 4.0),
                  _buildTextButton(context, '내가 들은 과목', 3),
                  _buildTextButton(context, '좋아요한 후기', 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.read<AuthModel>().logout();
                          context.read<InfoModel>().logout();
                          Navigator.pop(context);
                        },
                        child: Text(
                          '로그아웃',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: PRIMARY_COLOR,
                          ),
                        ),
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(StadiumBorder()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
            '내 정보',
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

  Widget _buildContent(String name, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(fontSize: 12.0),
          children: <TextSpan>[
            TextSpan(
              text: name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context, String name, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              index == 3
                  ? buildMyReviewPageRoute()
                  : buildLikedReviewPageRoute(),
            );
          },
          child: Text(
            name,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: PRIMARY_COLOR,
            ),
          ),
          style: ButtonStyle(
            shape: MaterialStatePropertyAll(StadiumBorder()),
          ),
        ),
      ],
    );
  }
}
