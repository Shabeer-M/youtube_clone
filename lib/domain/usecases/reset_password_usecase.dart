import '../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Failure?> call(String email) async {
    return repository.resetPassword(email);
  }
}
