import '../../core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginEmailUseCase {
  final AuthRepository repository;

  LoginEmailUseCase(this.repository);

  Future<(Failure?, User?)> call(String email, String password) async {
    return repository.loginWithEmail(email, password);
  }
}
