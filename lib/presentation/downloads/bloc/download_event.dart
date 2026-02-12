part of 'download_bloc.dart';

abstract class DownloadEvent extends Equatable {
  const DownloadEvent();

  @override
  List<Object> get props => [];
}

class LoadDownloadsRequested extends DownloadEvent {}

class DownloadUpdateReceived extends DownloadEvent {
  final List<DownloadItem> downloads;

  const DownloadUpdateReceived(this.downloads);

  @override
  List<Object> get props => [downloads];
}

class StartDownloadRequested extends DownloadEvent {
  final Video video;

  const StartDownloadRequested(this.video);

  @override
  List<Object> get props => [video];
}

class PauseDownloadRequested extends DownloadEvent {
  final String downloadId;

  const PauseDownloadRequested(this.downloadId);

  @override
  List<Object> get props => [downloadId];
}

class ResumeDownloadRequested extends DownloadEvent {
  final String downloadId;

  const ResumeDownloadRequested(this.downloadId);

  @override
  List<Object> get props => [downloadId];
}

class DeleteDownloadRequested extends DownloadEvent {
  final String downloadId;

  const DeleteDownloadRequested(this.downloadId);

  @override
  List<Object> get props => [downloadId];
}

class PlayDownloadRequested extends DownloadEvent {
  final String downloadId;

  const PlayDownloadRequested(this.downloadId);

  @override
  List<Object> get props => [downloadId];
}
