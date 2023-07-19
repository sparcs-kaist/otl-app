import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/providers/lecture_search_model.dart';
import 'package:otlplus/providers/timetable_model.dart';
import 'package:otlplus/widgets/base_scaffold.dart';
import 'package:otlplus/widgets/search_filter_panel.dart';
import 'package:otlplus/widgets/search_textfield.dart';
import 'package:provider/provider.dart';

class LectureSearchPage extends StatefulWidget {
  final bool openKeyboard;
  const LectureSearchPage({Key? key, this.openKeyboard = false})
      : super(key: key);

  @override
  State<LectureSearchPage> createState() => _LectureSearchPageState();
}

class _LectureSearchPageState extends State<LectureSearchPage> {
  final _searchTextController = TextEditingController();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _searchTextController.text =
        context.read<LectureSearchModel>().lectureSearchText;
    _searchTextController.addListener(() {
      context
          .read<LectureSearchModel>()
          .setLectureSearchText(_searchTextController.text);
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
    return BaseScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Column(
                children: [
                  SearchTextfield(
                    autoFocus: widget.openKeyboard,
                    textController: _searchTextController,
                    focusNode: _focusNode,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Flexible(
                    child: SearchFilterPanel(
                      filter: context.watch<LectureSearchModel>().lectureFilter,
                      setFilter: context
                          .read<LectureSearchModel>()
                          .setLectureFilterSelected,
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
                              .read<LectureSearchModel>()
                              .resetLectureFilter();
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
                              .read<LectureSearchModel>()
                              .lectureSearch(
                                context.read<TimetableModel>().selectedSemester,
                              ))
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
        // context.read<LectureSearchModel>().lectureClear();
      },
      resizeToAvoidBottomInset: false,
      sheetBackgroundColor: BACKGROUND_COLOR,
    );
  }
}
