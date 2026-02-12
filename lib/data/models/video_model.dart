import '../../domain/entities/video.dart';

class VideoModel extends Video {
  const VideoModel({
    required super.id,
    required super.title,
    required super.description,
    required super.thumbnailUrl,
    required super.videoUrl,
    required super.channelName,
    required super.channelId,
    required super.views,
    required super.publishedAt,
    required super.duration,
    super.availableQualities,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    // Parse video files for qualities and main URL
    String mainVideoUrl = '';
    Map<String, String> qualities = {};

    if (json['video_files'] != null) {
      final files = json['video_files'] as List;
      if (files.isNotEmpty) {
        // SD as default if HD not found, or first one
        final mainFile = files.firstWhere(
          (f) => f['quality'] == 'hd',
          orElse: () => files.first,
        );
        mainVideoUrl = mainFile['link'];

        for (var f in files) {
          qualities['${f['quality']} (${f['width']}x${f['height']})'] =
              f['link'];
        }
      }
    }

    return VideoModel(
      id: json['id'].toString(),
      title:
          json['url']?.split('/').last.replaceAll('-', ' ') ??
          'No Title', // Generate title from URL slug
      description: 'Pexels Video by ${json['user']?['name'] ?? 'Unknown'}',
      thumbnailUrl: json['image'] ?? '',
      videoUrl: mainVideoUrl,
      channelName: json['user']?['name'] ?? 'Pexels User',
      channelId: json['user']?['id']?.toString() ?? '',
      views: (json['id'] as int? ?? 0) % 10000 + 500, // Fake views based on ID
      publishedAt:
          DateTime.now(), // Pexels doesn't always have created_at in search
      duration: Duration(seconds: json['duration'] ?? 0),
      availableQualities: qualities,
    );
  }
}
