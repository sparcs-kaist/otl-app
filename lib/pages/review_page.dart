import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/providers/course_detail_model.dart';
import 'package:otlplus/providers/review_model.dart';
import 'package:otlplus/widgets/backdrop.dart';
import 'package:otlplus/widgets/review_block.dart';

class ReviewPage extends StatelessWidget {
  final _scrollController = ScrollController();

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
          return true;
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
    );
  }
}
