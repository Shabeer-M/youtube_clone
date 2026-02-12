import '../entities/download_item.dart';
import '../entities/video.dart';

abstract class DownloadRepository {
  Future<void> startDownload(Video video);
  Future<void> pauseDownload(String downloadId);
  Future<void> resumeDownload(String downloadId);
  Future<void> cancelDownload(String downloadId);
  Future<void> deleteDownload(String downloadId);
  Future<List<DownloadItem>> getAllDownloads();
  Stream<List<DownloadItem>> getDownloadsStream();
  Future<String?> getDecryptedVideoPath(
    String downloadId,
  ); // Internal use or via localhost
}
