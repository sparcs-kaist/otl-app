import 'package:flutter/material.dart';

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
    return ActionChip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: () async {
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
    );
  }
}
