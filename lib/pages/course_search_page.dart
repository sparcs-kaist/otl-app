import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/providers/course_search_model.dart';
import 'package:otlplus/widgets/base_layout.dart';
import 'package:otlplus/widgets/search_filter_panel.dart';
import 'package:otlplus/widgets/search_textfield.dart';
import 'package:provider/provider.dart';

class CourseSearchPage extends StatefulWidget {
  final bool openKeyboard;
  const CourseSearchPage({Key? key, this.openKeyboard = false})
      : super(key: key);

  @override
  State<CourseSearchPage> createState() => _CourseSearchPageState();
}

class _CourseSearchPageState extends State<CourseSearchPage> {
  final _searchTextController = TextEditingController();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _searchTextController.text =
        context.read<CourseSearchModel>().courseSearchText;
    _searchTextController.addListener(() {
      context
          .read<CourseSearchModel>()
          .setCourseSearchText(_searchTextController.text);
    });
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: OTL_LIGHTPINK,
        child: SafeArea(
          minimum: EdgeInsets.only(bottom: 16),
          top: true,
          maintainBottomViewPadding: true,
          child: BaseLayout(
            enableBackButton: true,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      children: [
                        SearchTextfield(
                          autoFocus: _searchTextController.text == '' &&
                              widget.openKeyboard,
                          backgroundColor: Colors.white,
                          textController: _searchTextController,
                          focusNode: _focusNode,
                        ),
                        SizedBox(height: 16),
                        Flexible(
                          child: SearchFilterPanel(
                            filter:
                                context.watch<CourseSearchModel>().courseFilter,
                            setFilter: context
                                .read<CourseSearchModel>()
                                .setCourseFilterSelected,
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            child: GestureDetector(
                              onTap: () {
                                _searchTextController.clear();
                                context
                                    .read<CourseSearchModel>()
                                    .resetCourseFilter();
                                _focusNode.requestFocus();
                              },
                              child: ColoredBox(
                                color: Color(0xFFFFFFFF),
                                child: Center(
                                  child: Text(
                                    "초기화",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: PRIMARY_COLOR,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Flexible(
                          flex: 1,
                          child: ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            child: GestureDetector(
                              onTap: () async {
                                if (await context
                                    .read<CourseSearchModel>()
                                    .courseSearch())
                                  Navigator.of(context).pop();
                                else
                                  _focusNode.requestFocus();
                              },
                              child: ColoredBox(
                                color: PRIMARY_COLOR,
                                child: Center(
                                  child: Text(
                                    "검색",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            onBack: () {
              // context.read<CourseSearchModel>().courseClear();
            },
            sheetBackgroundColor: BACKGROUND_COLOR,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
