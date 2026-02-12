import '../../../core/error/failure.dart';
import '../../../core/storage/session_manager.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SessionManager sessionManager;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.sessionManager,
  });

  @override
  Future<(Failure?, User?)> loginWithEmail(
    String email,
    String password,
  ) async {
    try {
      final user = await remoteDataSource.loginWithEmail(email, password);
      await sessionManager.saveLoginState(true, token: user.id);
      return (null, user);
    } on AuthFailure catch (e) {
      return (e, null);
    } catch (e) {
      return (AuthFailure(e.toString()), null);
    }
  }

  @override
  Future<Failure?> sendOtp(String phoneNumber) async {
    try {
      await remoteDataSource.sendOtp(phoneNumber);
      return null;
    } on AuthFailure catch (e) {
      return e;
    } catch (e) {
      return AuthFailure(e.toString());
    }
  }

  @override
  Future<(Failure?, User?)> verifyOtp(String otp) async {
    try {
      final user = await remoteDataSource.verifyOtp(otp, null);
      await sessionManager.saveLoginState(true, token: user.id);
      return (null, user);
    } on AuthFailure catch (e) {
      return (e, null);
    } catch (e) {
      return (AuthFailure(e.toString()), null);
    }
  }

  @override
  Future<Failure?> resetPassword(String email) async {
    try {
      await remoteDataSource.resetPassword(email);
      return null;
    } on AuthFailure catch (e) {
      return e;
    } catch (e) {
      return AuthFailure(e.toString());
    }
  }

  @override
  Future<(Failure?, User?)> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      if (user != null) {
        return (null, user);
      }
      return (const AuthFailure('No user found'), null);
    } catch (e) {
      return (AuthFailure(e.toString()), null);
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return sessionManager.getLoginState();
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
    await sessionManager.clearSession();
  }

  @override
  Future<(Failure?, User?)> loginWithGoogle() async {
    try {
      final user = await remoteDataSource.loginWithGoogle();
      await sessionManager.saveLoginState(true, token: user.id);
      return (null, user);
    } on AuthFailure catch (e) {
      return (e, null);
    } catch (e) {
      return (AuthFailure(e.toString()), null);
    }
  }

  @override
  Future<(Failure?, User?)> registerWithEmail(
    String name,
    String email,
    String password,
  ) async {
    try {
      final user = await remoteDataSource.registerWithEmail(
        name,
        email,
        password,
      );
      await sessionManager.saveLoginState(true, token: user.id);
      return (null, user);
    } on AuthFailure catch (e) {
      return (e, null);
    } catch (e) {
      return (AuthFailure(e.toString()), null);
    }
  }
}
