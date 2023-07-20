import 'package:flutter/material.dart';
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
      color: Colors.white,
      child: Builder(
        builder: (context) {
          if (searchModel.isSearching) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          } else if (searchModel.courses == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("OTL PLUS",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFAAAAAA))),
                  Text("otlplus@sparcs.org",
                      style: TextStyle(fontSize: 12, color: Color(0xFFAAAAAA))),
                  Text("© 2016, SPARCS OTL Team",
                      style: TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)))
                ],
              ),
            );
          } else if (searchModel.courses!.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("검색결과가 없습니다.",
                      style: TextStyle(
                          fontSize: 14,
                          // fontWeight: FontWeight.bold,
                          color: Color(0xFFAAAAAA))),
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
                    }),
                separatorBuilder: (context, index) => SizedBox(height: 8.0),
              ),
            );
          }
        },
      ),
    );
  }
}
