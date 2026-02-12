import '../../core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<(Failure?, User?)> call(String otp) async {
    return repository.verifyOtp(otp);
  }
}
