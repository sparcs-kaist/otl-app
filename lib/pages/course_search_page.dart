import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/providers/course_search_model.dart';
import 'package:otlplus/utils/build_app_bar.dart';
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: appBarPadding(
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.navigate_before),
            ),
            Expanded(
              child: SearchTextfield(
                autoFocus:
                    _searchTextController.text == '' && widget.openKeyboard,
                backgroundColor: OTLColor.grayF,
                textController: _searchTextController,
                focusNode: _focusNode,
              ),
            ),
          ],
        ),
      ),
      flexibleSpace: SafeArea(child: Container(color: OTLColor.pinksMain, height: 5.0)),
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
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: SearchFilterPanel(
                      filter: context.watch<CourseSearchModel>().courseFilter,
                      setFilter: context
                          .read<CourseSearchModel>()
                          .setCourseFilterSelected,
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
                      context.read<CourseSearchModel>().resetCourseFilter();
                      _focusNode.requestFocus();
                    },
                    child: Text(
                      "초기화",
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
                          .read<CourseSearchModel>()
                          .courseSearch()) {
                        Navigator.of(context).pop();
                      } else {
                        _focusNode.requestFocus();
                      }
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
