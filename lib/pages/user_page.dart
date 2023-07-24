import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/providers/auth_model.dart';
import 'package:otlplus/utils/build_app_bar.dart';
import 'package:otlplus/utils/build_page_route.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/providers/info_model.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<InfoModel>().user;

    return Scaffold(
      appBar: buildAppBar(context, 'user.user', false, true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildContent("user.name", "${user.firstName} ${user.lastName}"),
            _buildContent("user.email", user.email),
            _buildContent("user.student_id", user.studentId),
            _buildContent("user.major",
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
    return Divider(color: OTLColor.gray0.withOpacity(0.25));
  }

  Widget _buildContent(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(title.tr(), style: bodyBold),
          const SizedBox(width: 8.0),
          Text(body),
        ],
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
            SvgPicture.asset('assets/icons/my_review.svg', height: 24.0),
            const SizedBox(width: 8),
            Text(
              'user.my_review'.tr(),
              style: bodyBold.copyWith(color: OTLColor.pinksMain),
            ),
            const Expanded(child: SizedBox()),
            Icon(Icons.navigate_next, color: OTLColor.pinksMain),
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
            SvgPicture.asset('assets/icons/liked_review.svg', height: 24.0),
            const SizedBox(width: 8),
            Text(
              'user.liked_review'.tr(),
              style: bodyBold.copyWith(color: OTLColor.pinksMain),
            ),
            const Expanded(child: SizedBox()),
            Icon(Icons.navigate_next, color: OTLColor.pinksMain),
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
            SvgPicture.asset('assets/icons/logout.svg', height: 24.0),
            const SizedBox(width: 8),
            Text(
              'user.logout'.tr(),
              style: bodyBold.copyWith(color: OTLColor.pinksMain),
            ),
          ],
        ),
      ),
    );
  }
}
