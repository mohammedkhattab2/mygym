// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User data model for API serialization
///
/// Maps to/from JSON and converts to domain [User] entity.
/// Uses freezed for immutability and json_serializable for JSON handling.
@freezed
class UserModel with _$UserModel {
  const UserModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserModel({
    required String id,
    required String email,
    String? name,
    String? phone,
    String? photoUrl,
    @JsonKey(name: 'role') @Default('member') String roleString,
    String? selectedCity,
    @Default([]) List<String> interests,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? subscriptionStatus,
    int? remainingVisits,
    @Default(0) int points,
    String? referralCode,
    String? fcmToken,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Convert to domain entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      phone: phone,
      photoUrl: photoUrl,
      role: _parseRole(roleString),
      selectedCity: selectedCity,
      interests: interests,
      createdAt: createdAt,
      subscriptionStatus: subscriptionStatus,
      remainingVisits: remainingVisits,
      points: points,
      referralCode: referralCode,
    );
  }

  /// Create from domain entity
  static UserModel fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      phone: user.phone,
      photoUrl: user.photoUrl,
      roleString: user.role.name,
      selectedCity: user.selectedCity,
      interests: user.interests,
      createdAt: user.createdAt,
      subscriptionStatus: user.subscriptionStatus,
      remainingVisits: user.remainingVisits,
      points: user.points,
      referralCode: user.referralCode,
    );
  }

  UserRole _parseRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'partner':
        return UserRole.partner;
      case 'member':
        return UserRole.member;
      case 'guest':
      default:
        return UserRole.guest;
    }
  }
}

/// Auth response model for login/register API responses
@freezed
class AuthResponseModel with _$AuthResponseModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AuthResponseModel({
    required String accessToken,
    String? refreshToken,
    int? expiresIn,
    @Default('Bearer') String tokenType,
    required UserModel user,
  }) = _AuthResponseModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
}

/// OTP request model
@freezed
class OtpRequestModel with _$OtpRequestModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory OtpRequestModel({
    required String phone,
    @Default('+20') String countryCode,
  }) = _OtpRequestModel;

  factory OtpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OtpRequestModelFromJson(json);
}

/// OTP verification model
@freezed
class OtpVerifyModel with _$OtpVerifyModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory OtpVerifyModel({
    required String phone,
    required String otp,
    @Default('+20') String countryCode,
  }) = _OtpVerifyModel;

  factory OtpVerifyModel.fromJson(Map<String, dynamic> json) =>
      _$OtpVerifyModelFromJson(json);
}

/// Social login request model
@freezed
class SocialLoginModel with _$SocialLoginModel {
  const factory SocialLoginModel({
    required String idToken,
    required String provider, // 'google' or 'apple'
    String? email,
    String? name,
    String? photoUrl,
  }) = _SocialLoginModel;

  factory SocialLoginModel.fromJson(Map<String, dynamic> json) =>
      _$SocialLoginModelFromJson(json);
}