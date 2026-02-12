import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repositories/download_repository.dart';
import '../../../../domain/entities/download_item.dart';
import '../../../../domain/entities/video.dart';
import 'package:equatable/equatable.dart';

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  final DownloadRepository _repository;
  StreamSubscription<List<DownloadItem>>? _downloadsSubscription;

  DownloadBloc({required DownloadRepository repository})
    : _repository = repository,
      super(DownloadsInitial()) {
    on<LoadDownloadsRequested>(_onLoadDownloads);
    on<StartDownloadRequested>(_onStartDownload);
    on<PauseDownloadRequested>(_onPauseDownload);
    on<ResumeDownloadRequested>(_onResumeDownload);
    on<DeleteDownloadRequested>(_onDeleteDownload);
    on<DownloadUpdateReceived>(_onDownloadUpdate);
    on<PlayDownloadRequested>(_onPlayDownload);
  }

  Future<void> _onLoadDownloads(
    LoadDownloadsRequested event,
    Emitter<DownloadState> emit,
  ) async {
    emit(DownloadsLoading());
    await _downloadsSubscription?.cancel();

    try {
      // Initial load
      final currentDownloads = await _repository.getAllDownloads();

      // Listen for updates
      _downloadsSubscription = _repository.getDownloadsStream().listen((
        downloads,
      ) {
        add(DownloadUpdateReceived(downloads));
      });
      // Emit initial loaded state even if stream is setting up
      emit(DownloadsLoaded(downloads: currentDownloads));
    } catch (e) {
      emit(DownloadError(e.toString()));
    }
  }

  void _onDownloadUpdate(
    DownloadUpdateReceived event,
    Emitter<DownloadState> emit,
  ) {
    emit(DownloadsLoaded(downloads: event.downloads));
  }

  Future<void> _onStartDownload(
    StartDownloadRequested event,
    Emitter<DownloadState> emit,
  ) async {
    try {
      await _repository.startDownload(event.video);
    } catch (e) {
      // Error handled by repo emitting failed status or stream
      // We can also emit a transient error here if needed, but stream usually covers state.
    }
  }

  Future<void> _onPauseDownload(
    PauseDownloadRequested event,
    Emitter<DownloadState> emit,
  ) async {
    await _repository.pauseDownload(event.downloadId);
  }

  Future<void> _onResumeDownload(
    ResumeDownloadRequested event,
    Emitter<DownloadState> emit,
  ) async {
    await _repository.resumeDownload(event.downloadId);
  }

  Future<void> _onDeleteDownload(
    DeleteDownloadRequested event,
    Emitter<DownloadState> emit,
  ) async {
    await _repository.deleteDownload(event.downloadId);
  }

  Future<void> _onPlayDownload(
    PlayDownloadRequested event,
    Emitter<DownloadState> emit,
  ) async {
    try {
      final path = await _repository.getDecryptedVideoPath(event.downloadId);
      if (path != null) {
        emit(DownloadPlaybackReady(path));
        // Re-emit loaded state after single-fire event so UI doesn't get stuck?
        // Or better: UI listens, handles, and we just stay in Loaded?
        // Bloc 8: We can emit "PlaybackReady" then immediately "Loaded" with current list?
        // But "Loaded" requires the list.
        // Let's get current list.
        final currentDownloads = await _repository.getAllDownloads();
        emit(DownloadsLoaded(downloads: currentDownloads));
      } else {
        emit(const DownloadError("Failed to decrypt video"));
        // Recover
        final currentDownloads = await _repository.getAllDownloads();
        emit(DownloadsLoaded(downloads: currentDownloads));
      }
    } catch (e) {
      emit(DownloadError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _downloadsSubscription?.cancel();
    return super.close();
  }
}
