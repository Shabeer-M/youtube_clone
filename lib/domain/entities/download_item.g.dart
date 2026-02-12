// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadItemAdapter extends TypeAdapter<DownloadItem> {
  @override
  final int typeId = 1;

  @override
  DownloadItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadItem(
      id: fields[0] as String,
      videoId: fields[1] as String,
      title: fields[2] as String,
      thumbnailUrl: fields[3] as String,
      encryptedFilePath: fields[4] as String,
      progress: fields[5] as double,
      status: fields[6] as DownloadStatus,
      fileSize: fields[7] as int,
      createdAt: fields[8] as DateTime,
      fileHash: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadItem obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.videoId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.thumbnailUrl)
      ..writeByte(4)
      ..write(obj.encryptedFilePath)
      ..writeByte(5)
      ..write(obj.progress)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.fileSize)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.fileHash);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DownloadStatusAdapter extends TypeAdapter<DownloadStatus> {
  @override
  final int typeId = 0;

  @override
  DownloadStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DownloadStatus.downloading;
      case 1:
        return DownloadStatus.paused;
      case 2:
        return DownloadStatus.completed;
      case 3:
        return DownloadStatus.failed;
      case 4:
        return DownloadStatus.canceled;
      default:
        return DownloadStatus.downloading;
    }
  }

  @override
  void write(BinaryWriter writer, DownloadStatus obj) {
    switch (obj) {
      case DownloadStatus.downloading:
        writer.writeByte(0);
        break;
      case DownloadStatus.paused:
        writer.writeByte(1);
        break;
      case DownloadStatus.completed:
        writer.writeByte(2);
        break;
      case DownloadStatus.failed:
        writer.writeByte(3);
        break;
      case DownloadStatus.canceled:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
