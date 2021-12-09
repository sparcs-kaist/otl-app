import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/url.dart';
import 'package:otlplus/dio_provider.dart';
import 'package:otlplus/extensions/review.dart';
import 'package:otlplus/models/review.dart';

class ReviewBlock extends StatefulWidget {
  final Review review;
  final VoidCallback? onTap;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isSimple;

  ReviewBlock(
      {required this.review,
      this.onTap,
      this.maxLines,
      this.overflow,
      this.isSimple = false});

  @override
  _ReviewBlockState createState() => _ReviewBlockState();
}

class _ReviewBlockState extends State<ReviewBlock> {
  late int _like;
  late bool _canUpload;

  @override
  void initState() {
    super.initState();
    _like = widget.review.like;
    _canUpload = !widget.review.userspecificIsLiked;
  }

  @override
  Widget build(BuildContext context) {
    String content = widget.isSimple
        ? widget.review.content.replaceAll("\r\n", " ").replaceAll("\n", " ")
        : widget.review.content;
    while (content.contains("  ")) content = content.replaceAll("  ", " ");

    return Container(
      margin: const EdgeInsets.only(bottom: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: BLOCK_COLOR,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4.0),
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (!widget.isSimple) ...[
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(fontSize: 12.0),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.review.lecture.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: " "),
                        TextSpan(
                            text: widget.review.lecture.professors
                                .map((professor) => professor.name)
                                .join(" ")),
                        const TextSpan(text: " "),
                        TextSpan(text: widget.review.lecture.year.toString()),
                        TextSpan(
                            text: [
                          " ",
                          " 봄",
                          " 여름",
                          " 가을",
                          " 겨울",
                        ][widget.review.lecture.semester]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4.0),
                ],
                Text(
                  content.trim(),
                  maxLines: widget.maxLines,
                  overflow: widget.overflow,
                  style: const TextStyle(
                    color: const Color(0xFF555555),
                    height: 1.25,
                    fontSize: 12.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: widget.isSimple
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: <Widget>[
                    Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          height: 1.6,
                          fontSize: 12.0,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: "추천 "),
                          TextSpan(
                            text: _like.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: "  성적 "),
                          TextSpan(
                            text: widget.review.gradeLetter,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: "  널널 "),
                          TextSpan(
                            text: widget.review.loadLetter,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: "  강의 "),
                          TextSpan(
                            text: widget.review.speechLetter,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (!widget.isSimple) ...[
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _canUpload ? _uploadLike : null,
                          child: Text(
                            "좋아요",
                            style: TextStyle(
                              color: const Color(0xFFAAAAAA),
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _report,
                          child: Text(
                            "신고하기",
                            style: TextStyle(
                              color: const Color(0xFFAAAAAA),
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _uploadLike() async {
    setState(() {
      _like++;
      _canUpload = false;
    });

    await DioProvider().dio.post(
        API_REVIEW_LIKE_URL.replaceFirst("{id}", widget.review.id.toString()),
        data: {});
  }

  void _report() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('안내'),
              content: Text(
                  '이 기능은 현재 개발중입니다. 부적절한 후기는 otlplus@sparcs.org로 신고해 주세요.'),
              actions: <Widget>[
                new TextButton(
                  child: new Text("확인"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }
}
