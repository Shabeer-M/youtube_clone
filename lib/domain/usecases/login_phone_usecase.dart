import '../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

class LoginPhoneUseCase {
  final AuthRepository repository;

  LoginPhoneUseCase(this.repository);

  Future<Failure?> call(String phoneNumber) async {
    return repository.sendOtp(phoneNumber);
  }
}
