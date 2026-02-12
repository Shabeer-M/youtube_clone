import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/di/service_locator.dart';
import '../../domain/entities/video.dart';
import 'bloc/player_bloc.dart';
import 'widgets/custom_video_player.dart';

class VideoDetailsPage extends StatelessWidget {
  final Video video;

  const VideoDetailsPage({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<
            PlayerBloc
          >(), // Event InitializePlayer is called inside CustomVideoPlayer
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Video Player Area
              SizedBox(
                height: 250,
                width: double.infinity,
                child: CustomVideoPlayer(
                  videoUrl: video.videoUrl,
                  availableQualities: video.availableQualities,
                ),
              ),

              // Video Info
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Text(
                      video.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${video.views} views • ${timeago.format(video.publishedAt)}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    // Actions (Like, Share, Download)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAction(
                          context,
                          Icons.thumb_up_alt_outlined,
                          'Like',
                          () {},
                        ),
                        _buildAction(
                          context,
                          Icons.thumb_down_alt_outlined,
                          'Dislike',
                          () {},
                        ),
                        _buildAction(
                          context,
                          Icons.share_outlined,
                          'Share',
                          () {
                            // ignore: deprecated_member_use
                            Share.share(
                              'Check out this video: ${video.videoUrl}',
                            );
                          },
                        ),
                        _buildAction(
                          context,
                          Icons.download_outlined,
                          'Download',
                          () {},
                        ),
                        _buildAction(
                          context,
                          Icons.library_add_outlined,
                          'Save',
                          () {},
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // Channel Info
                    Row(
                      children: [
                        const CircleAvatar(child: Icon(Icons.person)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video.channelName,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '1.2M subscribers', // Placeholder
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'SUBSCRIBE',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      video.description.isNotEmpty
                          ? video.description
                          : 'No description available.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAction(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
