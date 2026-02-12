import '../../core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterEmailUseCase {
  final AuthRepository repository;

  RegisterEmailUseCase(this.repository);

  Future<(Failure?, User?)> call(String name, String email, String password) {
    return repository.registerWithEmail(name, email, password);
  }
}
