import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _kSendCrashlytics = 'sendCrashlytics';
final _kSendCrashlyticsAnonymously = 'sendCrashlyticsAnonymously';
final _kShowsChannelTalkButton = 'showsChannelTalkButton';

class SettingsModel extends ChangeNotifier {
  late bool _sendCrashlytics;
  late bool _sendCrashlyticsAnonymously;
  late bool _showsChannelTalkButton;

  bool getSendCrashlytics() => _sendCrashlytics;
  void setSendCrashlytics(bool newValue) {
    _sendCrashlytics = newValue;
    notifyListeners();
    SharedPreferences.getInstance()
        .then((instance) => instance.setBool(_kSendCrashlytics, newValue));
  }

  bool getSendCrashlyticsAnonymously() => _sendCrashlyticsAnonymously;
  void setSendCrashlyticsAnonymously(bool newValue) {
    _sendCrashlyticsAnonymously = newValue;
    notifyListeners();
    SharedPreferences.getInstance().then(
        (instance) => instance.setBool(_kSendCrashlyticsAnonymously, newValue));
  }

  bool getShowsChannelTalkButton() => _showsChannelTalkButton;
  void setShowsChannelTalkButton(bool newValue) {
    _showsChannelTalkButton = newValue;
    notifyListeners();
    SharedPreferences.getInstance().then(
        (instance) => instance.setBool(_kShowsChannelTalkButton, newValue));
  }

  SettingsModel({bool forTest = false}) {
    SharedPreferences.getInstance().then((instance) {
      getAllValues(instance);
    });

    if (forTest) {
      _sendCrashlytics = true;
      _sendCrashlyticsAnonymously = false;
      _showsChannelTalkButton = true;
    }
  }

  getAllValues(SharedPreferences instance) {
    _sendCrashlytics = instance.getBool(_kSendCrashlytics) ?? true;
    _sendCrashlyticsAnonymously =
        instance.getBool(_kSendCrashlyticsAnonymously) ?? false;
    _showsChannelTalkButton =
        instance.getBool(_kShowsChannelTalkButton) ?? true;
    notifyListeners();
  }

  Future<bool> clearAllValues() async {
    final instance = await SharedPreferences.getInstance();
    final success = await instance.clear();
    getAllValues(instance);
    return success;
  }
}
