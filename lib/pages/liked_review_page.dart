import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/pages/course_detail_page.dart';
import 'package:otlplus/providers/course_detail_model.dart';
import 'package:otlplus/providers/info_model.dart';
import 'package:otlplus/providers/liked_review_model.dart';
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
      appBar: _buildAppBar(context),
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
                                      // Backdrop.of(context).show(1);
                                      Navigator.push(
                                        context,
                                        _buildCourseDetailPageRoute(),
                                      );
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Theme(
        data: Theme.of(context).copyWith(
            appBarTheme: AppBarTheme(
          color: BACKGROUND_COLOR,
          elevation: 0.0,
          actionsIconTheme: IconThemeData(
            color: CONTENT_COLOR,
          ),
        )),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            '좋아요한 후기',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          centerTitle: true,
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Container(
                  color: PRIMARY_COLOR,
                  height: 5,
                ),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
        ),
      ),
    );
  }

  Route _buildCourseDetailPageRoute() {
    return PageRouteBuilder(
      pageBuilder: (_, animation, __) => CourseDetailPage(),
      transitionsBuilder: (_, animation, __, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final curveTween = CurveTween(curve: Curves.ease);
        final tween = Tween(begin: begin, end: end).chain(curveTween);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}