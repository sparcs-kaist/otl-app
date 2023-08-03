import 'package:flutter/material.dart';
import 'package:otlplus/providers/hall_of_fame_model.dart';
import 'package:otlplus/utils/build_page_route.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/providers/course_detail_model.dart';
import 'package:otlplus/providers/review_model.dart';
import 'package:otlplus/widgets/review_block.dart';

class ReviewPage extends StatefulWidget {
  static String route = 'review_page';

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    int _selectedMode = context.read<HallOfFameModel>().selectedMode;
    final latestReviews = context.watch<ReviewModel>().reviews;
    final hallOfFames = context.watch<HallOfFameModel>().hallOfFames();

    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (_selectedMode == 1) {
            final reviewModel = context.read<ReviewModel>();

            if (!reviewModel.isLoading &&
                scrollNotification.metrics.pixels ==
                    scrollNotification.metrics.maxScrollExtent) {
              reviewModel.loadReviews();
            }

            return true;
          } else {
            final hallOfFameModel = context.read<HallOfFameModel>();

            if (!hallOfFameModel.isLoading &&
                scrollNotification.metrics.pixels ==
                    scrollNotification.metrics.maxScrollExtent) {
              hallOfFameModel.loadHallOfFames();
            }

            return true;
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _selectedMode == 1
                  ? _buildLatestReviews(latestReviews)
                  : _buildHallOfFames(hallOfFames),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLatestReviews(latestReviews) {
    final _scrollController = context.watch<HallOfFameModel>().scrollController;

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          await context.read<ReviewModel>().clear();
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
                        Navigator.push(context, buildCourseDetailPageRoute());
                      },
                    );
                  },
                  childCount: latestReviews.length,
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                const Padding(
                  padding: EdgeInsets.only(top: 4.0, bottom: 12.0),
                  child: Center(
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

  Widget _buildHallOfFames(hallOfFames) {
    final _scrollController = context.watch<HallOfFameModel>().scrollController;

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
                        Navigator.push(context, buildCourseDetailPageRoute());
                      },
                    );
                  },
                  childCount: hallOfFames.length,
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                const Padding(
                  padding: EdgeInsets.only(top: 4.0, bottom: 12.0),
                  child: Center(
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
