import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/constants/url.dart';
import 'package:timeplanner_mobile/dio_provider.dart';
import 'package:timeplanner_mobile/models/course.dart';
import 'package:timeplanner_mobile/providers/course_detail_model.dart';
import 'package:timeplanner_mobile/providers/review_model.dart';
import 'package:timeplanner_mobile/widgets/backdrop.dart';
import 'package:timeplanner_mobile/widgets/review_block.dart';

class ReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final reviews = context.watch<ReviewModel>().reviews;

    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          final reviewModel = context.read<ReviewModel>();

          if (!reviewModel.isLoading &&
              scrollNotification.metrics.pixels ==
                  scrollNotification.metrics.maxScrollExtent) {
            reviewModel.loadReviews();
          }
          return null;
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
          child: Column(
            children: <Widget>[
              Text(
                "따끈따끈 과목후기",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await context.read<ReviewModel>().clear();
                  },
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (context, index) => ReviewBlock(
                        review: reviews[index],
                        onTap: () async {
                          final response = await DioProvider().dio.get(
                              API_COURSE_URL +
                                  "/" +
                                  reviews[index].course.id.toString());
                          context
                              .read<CourseDetailModel>()
                              .loadCourse(Course.fromJson(response.data));
                          Backdrop.of(context).show(1);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
