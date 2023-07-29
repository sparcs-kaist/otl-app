import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/url.dart';
import 'package:otlplus/dio_provider.dart';
import 'package:otlplus/extensions/lecture.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/models/review.dart';

class ReviewWriteBlock extends StatefulWidget {
  final Lecture lecture;
  final Review? existingReview;
  final bool isSimple;
  final void Function(Review)? onUploaded;

  ReviewWriteBlock(
      {required this.lecture,
      this.existingReview,
      this.isSimple = false,
      this.onUploaded});

  @override
  _ReviewWriteBlockState createState() => _ReviewWriteBlockState();
}

class _ReviewWriteBlockState extends State<ReviewWriteBlock> {
  final _scores = {
    "성적": 0,
    "널널": 0,
    "강의": 0,
  };
  final _contentTextController = TextEditingController();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();

    if (widget.existingReview != null) {
      _scores["성적"] = widget.existingReview!.grade;
      _scores["널널"] = widget.existingReview!.load;
      _scores["강의"] = widget.existingReview!.speech;
      _contentTextController.text = widget.existingReview!.content;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _contentTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: OTLColor.grayE,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 8.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (!widget.isSimple)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(fontSize: 12.0),
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.lecture.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: " "),
                      TextSpan(text: widget.lecture.professorsStrShort),
                      const TextSpan(text: " "),
                      TextSpan(text: widget.lecture.year.toString()),
                      TextSpan(
                          text: [
                        " ",
                        " 봄",
                        " 여름",
                        " 가을",
                        " 겨울",
                      ][widget.lecture.semester]),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(
                top: 4.0,
                bottom: 8.0,
              ),
              child: DottedBorder(
                color: const Color(0xFFAAAAAA),
                child: SizedBox(
                  height: 140,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      controller: _contentTextController,
                      maxLines: null,
                      style: const TextStyle(
                        color: const Color(0xFF555555),
                        height: 1.25,
                        fontSize: 12.0,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                        hintText: "학점, 로드 등의 평가에 대하여 설명해주세요.",
                        hintStyle: TextStyle(
                          color: Color(0xFFAAAAAA),
                          height: 1.25,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _buildScore("성적"),
            _buildScore("널널"),
            _buildScore("강의"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _canUpload() ? _uploadReview : null,
                    child: Text(
                      (widget.existingReview == null) ? "업로드" : "수정",
                      style: TextStyle(
                        color: _canUpload()
                            ? OTLColor.pinksMain
                            : const Color(0xFF555555),
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
    );
  }

  bool _canUpload() {
    if (_isUploading) return false;
    if ((_scores["성적"] ?? -1) > 0 &&
        (_scores["널널"] ?? -1) > 0 &&
        (_scores["강의"] ?? -1) > 0 &&
        _contentTextController.text.isNotEmpty) {
      if (widget.existingReview != null) {
        return widget.existingReview?.content != _contentTextController.text ||
            _scores["성적"] != widget.existingReview?.grade ||
            _scores["널널"] != widget.existingReview?.load ||
            _scores["강의"] != widget.existingReview?.speech;
      }
      return true;
    }
    return false;
  }

  Future<void> _uploadReview() async {
    setState(() {
      _isUploading = true;
    });

    Response response;

    if (widget.existingReview == null) {
      response = await DioProvider().dio.post(API_REVIEW_URL, data: {
        "lecture": widget.lecture.id,
        "content": _contentTextController.text,
        "grade": _scores["성적"],
        "load": _scores["널널"],
        "speech": _scores["강의"],
      });
    } else {
      response = await DioProvider().dio.patch(
          API_REVIEW_URL + "/" + widget.existingReview!.id.toString(),
          data: {
            "content": _contentTextController.text,
            "grade": _scores["성적"],
            "load": _scores["널널"],
            "speech": _scores["강의"],
          });
    }

    final review = Review.fromJson(response.data);
    widget.onUploaded!(review);

    setState(() {
      _isUploading = false;
    });
  }

  Widget _buildScore(String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: <Widget>[
          Text(type, style: const TextStyle(fontSize: 12.0)),
          _buildOption(type, 5),
          _buildOption(type, 4),
          _buildOption(type, 3),
          _buildOption(type, 2),
          _buildOption(type, 1),
        ],
      ),
    );
  }

  Widget _buildOption(String type, int score) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: ClipOval(
        child: Container(
          width: 18.0,
          height: 18.0,
          color: (_scores[type] == score)
              ? const Color(0xFF868686)
              : const Color(0xFFD6D6D6),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _scores[type] = (_scores[type] == score) ? 0 : score;
                });
              },
              child: Center(
                child: Text(
                  ["?", "F", "D", "C", "B", "A"][score],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
