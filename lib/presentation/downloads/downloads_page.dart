import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/download_item.dart';

import 'bloc/download_bloc.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // BlocProvider is now in MainPage
    return Scaffold(
      appBar: AppBar(title: const Text('Downloads')),
      body: BlocConsumer<DownloadBloc, DownloadState>(
        listener: (context, state) {
          if (state is DownloadPlaybackReady) {
            _handlePlayback(context, state.decryptedPath);
          }
          if (state is DownloadError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is DownloadsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DownloadsLoaded) {
            if (state.downloads.isEmpty) {
              return const Center(child: Text('No downloads yet.'));
            }
            return ListView.builder(
              itemCount: state.downloads.length,
              itemBuilder: (context, index) {
                final item = state.downloads[index];
                return _buildDownloadItem(context, item);
              },
            );
          } else if (state is DownloadError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildDownloadItem(BuildContext context, DownloadItem item) {
    return ListTile(
      leading: item.thumbnailUrl.isNotEmpty
          ? Image.network(
              item.thumbnailUrl,
              width: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.video_file),
            )
          : const Icon(Icons.video_file),
      title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.status.name.toUpperCase(),
            style: const TextStyle(fontSize: 10),
          ),
          if (item.status == DownloadStatus.downloading)
            LinearProgressIndicator(value: item.progress),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.status == DownloadStatus.downloading)
            IconButton(
              icon: const Icon(Icons.pause),
              onPressed: () {
                context.read<DownloadBloc>().add(
                  PauseDownloadRequested(item.id),
                );
              },
            ),
          if (item.status == DownloadStatus.paused)
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                context.read<DownloadBloc>().add(
                  ResumeDownloadRequested(item.id),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context.read<DownloadBloc>().add(
                DeleteDownloadRequested(item.id),
              );
            },
          ),
        ],
      ),
      onTap: () {
        if (item.status == DownloadStatus.completed) {
          context.read<DownloadBloc>().add(PlayDownloadRequested(item.id));
        }
      },
    );
  }

  Future<void> _handlePlayback(BuildContext context, String path) async {
    // Navigate to player
    // We assume VideoDetailsPage or a simple player handles file paths.
    // Since VideoDetailsPage takes a "Video" object, we might need to construct one or use a different player.
    // For now, we will create a mock Video object with the file path as URL.
    // In a real app, we'd have a LocalPlayerPage.

    // TODO: Create a Video object
    // But we don't have the Video object here easily (only DownloadItem).
    // Let's assume we can play it.

    // Since we need to cleanup, we wait for the route to pop.

    try {
      // Placeholder for navigation
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Playing offline file: $path')));

      // Simulating playback delay
      await Future.delayed(const Duration(seconds: 2));
    } finally {
      // Cleanup
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        debugPrint('Deleted temp decrypted file: $path');
      }
    }
  }
}
