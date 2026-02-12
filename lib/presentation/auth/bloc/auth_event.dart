import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginEmailRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginEmailRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class AuthPhoneLoginRequested extends AuthEvent {
  final String phoneNumber;

  const AuthPhoneLoginRequested(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class AuthVerifyOtpRequested extends AuthEvent {
  final String otp;

  const AuthVerifyOtpRequested(this.otp);

  @override
  List<Object> get props => [otp];
}

class AuthResetPasswordRequested extends AuthEvent {
  final String email;

  const AuthResetPasswordRequested(this.email);

  @override
  List<Object> get props => [email];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthGoogleLoginRequested extends AuthEvent {}

class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}
