// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      photoUrl: json['photo_url'] as String?,
      roleString: json['role'] as String? ?? 'member',
      selectedCity: json['selected_city'] as String?,
      interests: (json['interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      subscriptionStatus: json['subscription_status'] as String?,
      remainingVisits: (json['remaining_visits'] as num?)?.toInt(),
      points: (json['points'] as num?)?.toInt() ?? 0,
      referralCode: json['referral_code'] as String?,
      fcmToken: json['fcm_token'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'phone': instance.phone,
      'photo_url': instance.photoUrl,
      'role': instance.roleString,
      'selected_city': instance.selectedCity,
      'interests': instance.interests,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'subscription_status': instance.subscriptionStatus,
      'remaining_visits': instance.remainingVisits,
      'points': instance.points,
      'referral_code': instance.referralCode,
      'fcm_token': instance.fcmToken,
    };

_$AuthResponseModelImpl _$$AuthResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthResponseModelImpl(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      expiresIn: (json['expires_in'] as num?)?.toInt(),
      tokenType: json['token_type'] as String? ?? 'Bearer',
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthResponseModelImplToJson(
        _$AuthResponseModelImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'expires_in': instance.expiresIn,
      'token_type': instance.tokenType,
      'user': instance.user,
    };

_$OtpRequestModelImpl _$$OtpRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OtpRequestModelImpl(
      phone: json['phone'] as String,
      countryCode: json['country_code'] as String? ?? '+20',
    );

Map<String, dynamic> _$$OtpRequestModelImplToJson(
        _$OtpRequestModelImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'country_code': instance.countryCode,
    };

_$OtpVerifyModelImpl _$$OtpVerifyModelImplFromJson(Map<String, dynamic> json) =>
    _$OtpVerifyModelImpl(
      phone: json['phone'] as String,
      otp: json['otp'] as String,
      countryCode: json['country_code'] as String? ?? '+20',
    );

Map<String, dynamic> _$$OtpVerifyModelImplToJson(
        _$OtpVerifyModelImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'otp': instance.otp,
      'country_code': instance.countryCode,
    };

_$SocialLoginModelImpl _$$SocialLoginModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SocialLoginModelImpl(
      idToken: json['idToken'] as String,
      provider: json['provider'] as String,
      email: json['email'] as String?,
      name: json['name'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$$SocialLoginModelImplToJson(
        _$SocialLoginModelImpl instance) =>
    <String, dynamic>{
      'idToken': instance.idToken,
      'provider': instance.provider,
      'email': instance.email,
      'name': instance.name,
      'photoUrl': instance.photoUrl,
    };
