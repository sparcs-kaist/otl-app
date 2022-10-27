import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    Key? key,
    this.maxLines = 5,
    this.style,
  }) : super(key: key);

  final String text;
  final int maxLines;
  final TextStyle? style;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    TextSpan expandButton = TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: "..",
          style: widget.style,
        ),
        TextSpan(
            text: " 더보기",
            style:
                (widget.style ?? TextStyle()).copyWith(color: Colors.black45),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                setState(() => _expanded = true);
              })
      ],
    );
    String shortenText =
        widget.text.replaceAll('\r\n\r\n', '\r\n').replaceAll('\n\n', '\r\n');
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        TextPainter textPainter = TextPainter(
          text: TextSpan(text: ""),
          textDirection: TextDirection.rtl,
          maxLines: widget.maxLines,
        );
        textPainter.text = TextSpan(
          text: shortenText,
          style: widget.style,
        );
        textPainter.layout(
            minWidth: constraints.minWidth, maxWidth: constraints.maxWidth);
        final textSize = textPainter.size;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width,
          textSize.height,
        ));
        int endIndex = textPainter.getOffsetBefore(pos.offset) ?? 1024;
        final textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _expanded
                ? widget.text
                : shortenText.substring(0, endIndex - 8).trim(),
            style: widget.style,
            children: _expanded ? null : <TextSpan>[expandButton],
          );
        } else {
          textSpan = TextSpan(
            text: widget.text,
            style: widget.style,
          );
        }
        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );
    return result;
  }
}
