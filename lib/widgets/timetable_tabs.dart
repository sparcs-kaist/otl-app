import 'package:dropdown_button2/dropdown_button2.dart';
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
  final Function(String) onExportTap;
  final Function(int, int) onReorder;

  TimetableTabs(
      {this.index = 0,
      required this.length,
      required this.onTap,
      required this.onCopyTap,
      required this.onDeleteTap,
      required this.onExportTap,
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
      height: 28,
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
        itemBuilder: (context, i) =>
            _buildTab(i + 1, context, Key(i.toString())),
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
    if (i == widget.length) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _index = i;
            widget.onTap(i);
          });
        },
        child: Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: BACKGROUND_COLOR,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SvgPicture.asset('assets/icons/icon_add_tab.svg'),
        ),
      );
    }

    Text text = Text(
      i == 0 ? "내 시간표" : "시간표 $i",
      style: TextStyle(
        fontSize: 14,
        height: 15 / 14,
        fontWeight: FontWeight.w700,
        color: i == _index ? Colors.white : Colors.black,
        letterSpacing: 0.15,
      ),
      textAlign: TextAlign.center,
    );

    if (i == _index) {
      bool canDelete = widget.length > 2 && i != 0;
      return Padding(
        key: key,
        padding: const EdgeInsets.only(right: 8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            customButton: Container(
              height: 28,
              padding: EdgeInsets.fromLTRB(12, 6, 8, 6),
              decoration: BoxDecoration(
                color: PRIMARY_COLOR,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                  text,
                  const SizedBox(width: 6),
                  SvgPicture.asset('assets/icons/icon_more.svg')
                ],
              ),
            ),
            items: [
              ...MenuItems.items.map(
                (item) => DropdownMenuItem<MenuItem>(
                  value: item,
                  child: MenuItems.buildItem(
                      item, !(canDelete) && item == MenuItems.items.last),
                ),
              ),
              if (canDelete)
                DropdownMenuItem<MenuItem>(
                  value: MenuItems.delete,
                  child: MenuItems.buildItem(MenuItems.delete, true),
                ),
            ],
            onChanged: (value) {
              switch (value) {
                case MenuItems.copy:
                  widget.onCopyTap();
                  break;
                case MenuItems.exportToImg:
                  widget.onExportTap('image');
                  break;
                case MenuItems.exportToCal:
                  widget.onExportTap('ical');
                  break;
                case MenuItems.syllabus:
                  // Pass
                  break;
                case MenuItems.delete:
                  widget.onDeleteTap();
                  break;
              }
            },
            dropdownStyleData: DropdownStyleData(
              width: 180,
              elevation: 0,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: DROPDOWN_COLOR,
              ),
              offset: const Offset(0, -8),
            ),
            menuItemStyleData: MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      );
    }

    return Container(
      key: key,
      height: 28,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: BACKGROUND_COLOR,
        borderRadius: BorderRadius.circular(20),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _index = i;
            widget.onTap(i);
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: text,
        ),
      ),
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> items = [
    copy,
    exportToImg,
    exportToCal,
    //syllabus,
  ];

  static const copy = MenuItem(text: '시간표 복제하기', icon: Icons.copy);
  static const exportToImg =
      MenuItem(text: '이미지로 내보내기', icon: Icons.image_outlined);
  static const exportToCal =
      MenuItem(text: '캘린더로 내보내기', icon: Icons.calendar_today_outlined);
  static const syllabus =
      MenuItem(text: '실라버스 모아보기', icon: Icons.sticky_note_2_outlined);
  static const delete = MenuItem(text: '시간표 삭제하기', icon: Icons.delete_outlined);

  static Widget buildItem(MenuItem item, bool isLast) {
    Color color = item == delete ? DELETE_COLOR : Colors.white;
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        Container(
          height: 40,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.text,
                  style: TextStyle(
                    fontSize: 14,
                    height: 20 / 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.15,
                    color: color,
                  ),
                ),
              ),
              Icon(
                item.icon,
                color: color,
                size: 16,
              ),
            ],
          ),
        ),
        if (!isLast)
          Container(
            color: Colors.white.withOpacity(0.5),
            height: 0.5,
          ),
      ],
    );
  }
}
