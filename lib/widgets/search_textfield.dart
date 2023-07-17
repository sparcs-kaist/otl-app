import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/icon.dart';

class SearchTextfield extends StatefulWidget {
  const SearchTextfield({
    Key? key,
    this.textController,
    this.focusNode,
    this.backgroundColor,
  }) : super(key: key);
  final TextEditingController? textController;
  final FocusNode? focusNode;
  final Color? backgroundColor;

  @override
  State<SearchTextfield> createState() => _SearchTextfieldState();
}

class _SearchTextfieldState extends State<SearchTextfield> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: ColoredBox(
        color: widget.backgroundColor ?? Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: SizedBox(
            height: 24,
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Center(
                      child: Icon(
                        CustomIcons.search,
                        color: PRIMARY_COLOR,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    flex: 1,
                    child: TextField(
                      controller: widget.textController,
                      focusNode: widget.focusNode,
                      onSubmitted: (value) {
                        widget.focusNode?.unfocus();
                      },
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                      decoration: InputDecoration(
                        suffixIconColor: Colors.black45,
                        hintText: "과목명, 교수님 성함 등을 검색해 보세요",
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
