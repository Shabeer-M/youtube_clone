import 'package:equatable/equatable.dart';

/// Base Failure class
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.statusCode});
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class DownloadFailure extends Failure {
  const DownloadFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});
}
