import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/providers/lecture_search_model.dart';
import 'package:otlplus/providers/timetable_model.dart';
import 'package:otlplus/utils/build_app_bar.dart';
import 'package:otlplus/widgets/responsive_button.dart';
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: appBarPadding(
        Row(
          children: [
            IconTextButton(
              onTap: () => Navigator.pop(context),
              icon: Icons.navigate_before,
              padding: EdgeInsets.fromLTRB(0, 16, 16, 16),
            ),
            Expanded(
              child: SearchTextfield(
                autoFocus: widget.openKeyboard,
                backgroundColor: OTLColor.grayF,
                textController: _searchTextController,
                focusNode: _focusNode,
              ),
            ),
          ],
        ),
      ),
      flexibleSpace:
          SafeArea(child: Container(color: OTLColor.pinksMain, height: 5.0)),
      toolbarHeight: kToolbarHeight + 5.0,
      backgroundColor: OTLColor.pinksLight,
      foregroundColor: OTLColor.gray0,
      elevation: 0.0,
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OTLColor.pinksLight,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          children: <Widget>[
            Flexible(
              child: Column(
                children: [
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
                    },
                    child: Text(
                      "common.reset_all".tr(),
                      style: bodyBold.copyWith(color: OTLColor.pinksMain),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(OTLColor.grayF),
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
                    child: Text("common.search".tr(), style: bodyBold),
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
