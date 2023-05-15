import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/providers/hall_of_fame_model.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/providers/course_detail_model.dart';
import 'package:otlplus/providers/review_model.dart';
import 'package:otlplus/widgets/backdrop.dart';
import 'package:otlplus/widgets/review_block.dart';

class ReviewPage extends StatefulWidget {
  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _scrollController = ScrollController();
  int _selectedIndex = 0;
  int _initialYear = DateTime.now().year - (DateTime.now().month < 7 ? 1 : 0);
  int _initialSemester = DateTime.now().month < 7 ? 3 : 1;
  int _selectedYear = DateTime.now().year - (DateTime.now().month < 7 ? 1 : 0);
  int _selectedSemester = DateTime.now().month < 7 ? 3 : 1;

  @override
  Widget build(BuildContext context) {
    final latestReviews = context.watch<ReviewModel>().reviews;
    final hallOfFames = context
        .watch<HallOfFameModel>()
        .hallOfFames(_selectedYear, _selectedSemester);

    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (_selectedIndex == 0) {
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
              hallOfFameModel.loadHallOfFames(_selectedYear, _selectedSemester);
            }

            return true;
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildTab(),
              const SizedBox(height: 8.0),
              _selectedIndex == 0 ? SizedBox() : _buildSemesterButton(),
              const SizedBox(height: 8.0),
              _selectedIndex == 0
                  ? _buildLatestReviews(latestReviews)
                  : _buildHallOfFames(hallOfFames),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              setState(() {
                _scrollController.jumpTo(0);
                _selectedIndex = 0;
              });
            },
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                StadiumBorder(),
              ),
              backgroundColor: _selectedIndex == 0
                  ? MaterialStatePropertyAll(PRIMARY_COLOR)
                  : null,
            ),
            child: Text(
              "따끈따끈 과목후기",
              style: TextStyle(
                color: _selectedIndex == 0 ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                StadiumBorder(),
              ),
              backgroundColor: _selectedIndex == 1
                  ? MaterialStatePropertyAll(PRIMARY_COLOR)
                  : null,
            ),
            onPressed: () {
              setState(() {
                _scrollController.jumpTo(0);
                _selectedIndex = 1;
              });
            },
            child: Text(
              "명예의 전당",
              style: TextStyle(
                color: _selectedIndex == 1 ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSemesterButton() {
    int length = (_initialYear - 2013) * 2 + (_initialSemester == 1 ? 1 : 2);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
      child: Row(
        children: List.generate(
          length,
          (index) {
            int _year = (2013 + index / 2).toInt();
            int _semester = index % 2 == 0 ? 1 : 3;
            bool _isSelected =
                _selectedYear == _year && _selectedSemester == _semester;

            return Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedYear = _year;
                      _selectedSemester = _semester;
                      context
                          .read<HallOfFameModel>()
                          .clear(_selectedYear, _selectedSemester);
                    });
                  },
                  child: Text(
                    '$_year ${_semester == 1 ? 'Spring' : 'Fall'}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _isSelected ? PRIMARY_COLOR : Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      _isSelected
                          ? PRIMARY_COLOR.withOpacity(0.2)
                          : Colors.grey.shade200,
                    ),
                    shape: MaterialStatePropertyAll(
                      StadiumBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            );
          },
        ).reversed.toList(),
      ),
    );
  }

  Widget _buildLatestReviews(latestReviews) {
    return Expanded(
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
                      review: latestReviews[index],
                      onTap: () async {
                        context
                            .read<CourseDetailModel>()
                            .loadCourse(latestReviews[index].course.id);
                        Backdrop.of(context).show(1);
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

  Widget _buildHallOfFames(hallOfFames) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          await context
              .read<HallOfFameModel>()
              .clear(_selectedYear, _selectedSemester);
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
                      review: hallOfFames[index],
                      onTap: () async {
                        context
                            .read<CourseDetailModel>()
                            .loadCourse(hallOfFames[index].course.id);
                        Backdrop.of(context).show(1);
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
