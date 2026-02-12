import '../../core/error/failure.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<(Failure?, User?)> loginWithEmail(String email, String password);
  Future<Failure?> sendOtp(String phoneNumber);
  Future<(Failure?, User?)> verifyOtp(String otp);
  Future<Failure?> resetPassword(String email);
  Future<bool> isLoggedIn();
  Future<void> logout();
  Future<(Failure?, User?)> getCurrentUser();
  Future<(Failure?, User?)> loginWithGoogle();
  Future<(Failure?, User?)> registerWithEmail(
    String name,
    String email,
    String password,
  );
}
