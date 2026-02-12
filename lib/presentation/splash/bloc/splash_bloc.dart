import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/check_auth_status_usecase.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;

  SplashBloc(this._checkAuthStatusUseCase) : super(SplashInitial()) {
    on<SplashStarted>(_onSplashStarted);
  }

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());
    // Minimum Splash duration of 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    final isLoggedIn = await _checkAuthStatusUseCase();
    if (isLoggedIn) {
      emit(SplashNavigateToHome());
    } else {
      emit(SplashNavigateToWelcome());
    }
  }
}
