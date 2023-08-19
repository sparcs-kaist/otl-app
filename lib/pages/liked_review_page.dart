import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otlplus/pages/course_detail_page.dart';
import 'package:otlplus/providers/course_detail_model.dart';
import 'package:otlplus/providers/info_model.dart';
import 'package:otlplus/providers/liked_review_model.dart';
import 'package:otlplus/utils/build_app_bar.dart';
import 'package:otlplus/utils/navigator.dart';
import 'package:otlplus/widgets/review_block.dart';
import 'package:provider/provider.dart';

class LikedReviewPage extends StatelessWidget {
  static String route = 'liked_review_page';

  final _scrollController = ScrollController();

  LikedReviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<InfoModel>().user;
    final reviews = context.watch<LikedReviewModel>().likedReviews(user);

    return Scaffold(
      appBar: buildAppBar(context, 'user.liked_review'.tr(), true, true),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              final likedReviewModel = context.read<LikedReviewModel>();

              if (!likedReviewModel.isLoading &&
                  scrollNotification.metrics.pixels ==
                      scrollNotification.metrics.maxScrollExtent) {
                likedReviewModel.loadLikedReviews(user);
              }
              return true;
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await context.read<LikedReviewModel>().clear(user);
                      },
                      child: Scrollbar(
                        controller: _scrollController,
                        child: CustomScrollView(
                          controller: _scrollController,
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return ReviewBlock(
                                    review: reviews[index],
                                    onTap: () async {
                                      context
                                          .read<CourseDetailModel>()
                                          .loadCourse(reviews[index].course.id);
                                      OTLNavigator.push(
                                          context, CourseDetailPage(),
                                          transition: 'right-left');
                                    },
                                  );
                                },
                                childCount: reviews.length,
                              ),
                            ),
                            SliverList(
                                delegate: SliverChildListDelegate([
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 4.0, bottom: 12.0),
                                child: const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.black12,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              )
                            ]))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
