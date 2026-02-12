import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String settingsBoxName = 'settingsBox';
  static const String downloadsBoxName = 'downloadsBox';

  Future<void> init() async {
    // Initialize Hive for Flutter
    await Hive.initFlutter();

    // Register Adapters here if needed
    // Hive.registerAdapter(VideoAdapter());

    // Open Boxes
    await Hive.openBox(settingsBoxName);
    await Hive.openBox(downloadsBoxName);
  }

  Future<void> put(String boxName, String key, dynamic value) async {
    final box = Hive.box(boxName);
    await box.put(key, value);
  }

  dynamic get(String boxName, String key, {dynamic defaultValue}) {
    final box = Hive.box(boxName);
    return box.get(key, defaultValue: defaultValue);
  }

  Future<void> delete(String boxName, String key) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }

  Future<void> clearBox(String boxName) async {
    final box = Hive.box(boxName);
    await box.clear();
  }
}
