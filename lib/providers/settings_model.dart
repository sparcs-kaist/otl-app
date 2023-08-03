import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kSendCrashlytics = 'sendCrashlytics';
const _kSendCrashlyticsAnonymously = 'sendCrashlyticsAnonymously';

class SettingsModel extends ChangeNotifier {
  late bool _sendCrashlytics;
  late bool _sendCrashlyticsAnonymously;

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

  SettingsModel({bool forTest = false}) {
    SharedPreferences.getInstance().then((instance) {
      getAllValues(instance);
    });

    if (forTest) {
      _sendCrashlytics = true;
      _sendCrashlyticsAnonymously = false;
    }
  }

  getAllValues(SharedPreferences instance) {
    _sendCrashlytics = instance.getBool(_kSendCrashlytics) ?? true;
    _sendCrashlyticsAnonymously =
        instance.getBool(_kSendCrashlyticsAnonymously) ?? false;
    notifyListeners();
  }

  Future<bool> clearAllValues() async {
    final instance = await SharedPreferences.getInstance();
    final success = await instance.clear();
    getAllValues(instance);
    return success;
  }
}
