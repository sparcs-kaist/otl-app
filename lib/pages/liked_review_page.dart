import 'package:flutter/material.dart';
import 'package:otlplus/providers/course_detail_model.dart';
import 'package:otlplus/providers/info_model.dart';
import 'package:otlplus/providers/liked_review_model.dart';
import 'package:otlplus/widgets/backdrop.dart';
import 'package:otlplus/widgets/review_block.dart';
import 'package:provider/provider.dart';

class LikedReviewPage extends StatelessWidget {
  final _scrollController = ScrollController();

  LikedReviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('build');
    final user = context.watch<InfoModel>().user;
    final reviews = context.watch<LikedReviewModel>().likedReviews(user);

    return Container(
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
                Text(
                  "좋아요한 후기",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(height: 8.0),
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
                                    Backdrop.of(context).show(1);
                                  },
                                );
                              },
                              childCount: reviews.length,
                            ),
                          ),
                          SliverList(
                              delegate: SliverChildListDelegate([
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, bottom: 12.0),
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
    );
  }
}
