class FilterGroupInfo {
  final String label;
  final bool isMultiSelect;
  final List<List<CodeLabelPair>> options;
  FilterGroupInfo(this.label, this.isMultiSelect, this.options);
}

class CodeLabelPair {
  final String code;
  final String label;
  bool selected;
  CodeLabelPair(this.code, this.label, [this.selected = true]);
}
