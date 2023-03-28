import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:otlplus/constants/color.dart';



class SearchSheetBody extends StatefulWidget {
  SearchSheetBody({
    Key? key,
    required this.textController, required this.filter, required this.setFilter, required this.onSumitted
  }) : super(key: key);

  final TextEditingController textController;
  final Map<String, dynamic> filter;
  final void Function(String division, String option, bool value) setFilter;
  final void Function() onSumitted;


  @override
  State<SearchSheetBody> createState() => _SearchSheetBodyState();
}

class _SearchSheetBodyState extends State<SearchSheetBody> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 0, 24, MediaQueryData.fromWindow(WidgetsBinding.instance.window).padding.top),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: NotificationListener<ScrollUpdateNotification>(
                    onNotification: (scroll) {
                      // print(scroll.metrics.pixels);
                      // if(scroll.metrics.pixels < 0) {
                      //   _scrollController.
                      // }
                      return true;
                    },
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: widget.filter.entries.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return _RadioSelect(
                            crossAxisCount: 4,
                            title: widget.filter.values.elementAt(index)["label"],
                            selectList: widget.filter.values.elementAt(index)["options"],
                            setSelected: (String option, bool value) {
                              widget.setFilter(widget.filter.keys.elementAt(index), option, value);
                            },
                          );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 8,)
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 14,),
            Container(
              height: 44,
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: GestureDetector(
                        onTap: () {
                          widget.textController.clear();
                          widget.filter.entries.forEach((e) {
                            (e.value["options"] as Map).entries.forEach((v) {
                              widget.setFilter(e.key, v.key, true);
                            });
                          });
                        },
                        child: ColoredBox(
                          color: Color(0xFFFFFFFF),
                          child: Center(
                            child: Text(
                              "초기화",
                              style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFFD45869),
                            ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    flex: 1,
                    child: ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: GestureDetector(
                        onTap: widget.onSumitted,
                        child: ColoredBox(
                          color: Color(0xFFD45869),
                          child: Center(
                            child: Text(
                              "검색",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class _RadioSelect extends StatefulWidget {
  const _RadioSelect({
    Key? key,
    this.crossAxisCount = 4,
    required this.title,
    required this.selectList,
    required this.setSelected,

  }) : super(key: key);
  final crossAxisCount;
  final String title;
  final Map<String, dynamic> selectList;
  final Function(String, bool) setSelected;

  @override
  State<_RadioSelect> createState() => __RadioSelectState();
}

class __RadioSelectState extends State<_RadioSelect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if(widget.selectList.values.every((value) => value["selected"] == true)) {
                      widget.selectList.keys.forEach((key) {
                        widget.setSelected(key, false);
                      });
                    }
                    else {
                      widget.selectList.keys.forEach((key) {
                        widget.setSelected(key, true);
                      });
                    }
                  },
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        color: Color(0xFFD45869),
                        fontSize: 16,
                        // decoration: TextDecoration.underline
                      ),
                      text: widget.selectList.values.every((value) => value["selected"] == true) ? "모두 해제" : "모두 선택",
                    )
                  ),
                )
              ],
            ),
          ),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: GridView.builder(
              itemCount: widget.selectList.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 2.2 * 4 / widget.crossAxisCount,
              ),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                MapEntry<String, dynamic> option = widget.selectList.entries.toList().elementAt(index);
                return _RadioSelectButton(
                  option: option.value,
                  setToggle: (v) {
                    widget.setSelected(option.key, v);
                    // widget.setSelected!((toggle!..removeWhere((key, value) => !value)).keys.toList());
                  },
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}


class _RadioSelectButton extends StatefulWidget {
  const _RadioSelectButton({
    Key? key, 
    required this.setToggle, 
    required this.option,
  }) : super(key: key);
  final Function(bool) setToggle;
  final Map option;

  @override
  State<_RadioSelectButton> createState() => __RadioSelectButtonState();
}

class __RadioSelectButtonState extends State<_RadioSelectButton> {
  @override
  Widget build(BuildContext context) {
    return ActionChip(
      padding: EdgeInsets.fromLTRB(5, 0, 2, 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: () {
        widget.setToggle(!widget.option["selected"]);
      },
      backgroundColor: widget.option["selected"] ? Color(0xFFEDC3C9) : Color(0xFFEEEEEE),
      label: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.option["label"],
            style: TextStyle(
              fontSize: 13.0,
              color: widget.option["selected"] ? Color(0xFF222222) : Color(0xFF888888),
              height: 1.3
            ),
          ),
          Icon(
            widget.option["selected"] ? Icons.check : Icons.add,
            size: widget.option["selected"] ? 13 : 15,
            color: widget.option["selected"] ? Color(0xFF444444) : Color(0xFF888888),
          )
        ],
      )
    );
  }
}