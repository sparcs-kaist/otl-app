import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageModel extends ChangeNotifier {
  Future<bool> save(String key, String value) async {
    try {
      final storage = FlutterSecureStorage();
      await storage.write(key: key, value: value);
      return true;
    } catch (exception) {
      print(exception);
      return false;
    }
  }

  Future<String?> read(String key) async {
    try {
      final storage = FlutterSecureStorage();
      return await storage.read(key: key);
    } catch (exception) {
      print(exception);
      return null;
    }
  }

  Future<bool> delete(String key) async {
    try {
      final storage = FlutterSecureStorage();
      await storage.delete(key: key);
      return true;
    } catch (exception) {
      print(exception);
      return false;
    }
  }
}
