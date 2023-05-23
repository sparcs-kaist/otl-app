import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/providers/lecture_search_model.dart';
import 'package:otlplus/utils/build_page_route.dart';
import 'package:provider/provider.dart';

class TimetableTabs extends StatefulWidget {
  final int index;
  final int length;
  final Function(int) onTap;
  final VoidCallback onCopyTap;
  final VoidCallback onDeleteTap;
  final Function(int, int) onReorder;

  TimetableTabs(
      {this.index = 0,
      required this.length,
      required this.onTap,
      required this.onCopyTap,
      required this.onDeleteTap,
      required this.onReorder});

  @override
  _TimetableTabsState createState() => _TimetableTabsState();
}

class _TimetableTabsState extends State<TimetableTabs> {
  int _index = 0;
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _index = widget.index;

    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        scrollController: _scrollController,
        proxyDecorator: (child, _, animation) => AnimatedBuilder(
          animation: animation,
          builder: (_, child) => Material(
            elevation: 0,
            color: Colors.transparent,
            child: child,
          ),
          child: child,
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: widget.length - 1,
        itemBuilder: (context, i) => _buildTab(i + 1, context, Key(i.toString())), 
        header: _buildTab(0, context, Key('header')),
        footer: _buildTab(widget.length, context, Key('footer')),
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          widget.onReorder(oldIndex + 1, newIndex + 1);
        },
      ),
    );
    /*return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(
                  widget.length + 1, (i) => _buildTab(i, context)),
            ),
          ),
        ),
        _buildButton(Icons.search, () {
          context.read<LectureSearchModel>().resetLectureFilter();
          Navigator.of(context).push(buildLectureSearchPageRoute());
        }),
        _buildButton(Icons.playlist_add, widget.onAddTap),
        _buildButton(Icons.settings, widget.onSettingsTap),
      ],
    );*/
  }

  /*Widget _buildButton(IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(left: 8.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 7.0,
            ),
            child: Icon(
              icon,
              size: 20.0,
            ),
          ),
        ),
      ),
    );
  }*/

  Widget _buildTab(int i, BuildContext context, Key key) {
    return Card(
      key: key,
      color: i == _index ? PRIMARY_COLOR : BACKGROUND_COLOR,
      margin: EdgeInsets.only(right: i == widget.length ? 0.0 : 8.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(i == widget.length ? 15.0 : 20.0)),
      ),
      child: Material(
        color: Colors.transparent,
        child: () {
          if (i == _index) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 9.5),
              height: 30,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4.5, 0, 7.5, 0),
                    child: Text(
                      i == 0 ? "내 시간표" : "시간표 $i",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onCopyTap,
                    behavior: HitTestBehavior.translucent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4.5),
                      child: SvgPicture.asset(
                        'assets/icons/icon_copy_tab.svg',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (widget.length > 2 && i != 0) ? widget.onDeleteTap : null,
                    behavior: HitTestBehavior.translucent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4.5),
                      child: SvgPicture.asset(
                        'assets/icons/icon_remove_tab.svg',
                        color: Colors.white.withOpacity((widget.length > 2 && i != 0) ? 1 : 0.5),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if (i == widget.length) {
            return InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              onTap: () {
                setState(() {
                  _index = i;
                  widget.onTap(i);
                });
                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);//, duration: Duration(milliseconds: 100), curve: Curves.ease);
              },
              child: Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/icons/icon_add_tab.svg',
                ),
              ),
            );
          } else {
            return InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              onTap: () {
                setState(() {
                  _index = i;
                  widget.onTap(i);
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 30,
                child: Text(
                  i == 0 ? "내 시간표" : "시간표 $i",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ),
            );
          }
        }(),
      ),
    );
  }
}
