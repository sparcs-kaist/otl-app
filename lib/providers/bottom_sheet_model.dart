import 'package:flutter/material.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:sheet/sheet.dart';

class BottomSheetModel extends ChangeNotifier {
  SheetController _scrollController = SheetController();
  SheetController get scrollController => _scrollController;
  // print(_scrollController.animation.value);


  Lecture? _selectedLecture;
  Lecture? get selectedLecture => _selectedLecture;

  int _extended = 0; //0: not extended, 1: halfway, 2: fully extended
  int get extended => _extended;

  void setSheetController(SheetController controller) {
    _scrollController = controller;
    notifyListeners();
  }

  void setSelectedLecture(Lecture? lecture) {
    _selectedLecture = lecture;
    notifyListeners();
  }

  void setExtended(int state) {
    _extended = state;
    notifyListeners();
  }


  
}
