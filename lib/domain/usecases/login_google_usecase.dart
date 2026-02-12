import '../../core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginGoogleUseCase {
  final AuthRepository repository;

  LoginGoogleUseCase(this.repository);

  Future<(Failure?, User?)> call() {
    return repository.loginWithGoogle();
  }
}
