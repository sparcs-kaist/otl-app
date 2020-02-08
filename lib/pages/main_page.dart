import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/providers/info_model.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final infoModel = Provider.of<InfoModel>(context, listen: false);

    return Container(
      child: Center(
        child: Text("${infoModel.user.firstName} ${infoModel.user.lastName}"),
      ),
    );
  }
}
