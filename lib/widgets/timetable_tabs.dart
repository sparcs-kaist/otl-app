import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';

class TimetableTabs extends StatefulWidget {
  final int index;
  final int length;
  final Function(int) onTap;
  final VoidCallback onCopyTap;
  final VoidCallback onDeleteTap;
  final Function(String) onExportTap;

  TimetableTabs(
      {this.index = 0,
      required this.length,
      required this.onTap,
      required this.onCopyTap,
      required this.onDeleteTap,
      required this.onExportTap});

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
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.length + 1,
        itemBuilder: (context, i) => _buildTab(i, context),
      ),
    );
  }

  Widget _buildTab(int i, BuildContext context) {
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
            color: OTLColor.pinksLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.add, size: 16),
        ),
      );
    }

    Text text = Text(
      i == 0 ? "내 시간표" : "시간표 $i",
      style: bodyBold.copyWith(color: i == _index ? OTLColor.grayF : OTLColor.gray0),
      textAlign: TextAlign.center,
    );

    if (i == _index) {
      bool canDelete = widget.length > 2 && i != 0;
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            customButton: Container(
              height: 28,
              padding: EdgeInsets.fromLTRB(12, 0, 8, 0),
              decoration: BoxDecoration(
                color: OTLColor.pinksMain,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                  text,
                  const SizedBox(width: 6),
                  Icon(
                    Icons.more_vert,
                    color: OTLColor.grayF,
                    size: 16,
                  ),
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
                color: OTLColor.gray6,
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
      height: 28,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: OTLColor.pinksLight,
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
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
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
    Color color = item == delete ? OTLColor.red : OTLColor.grayF;
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
                  style: bodyRegular.copyWith(color: color),
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
            color: OTLColor.grayF.withOpacity(0.5),
            height: 0.5,
          ),
      ],
    );
  }
}
