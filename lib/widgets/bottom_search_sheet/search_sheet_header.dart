import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/providers/bottom_sheet_model.dart';
import 'package:provider/provider.dart';
import 'package:sheet/sheet.dart';

class SearchSheetHeader extends StatefulWidget {
  SearchSheetHeader({
    Key? key, 
    required this.focusNode,
    required this.textController
  }) : super(key: key);
  final TextEditingController textController;
  late FocusNode focusNode;

  @override
  State<SearchSheetHeader> createState() => _SearchSheetHeaderState();
}

class _SearchSheetHeaderState extends State<SearchSheetHeader> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      
      onTap: widget.focusNode.hasFocus ? null : () {
        context.read<BottomSheetModel>().scrollController.relativeAnimateTo(
          1,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        )
        .then(
          (_) {
            widget.focusNode.requestFocus();
          }
        );
      },
      child: SizedBox(
        height: 68,
        child: Column(
          children: [
            SizedBox(
              height: 7,
            ),
            _sheetHandle(),
            Flexible(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 7, 24 ,14),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: widget.textController,
                          focusNode: widget.focusNode,
                          onSubmitted: (value) {
                            print(value);
                          },
                          style: const TextStyle(fontSize: 15.0),
                          decoration:  InputDecoration(
                            suffixIconColor: Colors.black45,
                            hintText: "과목명, 교수님 성함 등을 검색해 보세요",
                            hintStyle: TextStyle(color: Colors.black54),
                            icon: Icon(
                              Icons.search,
                              color: Color(0xFFD45869),
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}



Widget _sheetHandle() {
  return SizedBox(
    height: 4,
    child: Center(
      child: Container(
        width: 40,
        height: 4,
        // clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    ),
  );
}