import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'download_item.g.dart';

@HiveType(typeId: 0)
enum DownloadStatus {
  @HiveField(0)
  downloading,
  @HiveField(1)
  paused,
  @HiveField(2)
  completed,
  @HiveField(3)
  failed,
  @HiveField(4)
  canceled,
}

@HiveType(typeId: 1)
class DownloadItem extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String videoId;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String thumbnailUrl;
  @HiveField(4)
  final String encryptedFilePath;
  @HiveField(5)
  final double progress;
  @HiveField(6)
  final DownloadStatus status;
  @HiveField(7)
  final int fileSize;
  @HiveField(8)
  final DateTime createdAt;
  @HiveField(9)
  final String? fileHash; // SHA-256 hash for integrity check

  const DownloadItem({
    required this.id,
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.encryptedFilePath,
    this.progress = 0.0,
    this.status = DownloadStatus.downloading,
    required this.fileSize,
    required this.createdAt,
    this.fileHash,
  });

  DownloadItem copyWith({
    String? id,
    String? videoId,
    String? title,
    String? thumbnailUrl,
    String? encryptedFilePath,
    double? progress,
    DownloadStatus? status,
    int? fileSize,
    DateTime? createdAt,
    String? fileHash,
  }) {
    return DownloadItem(
      id: id ?? this.id,
      videoId: videoId ?? this.videoId,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      encryptedFilePath: encryptedFilePath ?? this.encryptedFilePath,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      fileHash: fileHash ?? this.fileHash,
    );
  }

  @override
  List<Object?> get props => [
    id,
    videoId,
    title,
    thumbnailUrl,
    encryptedFilePath,
    progress,
    status,
    fileSize,
    createdAt,
    fileHash,
  ];
}
