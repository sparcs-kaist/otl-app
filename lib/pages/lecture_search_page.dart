import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/providers/lecture_search_model.dart';
import 'package:otlplus/providers/timetable_model.dart';
import 'package:otlplus/utils/build_app_bar.dart';
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
    return Scaffold(
      backgroundColor: pinksLight,
      appBar: buildAppBar(context, '', true, false),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          children: <Widget>[
            Flexible(
              child: Column(
                children: [
                  SearchTextfield(
                    autoFocus: widget.openKeyboard,
                    backgroundColor: grayF,
                    textController: _searchTextController,
                    focusNode: _focusNode,
                  ),
                  const SizedBox(height: 16.0),
                  Flexible(
                    child: SearchFilterPanel(
                      filter: context.watch<LectureSearchModel>().lectureFilter,
                      setFilter: context
                          .read<LectureSearchModel>()
                          .setLectureFilterSelected,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      _searchTextController.clear();
                      context.read<LectureSearchModel>().resetLectureFilter();
                      _focusNode.requestFocus();
                    },
                    child: Text(
                      "초기화",
                      style: bodyBold.copyWith(color: pinksMain),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(grayF),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: FilledButton(
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (await context
                          .read<LectureSearchModel>()
                          .lectureSearch(
                            context.read<TimetableModel>().selectedSemester,
                          ))
                        Navigator.of(context).pop();
                      else
                        _focusNode.requestFocus();
                    },
                    child: Text("검색", style: bodyBold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
