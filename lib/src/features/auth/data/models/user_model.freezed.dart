// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'role')
  String get roleString => throw _privateConstructorUsedError;
  String? get selectedCity => throw _privateConstructorUsedError;
  List<String> get interests => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get subscriptionStatus => throw _privateConstructorUsedError;
  int? get remainingVisits => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;
  String? get referralCode => throw _privateConstructorUsedError;
  String? get fcmToken => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String id,
      String email,
      String? name,
      String? phone,
      String? photoUrl,
      @JsonKey(name: 'role') String roleString,
      String? selectedCity,
      List<String> interests,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? subscriptionStatus,
      int? remainingVisits,
      int points,
      String? referralCode,
      String? fcmToken});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = freezed,
    Object? phone = freezed,
    Object? photoUrl = freezed,
    Object? roleString = null,
    Object? selectedCity = freezed,
    Object? interests = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? subscriptionStatus = freezed,
    Object? remainingVisits = freezed,
    Object? points = null,
    Object? referralCode = freezed,
    Object? fcmToken = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      roleString: null == roleString
          ? _value.roleString
          : roleString // ignore: cast_nullable_to_non_nullable
              as String,
      selectedCity: freezed == selectedCity
          ? _value.selectedCity
          : selectedCity // ignore: cast_nullable_to_non_nullable
              as String?,
      interests: null == interests
          ? _value.interests
          : interests // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      subscriptionStatus: freezed == subscriptionStatus
          ? _value.subscriptionStatus
          : subscriptionStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      remainingVisits: freezed == remainingVisits
          ? _value.remainingVisits
          : remainingVisits // ignore: cast_nullable_to_non_nullable
              as int?,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      referralCode: freezed == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String? name,
      String? phone,
      String? photoUrl,
      @JsonKey(name: 'role') String roleString,
      String? selectedCity,
      List<String> interests,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? subscriptionStatus,
      int? remainingVisits,
      int points,
      String? referralCode,
      String? fcmToken});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = freezed,
    Object? phone = freezed,
    Object? photoUrl = freezed,
    Object? roleString = null,
    Object? selectedCity = freezed,
    Object? interests = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? subscriptionStatus = freezed,
    Object? remainingVisits = freezed,
    Object? points = null,
    Object? referralCode = freezed,
    Object? fcmToken = freezed,
  }) {
    return _then(_$UserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      roleString: null == roleString
          ? _value.roleString
          : roleString // ignore: cast_nullable_to_non_nullable
              as String,
      selectedCity: freezed == selectedCity
          ? _value.selectedCity
          : selectedCity // ignore: cast_nullable_to_non_nullable
              as String?,
      interests: null == interests
          ? _value._interests
          : interests // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      subscriptionStatus: freezed == subscriptionStatus
          ? _value.subscriptionStatus
          : subscriptionStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      remainingVisits: freezed == remainingVisits
          ? _value.remainingVisits
          : remainingVisits // ignore: cast_nullable_to_non_nullable
              as int?,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      referralCode: freezed == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$UserModelImpl extends _UserModel {
  const _$UserModelImpl(
      {required this.id,
      required this.email,
      this.name,
      this.phone,
      this.photoUrl,
      @JsonKey(name: 'role') this.roleString = 'member',
      this.selectedCity,
      final List<String> interests = const [],
      this.createdAt,
      this.updatedAt,
      this.subscriptionStatus,
      this.remainingVisits,
      this.points = 0,
      this.referralCode,
      this.fcmToken})
      : _interests = interests,
        super._();

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String? name;
  @override
  final String? phone;
  @override
  final String? photoUrl;
  @override
  @JsonKey(name: 'role')
  final String roleString;
  @override
  final String? selectedCity;
  final List<String> _interests;
  @override
  @JsonKey()
  List<String> get interests {
    if (_interests is EqualUnmodifiableListView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interests);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? subscriptionStatus;
  @override
  final int? remainingVisits;
  @override
  @JsonKey()
  final int points;
  @override
  final String? referralCode;
  @override
  final String? fcmToken;

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, phone: $phone, photoUrl: $photoUrl, roleString: $roleString, selectedCity: $selectedCity, interests: $interests, createdAt: $createdAt, updatedAt: $updatedAt, subscriptionStatus: $subscriptionStatus, remainingVisits: $remainingVisits, points: $points, referralCode: $referralCode, fcmToken: $fcmToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.roleString, roleString) ||
                other.roleString == roleString) &&
            (identical(other.selectedCity, selectedCity) ||
                other.selectedCity == selectedCity) &&
            const DeepCollectionEquality()
                .equals(other._interests, _interests) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.subscriptionStatus, subscriptionStatus) ||
                other.subscriptionStatus == subscriptionStatus) &&
            (identical(other.remainingVisits, remainingVisits) ||
                other.remainingVisits == remainingVisits) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.referralCode, referralCode) ||
                other.referralCode == referralCode) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      name,
      phone,
      photoUrl,
      roleString,
      selectedCity,
      const DeepCollectionEquality().hash(_interests),
      createdAt,
      updatedAt,
      subscriptionStatus,
      remainingVisits,
      points,
      referralCode,
      fcmToken);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel extends UserModel {
  const factory _UserModel(
      {required final String id,
      required final String email,
      final String? name,
      final String? phone,
      final String? photoUrl,
      @JsonKey(name: 'role') final String roleString,
      final String? selectedCity,
      final List<String> interests,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? subscriptionStatus,
      final int? remainingVisits,
      final int points,
      final String? referralCode,
      final String? fcmToken}) = _$UserModelImpl;
  const _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String? get name;
  @override
  String? get phone;
  @override
  String? get photoUrl;
  @override
  @JsonKey(name: 'role')
  String get roleString;
  @override
  String? get selectedCity;
  @override
  List<String> get interests;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get subscriptionStatus;
  @override
  int? get remainingVisits;
  @override
  int get points;
  @override
  String? get referralCode;
  @override
  String? get fcmToken;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) {
  return _AuthResponseModel.fromJson(json);
}

/// @nodoc
mixin _$AuthResponseModel {
  String get accessToken => throw _privateConstructorUsedError;
  String? get refreshToken => throw _privateConstructorUsedError;
  int? get expiresIn => throw _privateConstructorUsedError;
  String get tokenType => throw _privateConstructorUsedError;
  UserModel get user => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthResponseModelCopyWith<AuthResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResponseModelCopyWith<$Res> {
  factory $AuthResponseModelCopyWith(
          AuthResponseModel value, $Res Function(AuthResponseModel) then) =
      _$AuthResponseModelCopyWithImpl<$Res, AuthResponseModel>;
  @useResult
  $Res call(
      {String accessToken,
      String? refreshToken,
      int? expiresIn,
      String tokenType,
      UserModel user});

  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$AuthResponseModelCopyWithImpl<$Res, $Val extends AuthResponseModel>
    implements $AuthResponseModelCopyWith<$Res> {
  _$AuthResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = freezed,
    Object? expiresIn = freezed,
    Object? tokenType = null,
    Object? user = null,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresIn: freezed == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int?,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthResponseModelImplCopyWith<$Res>
    implements $AuthResponseModelCopyWith<$Res> {
  factory _$$AuthResponseModelImplCopyWith(_$AuthResponseModelImpl value,
          $Res Function(_$AuthResponseModelImpl) then) =
      __$$AuthResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accessToken,
      String? refreshToken,
      int? expiresIn,
      String tokenType,
      UserModel user});

  @override
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$AuthResponseModelImplCopyWithImpl<$Res>
    extends _$AuthResponseModelCopyWithImpl<$Res, _$AuthResponseModelImpl>
    implements _$$AuthResponseModelImplCopyWith<$Res> {
  __$$AuthResponseModelImplCopyWithImpl(_$AuthResponseModelImpl _value,
      $Res Function(_$AuthResponseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = freezed,
    Object? expiresIn = freezed,
    Object? tokenType = null,
    Object? user = null,
  }) {
    return _then(_$AuthResponseModelImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresIn: freezed == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int?,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$AuthResponseModelImpl implements _AuthResponseModel {
  const _$AuthResponseModelImpl(
      {required this.accessToken,
      this.refreshToken,
      this.expiresIn,
      this.tokenType = 'Bearer',
      required this.user});

  factory _$AuthResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthResponseModelImplFromJson(json);

  @override
  final String accessToken;
  @override
  final String? refreshToken;
  @override
  final int? expiresIn;
  @override
  @JsonKey()
  final String tokenType;
  @override
  final UserModel user;

  @override
  String toString() {
    return 'AuthResponseModel(accessToken: $accessToken, refreshToken: $refreshToken, expiresIn: $expiresIn, tokenType: $tokenType, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResponseModelImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn) &&
            (identical(other.tokenType, tokenType) ||
                other.tokenType == tokenType) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, accessToken, refreshToken, expiresIn, tokenType, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthResponseModelImplCopyWith<_$AuthResponseModelImpl> get copyWith =>
      __$$AuthResponseModelImplCopyWithImpl<_$AuthResponseModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthResponseModelImplToJson(
      this,
    );
  }
}

abstract class _AuthResponseModel implements AuthResponseModel {
  const factory _AuthResponseModel(
      {required final String accessToken,
      final String? refreshToken,
      final int? expiresIn,
      final String tokenType,
      required final UserModel user}) = _$AuthResponseModelImpl;

  factory _AuthResponseModel.fromJson(Map<String, dynamic> json) =
      _$AuthResponseModelImpl.fromJson;

  @override
  String get accessToken;
  @override
  String? get refreshToken;
  @override
  int? get expiresIn;
  @override
  String get tokenType;
  @override
  UserModel get user;
  @override
  @JsonKey(ignore: true)
  _$$AuthResponseModelImplCopyWith<_$AuthResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OtpRequestModel _$OtpRequestModelFromJson(Map<String, dynamic> json) {
  return _OtpRequestModel.fromJson(json);
}

/// @nodoc
mixin _$OtpRequestModel {
  String get phone => throw _privateConstructorUsedError;
  String get countryCode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OtpRequestModelCopyWith<OtpRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpRequestModelCopyWith<$Res> {
  factory $OtpRequestModelCopyWith(
          OtpRequestModel value, $Res Function(OtpRequestModel) then) =
      _$OtpRequestModelCopyWithImpl<$Res, OtpRequestModel>;
  @useResult
  $Res call({String phone, String countryCode});
}

/// @nodoc
class _$OtpRequestModelCopyWithImpl<$Res, $Val extends OtpRequestModel>
    implements $OtpRequestModelCopyWith<$Res> {
  _$OtpRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? countryCode = null,
  }) {
    return _then(_value.copyWith(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OtpRequestModelImplCopyWith<$Res>
    implements $OtpRequestModelCopyWith<$Res> {
  factory _$$OtpRequestModelImplCopyWith(_$OtpRequestModelImpl value,
          $Res Function(_$OtpRequestModelImpl) then) =
      __$$OtpRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phone, String countryCode});
}

/// @nodoc
class __$$OtpRequestModelImplCopyWithImpl<$Res>
    extends _$OtpRequestModelCopyWithImpl<$Res, _$OtpRequestModelImpl>
    implements _$$OtpRequestModelImplCopyWith<$Res> {
  __$$OtpRequestModelImplCopyWithImpl(
      _$OtpRequestModelImpl _value, $Res Function(_$OtpRequestModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? countryCode = null,
  }) {
    return _then(_$OtpRequestModelImpl(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$OtpRequestModelImpl implements _OtpRequestModel {
  const _$OtpRequestModelImpl({required this.phone, this.countryCode = '+20'});

  factory _$OtpRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtpRequestModelImplFromJson(json);

  @override
  final String phone;
  @override
  @JsonKey()
  final String countryCode;

  @override
  String toString() {
    return 'OtpRequestModel(phone: $phone, countryCode: $countryCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpRequestModelImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, phone, countryCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpRequestModelImplCopyWith<_$OtpRequestModelImpl> get copyWith =>
      __$$OtpRequestModelImplCopyWithImpl<_$OtpRequestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtpRequestModelImplToJson(
      this,
    );
  }
}

abstract class _OtpRequestModel implements OtpRequestModel {
  const factory _OtpRequestModel(
      {required final String phone,
      final String countryCode}) = _$OtpRequestModelImpl;

  factory _OtpRequestModel.fromJson(Map<String, dynamic> json) =
      _$OtpRequestModelImpl.fromJson;

  @override
  String get phone;
  @override
  String get countryCode;
  @override
  @JsonKey(ignore: true)
  _$$OtpRequestModelImplCopyWith<_$OtpRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OtpVerifyModel _$OtpVerifyModelFromJson(Map<String, dynamic> json) {
  return _OtpVerifyModel.fromJson(json);
}

/// @nodoc
mixin _$OtpVerifyModel {
  String get phone => throw _privateConstructorUsedError;
  String get otp => throw _privateConstructorUsedError;
  String get countryCode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OtpVerifyModelCopyWith<OtpVerifyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpVerifyModelCopyWith<$Res> {
  factory $OtpVerifyModelCopyWith(
          OtpVerifyModel value, $Res Function(OtpVerifyModel) then) =
      _$OtpVerifyModelCopyWithImpl<$Res, OtpVerifyModel>;
  @useResult
  $Res call({String phone, String otp, String countryCode});
}

/// @nodoc
class _$OtpVerifyModelCopyWithImpl<$Res, $Val extends OtpVerifyModel>
    implements $OtpVerifyModelCopyWith<$Res> {
  _$OtpVerifyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? otp = null,
    Object? countryCode = null,
  }) {
    return _then(_value.copyWith(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OtpVerifyModelImplCopyWith<$Res>
    implements $OtpVerifyModelCopyWith<$Res> {
  factory _$$OtpVerifyModelImplCopyWith(_$OtpVerifyModelImpl value,
          $Res Function(_$OtpVerifyModelImpl) then) =
      __$$OtpVerifyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phone, String otp, String countryCode});
}

/// @nodoc
class __$$OtpVerifyModelImplCopyWithImpl<$Res>
    extends _$OtpVerifyModelCopyWithImpl<$Res, _$OtpVerifyModelImpl>
    implements _$$OtpVerifyModelImplCopyWith<$Res> {
  __$$OtpVerifyModelImplCopyWithImpl(
      _$OtpVerifyModelImpl _value, $Res Function(_$OtpVerifyModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? otp = null,
    Object? countryCode = null,
  }) {
    return _then(_$OtpVerifyModelImpl(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$OtpVerifyModelImpl implements _OtpVerifyModel {
  const _$OtpVerifyModelImpl(
      {required this.phone, required this.otp, this.countryCode = '+20'});

  factory _$OtpVerifyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtpVerifyModelImplFromJson(json);

  @override
  final String phone;
  @override
  final String otp;
  @override
  @JsonKey()
  final String countryCode;

  @override
  String toString() {
    return 'OtpVerifyModel(phone: $phone, otp: $otp, countryCode: $countryCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpVerifyModelImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.otp, otp) || other.otp == otp) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, phone, otp, countryCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpVerifyModelImplCopyWith<_$OtpVerifyModelImpl> get copyWith =>
      __$$OtpVerifyModelImplCopyWithImpl<_$OtpVerifyModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtpVerifyModelImplToJson(
      this,
    );
  }
}

abstract class _OtpVerifyModel implements OtpVerifyModel {
  const factory _OtpVerifyModel(
      {required final String phone,
      required final String otp,
      final String countryCode}) = _$OtpVerifyModelImpl;

  factory _OtpVerifyModel.fromJson(Map<String, dynamic> json) =
      _$OtpVerifyModelImpl.fromJson;

  @override
  String get phone;
  @override
  String get otp;
  @override
  String get countryCode;
  @override
  @JsonKey(ignore: true)
  _$$OtpVerifyModelImplCopyWith<_$OtpVerifyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SocialLoginModel _$SocialLoginModelFromJson(Map<String, dynamic> json) {
  return _SocialLoginModel.fromJson(json);
}

/// @nodoc
mixin _$SocialLoginModel {
  String get idToken => throw _privateConstructorUsedError;
  String get provider =>
      throw _privateConstructorUsedError; // 'google' or 'apple'
  String? get email => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SocialLoginModelCopyWith<SocialLoginModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialLoginModelCopyWith<$Res> {
  factory $SocialLoginModelCopyWith(
          SocialLoginModel value, $Res Function(SocialLoginModel) then) =
      _$SocialLoginModelCopyWithImpl<$Res, SocialLoginModel>;
  @useResult
  $Res call(
      {String idToken,
      String provider,
      String? email,
      String? name,
      String? photoUrl});
}

/// @nodoc
class _$SocialLoginModelCopyWithImpl<$Res, $Val extends SocialLoginModel>
    implements $SocialLoginModelCopyWith<$Res> {
  _$SocialLoginModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idToken = null,
    Object? provider = null,
    Object? email = freezed,
    Object? name = freezed,
    Object? photoUrl = freezed,
  }) {
    return _then(_value.copyWith(
      idToken: null == idToken
          ? _value.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocialLoginModelImplCopyWith<$Res>
    implements $SocialLoginModelCopyWith<$Res> {
  factory _$$SocialLoginModelImplCopyWith(_$SocialLoginModelImpl value,
          $Res Function(_$SocialLoginModelImpl) then) =
      __$$SocialLoginModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String idToken,
      String provider,
      String? email,
      String? name,
      String? photoUrl});
}

/// @nodoc
class __$$SocialLoginModelImplCopyWithImpl<$Res>
    extends _$SocialLoginModelCopyWithImpl<$Res, _$SocialLoginModelImpl>
    implements _$$SocialLoginModelImplCopyWith<$Res> {
  __$$SocialLoginModelImplCopyWithImpl(_$SocialLoginModelImpl _value,
      $Res Function(_$SocialLoginModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idToken = null,
    Object? provider = null,
    Object? email = freezed,
    Object? name = freezed,
    Object? photoUrl = freezed,
  }) {
    return _then(_$SocialLoginModelImpl(
      idToken: null == idToken
          ? _value.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialLoginModelImpl implements _SocialLoginModel {
  const _$SocialLoginModelImpl(
      {required this.idToken,
      required this.provider,
      this.email,
      this.name,
      this.photoUrl});

  factory _$SocialLoginModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialLoginModelImplFromJson(json);

  @override
  final String idToken;
  @override
  final String provider;
// 'google' or 'apple'
  @override
  final String? email;
  @override
  final String? name;
  @override
  final String? photoUrl;

  @override
  String toString() {
    return 'SocialLoginModel(idToken: $idToken, provider: $provider, email: $email, name: $name, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialLoginModelImpl &&
            (identical(other.idToken, idToken) || other.idToken == idToken) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, idToken, provider, email, name, photoUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialLoginModelImplCopyWith<_$SocialLoginModelImpl> get copyWith =>
      __$$SocialLoginModelImplCopyWithImpl<_$SocialLoginModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialLoginModelImplToJson(
      this,
    );
  }
}

abstract class _SocialLoginModel implements SocialLoginModel {
  const factory _SocialLoginModel(
      {required final String idToken,
      required final String provider,
      final String? email,
      final String? name,
      final String? photoUrl}) = _$SocialLoginModelImpl;

  factory _SocialLoginModel.fromJson(Map<String, dynamic> json) =
      _$SocialLoginModelImpl.fromJson;

  @override
  String get idToken;
  @override
  String get provider;
  @override // 'google' or 'apple'
  String? get email;
  @override
  String? get name;
  @override
  String? get photoUrl;
  @override
  @JsonKey(ignore: true)
  _$$SocialLoginModelImplCopyWith<_$SocialLoginModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
