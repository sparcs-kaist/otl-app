import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/providers/auth_model.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<AuthModel>(context);

    return Container(
      child: Center(
        child: Text("${authModel.user.firstName} ${authModel.user.lastName}"),
      ),
    );
  }
}
