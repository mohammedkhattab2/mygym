import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for signing in with Google
class SignInWithGoogleUseCase {
  SignInWithGoogleUseCase(this._repository);

  final AuthRepository _repository;

  /// Execute the use case
  Future<Either<Failure, User>> call() async {
    return await _repository.signInWithGoogle();
  }
}