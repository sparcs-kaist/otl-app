import 'package:flutter/material.dart';
import 'package:otlplus/pages/course_detail_page.dart';
import 'package:otlplus/providers/hall_of_fame_model.dart';
import 'package:otlplus/utils/navigator.dart';
import 'package:otlplus/widgets/hall_of_fame_control.dart';
import 'package:otlplus/widgets/otl_scaffold.dart';
import 'package:otlplus/widgets/review_mode_control.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/providers/course_detail_model.dart';
import 'package:otlplus/providers/latest_reviews_model.dart';
import 'package:otlplus/widgets/review_block.dart';

class ReviewPage extends StatefulWidget {
  static String route = 'review_page';

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    final _selectedMode =
        context.select<HallOfFameModel, int>((m) => m.selectedMode);

    return OTLLayout(
      leading: ReviewModeControl(
        selectedMode: context.watch<HallOfFameModel>().selectedMode,
      ),
      trailing: Visibility(
        visible: context.watch<HallOfFameModel>().selectedMode == 0,
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: HallOfFameControl(),
        ),
      ),
      body: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (_selectedMode == 1) {
              final reviewModel = context.read<LatestReviewsModel>();

              if (!reviewModel.isLoading &&
                  scrollNotification.metrics.pixels ==
                      scrollNotification.metrics.maxScrollExtent) {
                reviewModel.loadLatestReviews();
              }

              return true;
            } else {
              final hallOfFameModel = context.read<HallOfFameModel>();

              if (!hallOfFameModel.isLoading &&
                  scrollNotification.metrics.pixels ==
                      scrollNotification.metrics.maxScrollExtent) {
                hallOfFameModel.loadHallOfFame();
              }

              return true;
            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _selectedMode == 1 ? BuildLatestsReviews() : BuildHallOfFame()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildLatestsReviews extends StatelessWidget {
  const BuildLatestsReviews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _scrollController = context.watch<HallOfFameModel>().scrollController;
    final latestReviews = context.watch<LatestReviewsModel>().latestReviews;

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          await context.read<LatestReviewsModel>().clear();
        },
        child: Scrollbar(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ReviewBlock(
                      review: latestReviews[index],
                      onTap: () async {
                        context
                            .read<CourseDetailModel>()
                            .loadCourse(latestReviews[index].course.id);
                        OTLNavigator.push(context, CourseDetailPage());
                      },
                    );
                  },
                  childCount: latestReviews.length,
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
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
    );
  }
}

class BuildHallOfFame extends StatelessWidget {
  const BuildHallOfFame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _scrollController = context.watch<HallOfFameModel>().scrollController;
    final hallOfFames = context.watch<HallOfFameModel>().hallOfFame;

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          await context.read<HallOfFameModel>().clear();
        },
        child: Scrollbar(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ReviewBlock(
                      review: hallOfFames[index],
                      onTap: () async {
                        context
                            .read<CourseDetailModel>()
                            .loadCourse(hallOfFames[index].course.id);
                        OTLNavigator.push(context, CourseDetailPage());
                      },
                    );
                  },
                  childCount: hallOfFames.length,
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
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
    );
  }
}
