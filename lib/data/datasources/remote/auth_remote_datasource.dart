import '../../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> loginWithEmail(String email, String password);
  Future<void> sendOtp(String phoneNumber);
  Future<User> verifyOtp(String otp, String? verificationId);
  Future<void> resetPassword(String email);
  Future<User?> getCurrentUser();
  Future<void> logout();
  Future<User> loginWithGoogle();
  Future<User> registerWithEmail(String name, String email, String password);
}
