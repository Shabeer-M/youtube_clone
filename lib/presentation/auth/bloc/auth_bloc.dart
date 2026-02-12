import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/usecases/check_auth_status_usecase.dart';
import '../../../domain/usecases/login_email_usecase.dart';
import '../../../domain/usecases/login_phone_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';
import '../../../domain/usecases/reset_password_usecase.dart';
import '../../../domain/usecases/verify_otp_usecase.dart';
import '../../../domain/usecases/login_google_usecase.dart';
import '../../../domain/usecases/register_email_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginEmailUseCase loginEmailUseCase;
  final LoginPhoneUseCase loginPhoneUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final LogoutUseCase logoutUseCase;
  final LoginGoogleUseCase loginGoogleUseCase;
  final RegisterEmailUseCase registerEmailUseCase;

  AuthBloc({
    required this.loginEmailUseCase,
    required this.loginPhoneUseCase,
    required this.verifyOtpUseCase,
    required this.resetPasswordUseCase,
    required this.checkAuthStatusUseCase,
    required this.logoutUseCase,
    required this.loginGoogleUseCase,
    required this.registerEmailUseCase,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginEmailRequested>(_onLoginEmailRequested);
    on<AuthPhoneLoginRequested>(_onPhoneLoginRequested);
    on<AuthVerifyOtpRequested>(_onVerifyOtpRequested);
    on<AuthResetPasswordRequested>(_onResetPasswordRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthGoogleLoginRequested>(_onGoogleLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final isLoggedIn = await checkAuthStatusUseCase();
    if (isLoggedIn) {
      // In a real app, define a GetUserUseCase to fetch user details
      // checking session manager or remote source
      // For now, we return a dummy user or try to fetch from repo if we had that usecase
      // Ideally checkAuthStatus might return User? instead of bool
      emit(
        const AuthAuthenticated(
          User(id: 'cached_id', name: 'User', email: 'user@example.com'),
        ),
      );
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginEmailRequested(
    AuthLoginEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final (failure, user) = await loginEmailUseCase(
      event.email,
      event.password,
    );

    if (failure != null) {
      emit(AuthFailureState(failure.message));
    } else if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthFailureState('Unknown Error'));
    }
  }

  Future<void> _onPhoneLoginRequested(
    AuthPhoneLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final failure = await loginPhoneUseCase(event.phoneNumber);

    if (failure != null) {
      emit(AuthFailureState(failure.message));
    } else {
      emit(AuthOtpSent(event.phoneNumber));
    }
  }

  Future<void> _onVerifyOtpRequested(
    AuthVerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final (failure, user) = await verifyOtpUseCase(event.otp);

    if (failure != null) {
      emit(AuthFailureState(failure.message));
    } else if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthFailureState('Unknown Error'));
    }
  }

  Future<void> _onResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final failure = await resetPasswordUseCase(event.email);

    if (failure != null) {
      emit(AuthFailureState(failure.message));
    } else {
      emit(AuthPasswordResetSent());
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await logoutUseCase();
    emit(AuthUnauthenticated());
  }

  Future<void> _onGoogleLoginRequested(
    AuthGoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final (failure, user) = await loginGoogleUseCase();

    if (failure != null) {
      emit(AuthFailureState(failure.message));
    } else if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthFailureState('Unknown Error'));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final (failure, user) = await registerEmailUseCase(
      event.name,
      event.email,
      event.password,
    );

    if (failure != null) {
      emit(AuthFailureState(failure.message));
    } else if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthFailureState('Unknown Error'));
    }
  }
}
