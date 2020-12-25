import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/providers/review_model.dart';
import 'package:timeplanner_mobile/widgets/review_block.dart';

class ReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
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
                const SizedBox(height: 10.0),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await context.read<ReviewModel>().clear();
                    },
                    child: Scrollbar(
                      child: ListView(
                        children: context.select<ReviewModel, List<Widget>>(
                            (model) => model.reviews
                                .map((review) => ReviewBlock(review: review))
                                .toList()),
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
