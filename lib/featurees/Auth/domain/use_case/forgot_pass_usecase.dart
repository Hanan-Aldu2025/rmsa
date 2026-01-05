import 'package:appp/core/error/failure.dart';
import 'package:appp/featurees/Auth/domain/repos/auth_repos.dart';
import 'package:dartz/dartz.dart';

class ForgotPasswordUseCase {
  final AuthRepos authRepos;

  ForgotPasswordUseCase(this.authRepos);

  Future<Either<Failure, void>> sendResetEmail({required String email}) {
    return authRepos.sendPasswordResetEmail(email: email);
  }
}