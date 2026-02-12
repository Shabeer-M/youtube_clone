import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/entities/download_item.dart' as domain;

class DownloadLocalDataSource {
  static const String boxName = 'downloads';

  Future<void> init() async {
    Hive.registerAdapter(domain.DownloadStatusAdapter());
    Hive.registerAdapter(domain.DownloadItemAdapter());
    await Hive.openBox<domain.DownloadItem>(boxName);
  }

  Future<void> saveDownload(domain.DownloadItem item) async {
    final box = Hive.box<domain.DownloadItem>(boxName);
    await box.put(item.id, item);
  }

  Future<domain.DownloadItem?> getDownload(String id) async {
    final box = Hive.box<domain.DownloadItem>(boxName);
    return box.get(id);
  }

  Future<List<domain.DownloadItem>> getAllDownloads() async {
    final box = Hive.box<domain.DownloadItem>(boxName);
    return box.values.toList();
  }

  Future<void> deleteDownload(String id) async {
    final box = Hive.box<domain.DownloadItem>(boxName);
    await box.delete(id);
  }
}
