import 'package:hive_flutter/hive_flutter.dart';

class SearchHistoryLocalDataSource {
  static const String boxName = 'search_history';

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<String>(boxName);
    }
  }

  Future<List<String>> getSearchHistory() async {
    final box = Hive.box<String>(boxName);
    // Return reversed list to show latest first
    return box.values.toList().reversed.toList();
  }

  Future<void> saveSearchQuery(String query) async {
    final box = Hive.box<String>(boxName);

    // Remove if exists to move to top
    final Map<dynamic, String> boxMap = box.toMap();
    dynamic keyToDelete;
    boxMap.forEach((key, value) {
      if (value == query) {
        keyToDelete = key;
      }
    });

    if (keyToDelete != null) {
      await box.delete(keyToDelete);
    }

    await box.add(query);

    // Limit history size (optional, e.g., 20 items)
    if (box.length > 20) {
      await box.deleteAt(0);
    }
  }

  Future<void> clearHistory() async {
    final box = Hive.box<String>(boxName);
    await box.clear();
  }
}
