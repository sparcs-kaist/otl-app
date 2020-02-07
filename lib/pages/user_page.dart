import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/models/user.dart';
import 'package:timeplanner_mobile/providers/auth_model.dart';
import 'package:timeplanner_mobile/widgets/custom_appbar.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthModel>(context).user;

    return SafeArea(
      child: Material(
        child: Column(
          children: <Widget>[
            CustomAppBar(
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.language),
                  onPressed: () {},
                ),
              ],
            ),
            _buildBody(context, user),
          ],
        ),
      ),
    );
  }

  Padding _buildBody(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "내 정보",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.body1,
                    children: <TextSpan>[
                      TextSpan(
                        text: "이름 ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: "${user.firstName} ${user.lastName}"),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.body1,
                    children: <TextSpan>[
                      TextSpan(
                        text: "메일 ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: user.email),
                    ],
                  ),
                ),
              ),
              Divider(color: DIVIDER_COLOR),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "학사 정보",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.body1,
                    children: <TextSpan>[
                      TextSpan(
                        text: "학번 ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: user.studentId),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.body1,
                    children: <TextSpan>[
                      TextSpan(
                        text: "전공 ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: user.majors
                            .map((department) => department.name)
                            .join(", "),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: DIVIDER_COLOR),
            ],
          ),
        ),
      ),
    );
  }
}
