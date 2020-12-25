import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';

class Filter extends StatefulWidget {
  final String property;
  final Map<String, String> items;
  final void Function(String) onChanged;

  Filter({this.property, this.items, this.onChanged});

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  MapEntry<String, String> selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.items.entries.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: BLOCK_COLOR,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () async {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: widget.property,
                  ),
                  const TextSpan(text: ": "),
                  TextSpan(
                    text: selectedItem.value,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
