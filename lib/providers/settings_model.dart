import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _kSendCrashlytics = 'sendCrashlytics';
final _kSendCrashlyticsAnonymously = 'sendCrashlyticsAnonymously';
final _kShowsChannelTalkButton = 'showsChannelTalkButton';
final _kSendAlarm = 'sendAlarm';
final _kSubjectSuggestionAlarm = 'subjectSuggestionAlarm';
final _kPromotionAlarm = 'promotionAlarm';
final _kInformationAlarm = 'infomationAlarm';

class SettingsModel extends ChangeNotifier {
  late bool _sendCrashlytics;
  late bool _sendCrashlyticsAnonymously;
  late bool _showsChannelTalkButton;
  late bool _sendAlarm;
  late bool _subjectSuggestionAlarm;
  late bool _promotionAlarm;
  late bool _informationAlarm;

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

  bool getSendAlarm() => _sendAlarm;
  Future<void> setSendAlarm(bool newValue) async {
    _sendAlarm = newValue;
    notifyListeners();

    if (newValue == true) {
      PermissionStatus status = await Permission.notification.status;
      if (!status.isGranted) {
        await openAppSettings();
      }
    }

    SharedPreferences.getInstance()
        .then((instance) => instance.setBool(_kSendAlarm, _sendAlarm));

    setSubjectSuggestionAlarm(_sendAlarm);
    setInformationAlarm(_sendAlarm);
    setPromotionAlarm(_sendAlarm);
  }

  bool getSubjectSuggestionAlarm() => _subjectSuggestionAlarm;
  Future<void> setSubjectSuggestionAlarm(bool newValue) async {
    _subjectSuggestionAlarm = newValue;
    notifyListeners();
    SharedPreferences.getInstance().then(
        (instance) => instance.setBool(_kSubjectSuggestionAlarm, newValue));

    if (newValue == true) {
      await FirebaseMessaging.instance.subscribeToTopic("subject_suggestion");
    } else {
      await FirebaseMessaging.instance
          .unsubscribeFromTopic("subject_suggestion");
    }
  }

  bool getPromotionAlarm() => _promotionAlarm;
  Future<void> setPromotionAlarm(bool newValue) async {
    _promotionAlarm = newValue;
    notifyListeners();
    SharedPreferences.getInstance().then(
        (instance) => instance.setBool(_kSubjectSuggestionAlarm, newValue));

    if (newValue == true) {
      await FirebaseMessaging.instance.subscribeToTopic("promotion");
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic("promotion");
    }
  }

  bool getInfomationAlarm() => _informationAlarm;
  Future<void> setInformationAlarm(bool newValue) async {
    try {
      _informationAlarm = newValue;
      notifyListeners();
      SharedPreferences.getInstance()
          .then((instance) => instance.setBool(_kInformationAlarm, newValue));

      if (newValue == true) {
        await FirebaseMessaging.instance.subscribeToTopic("information");
      } else {
        await FirebaseMessaging.instance.unsubscribeFromTopic("information");
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  SettingsModel({bool forTest = false}) {
    SharedPreferences.getInstance().then((instance) {
      getAllValues(instance);
    });

    if (forTest) {
      _sendCrashlytics = true;
      _sendCrashlyticsAnonymously = false;
      _showsChannelTalkButton = true;
      _sendAlarm = true;
      _subjectSuggestionAlarm = true;
      _promotionAlarm = true;
      _informationAlarm = true;
    }
  }

  getAllValues(SharedPreferences instance) {
    _sendCrashlytics = instance.getBool(_kSendCrashlytics) ?? true;
    _sendCrashlyticsAnonymously =
        instance.getBool(_kSendCrashlyticsAnonymously) ?? false;
    _showsChannelTalkButton =
        instance.getBool(_kShowsChannelTalkButton) ?? true;
    _sendAlarm = instance.getBool(_kSendAlarm) ?? true;
    _subjectSuggestionAlarm =
        instance.getBool(_kSubjectSuggestionAlarm) ?? true;
    _promotionAlarm = instance.getBool(_kPromotionAlarm) ?? true;
    _informationAlarm = instance.getBool(_kInformationAlarm) ?? true;
    notifyListeners();
  }

  Future<bool> clearAllValues() async {
    final instance = await SharedPreferences.getInstance();
    final success = await instance.clear();
    getAllValues(instance);
    return success;
  }
}
