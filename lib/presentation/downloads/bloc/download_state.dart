part of 'download_bloc.dart';

abstract class DownloadState extends Equatable {
  const DownloadState();

  @override
  List<Object> get props => [];
}

class DownloadsInitial extends DownloadState {}

class DownloadsLoading extends DownloadState {}

class DownloadsLoaded extends DownloadState {
  final List<DownloadItem> downloads;

  const DownloadsLoaded({this.downloads = const []});

  @override
  List<Object> get props => [downloads];
}

class DownloadError extends DownloadState {
  final String message;

  const DownloadError(this.message);

  @override
  List<Object> get props => [message];
}

class DownloadPlaybackReady extends DownloadState {
  final String decryptedPath;

  const DownloadPlaybackReady(this.decryptedPath);

  @override
  List<Object> get props => [decryptedPath];
}
