import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlplus/constants/color.dart';
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
        color: OTLColor.grayF,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/search.svg',
              height: 24.0,
              width: 24.0,
              colorFilter:
                  ColorFilter.mode(OTLColor.pinksMain, BlendMode.srcIn)),
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
                hintStyle: bodyRegular.copyWith(color: OTLColor.grayA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
