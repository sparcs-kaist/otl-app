import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/constants/url.dart';
import 'package:timeplanner_mobile/dio_provider.dart';
import 'package:timeplanner_mobile/models/review.dart';

class ReviewBlock extends StatefulWidget {
  final Review review;
  final VoidCallback onTap;
  final int maxLines;
  final TextOverflow overflow;
  final bool isSimple;

  ReviewBlock(
      {@required this.review,
      this.onTap,
      this.maxLines,
      this.overflow,
      this.isSimple = false});

  @override
  _ReviewBlockState createState() => _ReviewBlockState();
}

class _ReviewBlockState extends State<ReviewBlock> {
  int _like;
  bool _canUpload;

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
                            text: widget.review.lecture.professorsStrShort),
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
                    if (!widget.isSimple)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _canUpload ? _uploadLike : null,
                          child: Text(
                            "좋아요",
                            style: TextStyle(
                              color: _canUpload
                                  ? PRIMARY_COLOR
                                  : const Color(0xFFAAAAAA),
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
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

    await DioProvider().dio.post(API_REVIEW_LIKE_URL, data: {
      "reviewid": widget.review.id,
    });
  }
}
