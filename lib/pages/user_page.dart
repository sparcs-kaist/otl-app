import 'package:flutter/material.dart';
import 'package:otlplus/constants/text_styles.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildContent("이름 ", "${user.firstName} ${user.lastName}"),
            _buildContent("메일 ", user.email),
            _buildContent("학번 ", user.studentId),
            _buildContent("전공 ",
                user.majors.map((department) => department.name).join(", ")),
            _buildDivider(),
            _buildMyReviewButton(context),
            _buildLikedReviewButton(context),
            _buildDivider(),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: gray0.withOpacity(0.25));
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('내 정보', style: bodyBold),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
      flexibleSpace: SafeArea(
        child: Container(color: PRIMARY_COLOR, height: 5),
      ),
      backgroundColor: pinksLight,
      foregroundColor: gray0,
      elevation: 0.0,
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildContent(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text.rich(
        TextSpan(
          style: bodyRegular,
          children: <TextSpan>[
            TextSpan(text: title, style: bodyBold),
            TextSpan(text: body),
          ],
        ),
      ),
    );
  }

  Widget _buildMyReviewButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, buildMyReviewPageRoute()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('assets/icons/MyReview.png', height: 24.0),
            const SizedBox(width: 8),
            Text('내가 들은 과목', style: bodyBold.copyWith(color: pinksMain)),
            const Expanded(child: SizedBox()),
            Icon(Icons.navigate_next, color: pinksMain),
          ],
        ),
      ),
    );
  }

  Widget _buildLikedReviewButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, buildLikedReviewPageRoute()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('assets/icons/LikedReview.png', height: 24.0),
            const SizedBox(width: 8),
            Text('좋아요한 과목', style: bodyBold.copyWith(color: pinksMain)),
            const Expanded(child: SizedBox()),
            Icon(Icons.navigate_next, color: pinksMain),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<AuthModel>().logout();
        context.read<InfoModel>().logout();
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('assets/icons/Logout.png', height: 24.0),
            const SizedBox(width: 8),
            Text('로그아웃', style: bodyBold.copyWith(color: pinksMain)),
          ],
        ),
      ),
    );
  }
}
