import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for verifying OTP code
class VerifyOtpUseCase {
  VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  /// Execute the use case
  Future<Either<Failure, User>> call({
    required String phone,
    required String otp,
  }) async {
    // Validate phone number
    if (phone.isEmpty) {
      return const Left(ValidationFailure('Phone number cannot be empty'));
    }

    // Validate OTP code (should be 6 digits)
    if (otp.length != 6 || !RegExp(r'^\d{6}$').hasMatch(otp)) {
      return const Left(ValidationFailure('OTP code must be 6 digits'));
    }

    return await _repository.verifyOtp(
      phone: phone,
      otp: otp,
    );
  }
}

/// Use case for sending OTP to phone number
class SendOtpUseCase {
  SendOtpUseCase(this._repository);

  final AuthRepository _repository;

  /// Execute the use case
  Future<Either<Failure, void>> call({required String phone}) async {
    // Validate phone number format
    if (phone.isEmpty) {
      return const Left(ValidationFailure('Phone number cannot be empty'));
    }

    // Basic phone validation (Egyptian format or international)
    if (!_isValidPhoneNumber(phone)) {
      return const Left(ValidationFailure('Invalid phone number format'));
    }

    return await _repository.requestOtp(phone: phone);
  }

  bool _isValidPhoneNumber(String phone) {
    // Remove spaces and dashes
    final cleaned = phone.replaceAll(RegExp(r'[\s-]'), '');
    
    // Egyptian format: 01xxxxxxxxx (11 digits) or +201xxxxxxxxx
    // International format: +xxxxxxxxxxxx
    return RegExp(r'^(\+?20)?01[0-2,5]\d{8}$').hasMatch(cleaned) ||
           RegExp(r'^\+\d{10,15}$').hasMatch(cleaned);
  }
}