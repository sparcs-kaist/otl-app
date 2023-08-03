import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/providers/auth_model.dart';
import 'package:otlplus/utils/build_app_bar.dart';
import 'package:otlplus/utils/build_page_route.dart';
import 'package:otlplus/utils/responsive_button.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/providers/info_model.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<InfoModel>().user;
    final isEn =
        EasyLocalization.of(context)?.currentLocale == const Locale('en');

    return Scaffold(
      appBar: buildAppBar(context, 'title.my_information'.tr(), false, true),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildContent(
                      "user.name", "${user.firstName} ${user.lastName}"),
                  _buildContent("user.email", user.email),
                  _buildContent("user.student_id", user.studentId),
                  _buildContent(
                    "user.major",
                    user.majors
                        .map(
                          (department) =>
                              isEn ? department.nameEn : department.name,
                        )
                        .join(", "),
                  ),
                  _buildDivider(),
                ],
              ),
            ),
            _buildNavigateArrowButton(
                context,
                'assets/icons/my_review.svg',
                'user.my_review'.tr(),
                () => Navigator.push(context, buildMyReviewPageRoute())),
            _buildNavigateArrowButton(
                context,
                'assets/icons/liked_review.svg',
                'user.liked_review'.tr(),
                () => Navigator.push(context, buildLikedReviewPageRoute())),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildDivider(),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconTextButton(
                icon: 'assets/icons/logout.svg',
                onTap: () {
                  context.read<AuthModel>().logout();
                  context.read<InfoModel>().logout();
                  Navigator.pop(context);
                },
                text: 'user.logout'.tr(),
                color: OTLColor.pinksMain,
                textStyle: bodyBold,
                spaceBetween: 8.0,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
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

  Widget _buildNavigateArrowButton(
      BuildContext context, String icon, String text, VoidCallback onTap) {
    return IconTextButtonRaw(
      data: {
        'Padding': {
          'padding': const EdgeInsets.symmetric(horizontal: 16.0),
          'child': {
            'SizedBox': {
              'height': 36.0,
              'child': {
                'Row': {
                  'children': [
                    {
                      'SvgPicture.asset': {
                        'arg': icon,
                        'height': 24.0,
                        'width': 24.0,
                        'color': OTLColor.pinksMain
                      }
                    },
                    {
                      'Padding': {
                        'padding': const EdgeInsets.symmetric(horizontal: 8.0),
                        'child': {
                          'Text': {
                            'arg': text,
                            'style':
                                bodyBold.copyWith(color: OTLColor.pinksMain),
                          }
                        },
                      }
                    },
                    const {'Spacer': {}},
                    const {
                      'Padding': {
                        'padding': EdgeInsets.fromLTRB(16, 6, 0, 6),
                        'child': {
                          'Icon': {
                            'arg': Icons.navigate_next,
                            'color': OTLColor.pinksMain,
                          }
                        }
                      }
                    }
                  ]
                }
              }
            }
          }
        }
      },
      onTap: onTap,
    );
  }
}
