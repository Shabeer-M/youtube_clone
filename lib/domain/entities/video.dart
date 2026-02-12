import 'package:equatable/equatable.dart';

class Video extends Equatable {
  final String id;
  final String title;
  final String description; // Added description
  final String thumbnailUrl;
  final String videoUrl;
  final String channelName;
  final String channelId;
  final int views;
  final DateTime publishedAt;
  final Duration duration;
  final Map<String, String> availableQualities; // Quality Label -> URL

  const Video({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.channelName,
    required this.channelId,
    required this.views,
    required this.publishedAt,
    required this.duration,
    this.availableQualities = const {},
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    thumbnailUrl,
    videoUrl,
    channelName,
    channelId,
    views,
    views,
    publishedAt,
    duration,
    availableQualities,
  ];
}
