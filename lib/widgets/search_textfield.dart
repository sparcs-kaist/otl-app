import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/icon.dart';
import 'package:otlplus/constants/text_styles.dart';

class SearchTextfield extends StatefulWidget {
  const SearchTextfield({
    Key? key,
    this.textController,
    this.focusNode,
    this.backgroundColor,
    this.autoFocus = false,
  }) : super(key: key);
  final TextEditingController? textController;
  final FocusNode? focusNode;
  final Color? backgroundColor;
  final bool? autoFocus;

  @override
  State<SearchTextfield> createState() => _SearchTextfieldState();
}

class _SearchTextfieldState extends State<SearchTextfield> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: grayF,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          Icon(CustomIcons.search, color: pinksMain, size: 24.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: TextField(
              autofocus: widget.autoFocus ?? false,
              controller: widget.textController,
              focusNode: widget.focusNode,
              onSubmitted: (value) {
                widget.focusNode?.unfocus();
              },
              style: bodyRegular,
              decoration: InputDecoration(
                hintText: "과목명, 교수님 성함 등을 검색해 보세요.",
                hintStyle: bodyRegular.copyWith(color: grayA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
