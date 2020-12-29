import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class SearchFilter extends StatefulWidget {
  final String property;
  final Map<String, String> items;
  final void Function(dynamic) onChanged;
  final bool isMultiSelect;

  SearchFilter(
      {this.property, this.items, this.onChanged, this.isMultiSelect = false});

  @override
  _SearchFilterState createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  MapEntry<String, String> selectedItem;
  List<MapEntry<String, String>> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.items.entries.first;
    selectedItems = [selectedItem];
  }

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: () async {
        if (widget.isMultiSelect) {
          await showDialog(
              context: context,
              builder: (context) => MultiSelectDialog<MapEntry<String, String>>(
                    items: widget.items.entries
                        .map((e) => MultiSelectItem<MapEntry<String, String>>(
                            e, e.value))
                        .toList(),
                    initialValue: [],
                    listType: MultiSelectListType.CHIP,
                    searchable: false,
                    title: Text(widget.property),
                    onConfirm: (items) {
                      if (items != null && items.length > 0) {
                        if (items.length == widget.items.length - 1 ||
                            items.any((item) => item.key == selectedItem.key))
                          items = [selectedItem];
                        setState(() {
                          selectedItems = items;
                          widget.onChanged(
                              selectedItems.map((item) => item.key).toList());
                        });
                      }
                    },
                  ));
          return;
        }

        final item = await showDialog<MapEntry<String, String>>(
          context: context,
          builder: (context) => SimpleDialog(
            title: Text(widget.property),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            children: widget.items.entries
                .map((e) => SimpleDialogOption(
                      onPressed: () => Navigator.pop(context, e),
                      child: Text(e.value),
                    ))
                .toList(),
          ),
        );

        if (item != null) {
          setState(() {
            selectedItem = item;
            widget.onChanged(selectedItem.key);
          });
        }
      },
      label: Text.rich(
        TextSpan(
          style: const TextStyle(fontSize: 12.0),
          children: <TextSpan>[
            TextSpan(text: widget.property),
            const TextSpan(text: ": "),
            TextSpan(
              text: widget.isMultiSelect
                  ? ((selectedItems.length > 2)
                      ? selectedItems
                              .take(2)
                              .map((item) => item.value)
                              .join(", ") +
                          ", ..."
                      : selectedItems.map((item) => item.value).join(", "))
                  : selectedItem.value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
