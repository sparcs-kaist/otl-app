import 'package:flutter/material.dart';
import 'package:otlplus/models/code_label_pair.dart';

class SearchFilterPanel extends StatefulWidget {
  final Map<String, dynamic> filter;
  final Function(String varient, String code, bool selected) setFilter;

  SearchFilterPanel({
    Key? key,
    required this.filter,
    required this.setFilter,
  }) : super(key: key);

  @override
  State<SearchFilterPanel> createState() => _SearchFilterPanelState();
}

class _SearchFilterPanelState extends State<SearchFilterPanel> {
  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: ColoredBox(
        color: Colors.white,
        child: Scrollbar(
          controller: _scrollController,
          child: ListView.separated(
              controller: _scrollController,
              itemCount: widget.filter.entries.length,
              shrinkWrap: true,
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: _RadioSelect(
                    crossAxisCount: 4,
                    title: widget.filter.values.elementAt(index)["label"],
                    selectList:
                        widget.filter.values.elementAt(index)["options"],
                    isMultiSelect:
                        widget.filter.values.elementAt(index)["isMultiSelect"],
                    setFilter: (String code, bool selected) {
                      widget.setFilter(
                          widget.filter.keys.elementAt(index), code, selected);
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 8)),
        ),
      ),
    );
  }
}

class _RadioSelect extends StatefulWidget {
  final crossAxisCount;
  final String title;
  final List<List<CodeLabelPair>> selectList;
  final bool isMultiSelect;
  final Function(String code, bool selected) setFilter;

  const _RadioSelect({
    Key? key,
    this.crossAxisCount = 4,
    required this.title,
    required this.selectList,
    this.isMultiSelect = true,
    required this.setFilter,
  }) : super(key: key);

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
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Visibility(
                  visible: widget.isMultiSelect,
                  child: GestureDetector(
                    onTap: () {
                      if (widget.selectList
                          .every((v) => v.every((w) => w.selected == true))) {
                        widget.selectList.forEach((v) {
                          v.forEach((w) {
                            widget.setFilter(w.code, false);
                          });
                        });
                      } else {
                        widget.selectList.forEach((v) {
                          v.forEach((w) {
                            widget.setFilter(w.code, true);
                          });
                        });
                      }
                    },
                    child: Text.rich(TextSpan(
                      style: TextStyle(
                        color: Color(0xFFD45869),
                        fontSize: 14,
                        // decoration: TextDecoration.underline
                      ),
                      text: widget.selectList
                              .every((v) => v.every((w) => w.selected == true))
                          ? "모두 해제"
                          : "모두 선택",
                    )),
                  ),
                )
              ],
            ),
          ),
          MediaQuery.removePadding(
              context: context,
              removeTop: true,
              removeBottom: true,
              child: Column(
                  children: widget.selectList.map((v) {
                return Row(
                    children: v.map((w) {
                  return Padding(
                    padding: EdgeInsets.all(4),
                    child: _RadioSelectButton(
                        option: w,
                        setOption: (b) {
                          if (!widget.isMultiSelect) {
                            b = true;
                            widget.selectList.forEach((e) => e.forEach(
                                (c) => widget.setFilter(c.code, false)));
                          }
                          widget.setFilter(w.code, b);
                        }),
                  );
                }).toList());
              }).toList())),
        ],
      ),
    );
  }
}

class _RadioSelectButton extends StatefulWidget {
  final CodeLabelPair option;
  final Function(bool) setOption;

  const _RadioSelectButton(
      {Key? key, required this.option, required this.setOption})
      : super(key: key);

  @override
  State<_RadioSelectButton> createState() => __RadioSelectButtonState();
}

class __RadioSelectButtonState extends State<_RadioSelectButton> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GestureDetector(
        onTap: () {
          widget.setOption(!widget.option.selected);
        },
        child: ColoredBox(
          color: widget.option.selected ? Color(0xFFEDC3C9) : Color(0xFFEEEEEE),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.option.label,
                  style: TextStyle(
                      fontSize: 12.0,
                      color: widget.option.selected
                          ? Color(0xFF222222)
                          : Color(0xFF888888),
                      height: 1.3),
                ),
                SizedBox(
                  width: 4,
                ),
                widget.option.selected
                    ? Padding(
                        padding: EdgeInsets.all(1),
                        child: Icon(Icons.check,
                            size: 13, color: Color(0xFF444444)))
                    : Icon(Icons.add, size: 15, color: Color(0xFF888888))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
