import 'dart:async';

import 'package:flutter/material.dart';
import 'package:otlplus/constants/url.dart';
import 'package:otlplus/dio_provider.dart';
import 'package:otlplus/models/planner.dart';

class TrackModel extends ChangeNotifier {
  late List<GeneralTrack> _general_tracks = [];
  List<GeneralTrack> get general_tracks => _general_tracks;

  late List<MajorTrack> _major_tracks = [];
  List<MajorTrack> get major_tracks => _major_tracks;

  late List<AdditionalTrack> _additional_tracks = [];
  List<AdditionalTrack> get additional_tracks => _additional_tracks;

  void loadTracks() {
    notifyListeners();
    _loadTracks();
  }

  Future<bool> _loadTracks() async {
    try {
      final response = await DioProvider().dio.get(API_TRACK_URL);

      dynamic data = response.data;
      _general_tracks = (data['general'] as List)
          .map((tracks) => GeneralTrack.fromJson(tracks))
          .toList();

      _major_tracks = (data['major'] as List)
          .map((tracks) => MajorTrack.fromJson(tracks))
          .toList();

      _additional_tracks = (data['additional'] as List)
          .map((tracks) => AdditionalTrack.fromJson(tracks))
          .toList();

      notifyListeners();
      return true;
    } catch (exception) {
      print(exception);
    }
    return false;
  }
}
