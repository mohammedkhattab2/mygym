import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for signing in with email and password
class SignInWithEmailUseCase {
  SignInWithEmailUseCase(this._repository);

  final AuthRepository _repository;

  /// Execute the use case
  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) async {
    // Validate email format
    if (!_isValidEmail(email)) {
      return const Left(ValidationFailure('Invalid email format'));
    }

    // Validate password
    if (password.isEmpty) {
      return const Left(ValidationFailure('Password cannot be empty'));
    }

    return await _repository.signInWithEmail(
      email: email,
      password: password,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}