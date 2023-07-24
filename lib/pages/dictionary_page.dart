import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/utils/build_page_route.dart';
import 'package:otlplus/providers/course_detail_model.dart';
import 'package:otlplus/providers/course_search_model.dart';
import 'package:otlplus/widgets/course_block.dart';
import 'package:provider/provider.dart';

class DictionaryPage extends StatefulWidget {
  static String route = 'dictionary_page';

  const DictionaryPage({Key? key}) : super(key: key);

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final searchModel = context.watch<CourseSearchModel>();

    return Container(
      color: grayF,
      child: Builder(
        builder: (context) {
          if (searchModel.isSearching) {
            return const Center(child: CircularProgressIndicator());
          } else if (searchModel.courses == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "OTL PLUS",
                    style: bodyBold.copyWith(color: grayA),
                  ),
                  Text(
                    "otlplus@sparcs.org",
                    style: bodyRegular.copyWith(color: grayA),
                  ),
                  Text(
                    "© 2016, SPARCS OTL Team",
                    style: bodyRegular.copyWith(color: grayA),
                  )
                ],
              ),
            );
          } else if (searchModel.courses!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "검색결과가 없습니다.",
                    style: bodyRegular.copyWith(color: grayA),
                  ),
                ],
              ),
            );
          } else {
            return Scrollbar(
              controller: _scrollController,
              child: ListView.separated(
                controller: _scrollController,
                padding: EdgeInsets.all(12.0),
                itemCount: searchModel.courses?.length ?? 0,
                itemBuilder: (context, index) => CourseBlock(
                  course: searchModel.courses![index],
                  onTap: () {
                    context
                        .read<CourseDetailModel>()
                        .loadCourse(searchModel.courses![index].id);
                    Navigator.push(context, buildCourseDetailPageRoute());
                  },
                ),
                separatorBuilder: (context, index) => SizedBox(height: 8.0),
              ),
            );
          }
        },
      ),
    );
  }
}
