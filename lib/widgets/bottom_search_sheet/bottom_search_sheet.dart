import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/widgets/bottom_search_sheet/search_sheet_body.dart';
import 'package:otlplus/widgets/bottom_search_sheet/search_sheet_header.dart';
import 'package:otlplus/providers/search_model.dart';
import 'package:otlplus/widgets/bottom_search_sheet/search_sheet_result.dart';
import 'package:sheet/sheet.dart';

import 'package:provider/provider.dart';
import 'package:otlplus/providers/timetable_model.dart';


final Map<String, dynamic> defaultFilter = {
  "departments": {
    "label": "학과",
    "options": {
      "HSS": {"label": "인문", "selected": true},
      "CE": {"label": "건환", "selected": true},
      "MSB": {"label": "기경", "selected": true},
      "ME": {"label": "기계", "selected": true},
      "PH": {"label": "물리", "selected": true},
      "BiS": {"label": "바공", "selected": true},
      "IE": {"label": "산공", "selected": true},
      "ID": {"label": "산디", "selected": true},
      "BS": {"label": "생명", "selected": true},
      "CBE": {"label": "생화공", "selected": true},
      "MAS": {"label": "수리", "selected": true},
      "MS": {"label": "신소재", "selected": true},
      "NQE": {"label": "원양", "selected": true},
      "TS": {"label": "융인", "selected": true},
      "CS": {"label": "전산", "selected": true},
      "EE": {"label": "전자", "selected": true},
      "AE": {"label": "항공", "selected": true},
      "CH": {"label": "화학", "selected": true},
      "ETC": {"label": "기타", "selected": true},
    }
  },
  "types": {
    "label": "구분",
    "options": {
        "BR": {"label": "기필", "selected": true},
        "BE": {"label": "기선", "selected": true},
        "MR": {"label": "전필", "selected": true},
        "ME": {"label": "전선", "selected": true},
        "MGC": {"label": "교필", "selected": true},
        "HSE": {"label": "인선", "selected": true},
        "GR": {"label": "공통", "selected": true},
        "EG": {"label": "석박", "selected": true},
        "OE": {"label": "자선", "selected": true},
        "ETC": {"label": "기타", "selected": true},
    }
  },
  "levels": {
    "label": "학년",
    "options": {
      "100": {"label": "100", "selected": true},
      "200": {"label": "200", "selected": true},
      "300": {"label": "300", "selected": true},
      "400": {"label": "400", "selected": true},
    }
  },
};

class BottomSearchSheet extends StatefulWidget {
  const BottomSearchSheet({
    Key? key, 
  }) : super(key: key);

  @override
  State<BottomSearchSheet> createState() => _BottomSearchSheetState();
}

class _BottomSearchSheetState extends State<BottomSearchSheet> {
  SheetController _scrollController = SheetController();
  final _textController = TextEditingController();
  late FocusNode _focusNode;
  Map<String, dynamic> filter = defaultFilter;

  final double headerHeight = 68;
  final double contentHeight = 500;
  final Color? backgroundColor = OTL_LIGHTPINK;
  bool searched = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }
  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final searchModel = context.watch<SearchModel>();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Sheet(
          backgroundColor: backgroundColor,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          controller: _scrollController,
          physics: SnapSheetPhysics(
            relative: true,
            stops: <double>[headerHeight / (headerHeight + contentHeight), 1],
            parent: const BouncingSheetPhysics(
              overflowViewport: false,
            ),
          ),
          initialExtent: headerHeight,
          maxExtent: headerHeight + contentHeight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Focus(
                onFocusChange: (hasFocus) {
                  if(hasFocus) {
                    // showDialog(context: context, builder: (BuildContext bdx) {
                    //   return Container(
                    //     child: Text('hi'),
                    //   );
                    // });
                    _scrollController.relativeAnimateTo(
                      1,
                      duration: Duration(milliseconds: 128),
                      curve: Curves.ease
                    );
                    setState(() {
                      searched = false;
                    });
                  }
                },
                child: SearchSheetHeader(focusNode: _focusNode, textController: _textController)
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: searched
                  ? searchModel.isSearching
                    ? Center(
                        child: const CircularProgressIndicator(),
                      )
                    : SearchSheetResult(
                      result: searchModel.lectures
                    )
                  : SearchSheetBody(textController: _textController, 
                    filter: filter, 
                    setFilter: (division, option, value) {
                      setState(() {
                        filter[division]["options"][option]["selected"] = value;
                      });
                    },
                    onSumitted: () {
                      context.read<SearchModel>().lectureSearch(
                        context.read<TimetableModel>().selectedSemester,
                        _textController.text,
                        department: (filter["departments"]["options"] as Map).values.every((element) => element["selected"] == true) ? ["ALL"] : 
                          (filter["departments"]["options"] as Map).entries.where((element) => element.value["selected"] == true).map((e) => e.key as String).toList(),
                        type: (filter["types"]["options"] as Map).values.every((element) => element["selected"] == true) ? ["ALL"] :
                          (filter["types"]["options"] as Map).entries.where((element) => element.value["selected"] == true).map((e) => e.key as String).toList(),
                        level: (filter["levels"]["options"] as Map).values.every((element) => element["selected"] == true) ? ["ALL"] :
                          (filter["levels"]["options"] as Map).entries.where((element) => element.value["selected"] == true).map((e) => e.key as String).toList(),
                      );
                      setState(() {
                        searched = true;
                      });
                    }
                  )
              ),
            ],
          ),
        );
      }
    );
              // CustomScrollView(
              //   physics: ClampingScrollPhysics(),
              //   slivers: [
              //     SliverPersistentHeader(
              //       pinned: true,
              //       delegate: _HeaderDelegate(
              //         height: headerHeight,
              //         child: Focus(
              //           onFocusChange: (hasFocus) {
              //             if(hasFocus) {
              //               _scrollController.animateTo(
              //                 min(constraints.maxHeight - 64, headerHeight + contentHeight), 
              //                 duration: Duration(milliseconds: 40),
              //                 curve: Curves.easeInOutCubic
              //               );
              //             }
              //           },
              //           child: header
              //         ),
              //       ),
              //     ),
              //     SliverFillRemaining(
              //       child: content,
              //     )
              //   ],
              // ),
  }
}


// class _HeaderDelegate extends SliverPersistentHeaderDelegate {
//   const _HeaderDelegate({required this.child, required this.height});
//   final Widget child;
//   final double height;

//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return child;
//   }

//   @override
//   double get maxExtent => this.height;

//   @override
//   double get minExtent => this.height;

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
// }

// Map<String, Map<String, bool>> selectedOptions = {
  //   'departments': {
  //     "HSS": true,
  //     "CE": true,
  //     "MSB": true,
  //     "ME": true,
  //     "PH": true,
  //     "BiS": true,
  //     "IE": true,
  //     "ID": true,
  //     "BS": true,
  //     "CBE": true,
  //     "MAS": true,
  //     "MS": true,
  //     "NQE": true,
  //     "TS": true,
  //     "CS": true,
  //     "EE": true,
  //     "AE": true,
  //     "CH": true,
  //   },
  //   'types': {
  //     "BR": true,
  //     "BE": true,
  //     "MR": true,
  //     "ME": true,
  //     "MGC": true,
  //     "HSE": true,
  //     "GR": true,
  //     "EG": true,
  //     "OE": true,
  //   },
  //   'levels': {
  //     "100": true,
  //     "200": true,
  //     "300": true,
  //     "400": true,
  //   },
  // };