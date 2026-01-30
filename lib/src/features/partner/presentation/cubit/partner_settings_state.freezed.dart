// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'partner_settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PartnerSettingsState {
// Settings data
  PartnerSettings? get settings => throw _privateConstructorUsedError;
  GymWorkingHours? get editingWorkingHours =>
      throw _privateConstructorUsedError; // Status
  PartnerSettingsStatus get loadStatus => throw _privateConstructorUsedError;
  PartnerSettingsStatus get saveStatus =>
      throw _privateConstructorUsedError; // Error
  String? get errorMessage => throw _privateConstructorUsedError;
  String? get successMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PartnerSettingsStateCopyWith<PartnerSettingsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartnerSettingsStateCopyWith<$Res> {
  factory $PartnerSettingsStateCopyWith(PartnerSettingsState value,
          $Res Function(PartnerSettingsState) then) =
      _$PartnerSettingsStateCopyWithImpl<$Res, PartnerSettingsState>;
  @useResult
  $Res call(
      {PartnerSettings? settings,
      GymWorkingHours? editingWorkingHours,
      PartnerSettingsStatus loadStatus,
      PartnerSettingsStatus saveStatus,
      String? errorMessage,
      String? successMessage});
}

/// @nodoc
class _$PartnerSettingsStateCopyWithImpl<$Res,
        $Val extends PartnerSettingsState>
    implements $PartnerSettingsStateCopyWith<$Res> {
  _$PartnerSettingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? settings = freezed,
    Object? editingWorkingHours = freezed,
    Object? loadStatus = null,
    Object? saveStatus = null,
    Object? errorMessage = freezed,
    Object? successMessage = freezed,
  }) {
    return _then(_value.copyWith(
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as PartnerSettings?,
      editingWorkingHours: freezed == editingWorkingHours
          ? _value.editingWorkingHours
          : editingWorkingHours // ignore: cast_nullable_to_non_nullable
              as GymWorkingHours?,
      loadStatus: null == loadStatus
          ? _value.loadStatus
          : loadStatus // ignore: cast_nullable_to_non_nullable
              as PartnerSettingsStatus,
      saveStatus: null == saveStatus
          ? _value.saveStatus
          : saveStatus // ignore: cast_nullable_to_non_nullable
              as PartnerSettingsStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      successMessage: freezed == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PartnerSettingsStateImplCopyWith<$Res>
    implements $PartnerSettingsStateCopyWith<$Res> {
  factory _$$PartnerSettingsStateImplCopyWith(_$PartnerSettingsStateImpl value,
          $Res Function(_$PartnerSettingsStateImpl) then) =
      __$$PartnerSettingsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PartnerSettings? settings,
      GymWorkingHours? editingWorkingHours,
      PartnerSettingsStatus loadStatus,
      PartnerSettingsStatus saveStatus,
      String? errorMessage,
      String? successMessage});
}

/// @nodoc
class __$$PartnerSettingsStateImplCopyWithImpl<$Res>
    extends _$PartnerSettingsStateCopyWithImpl<$Res, _$PartnerSettingsStateImpl>
    implements _$$PartnerSettingsStateImplCopyWith<$Res> {
  __$$PartnerSettingsStateImplCopyWithImpl(_$PartnerSettingsStateImpl _value,
      $Res Function(_$PartnerSettingsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? settings = freezed,
    Object? editingWorkingHours = freezed,
    Object? loadStatus = null,
    Object? saveStatus = null,
    Object? errorMessage = freezed,
    Object? successMessage = freezed,
  }) {
    return _then(_$PartnerSettingsStateImpl(
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as PartnerSettings?,
      editingWorkingHours: freezed == editingWorkingHours
          ? _value.editingWorkingHours
          : editingWorkingHours // ignore: cast_nullable_to_non_nullable
              as GymWorkingHours?,
      loadStatus: null == loadStatus
          ? _value.loadStatus
          : loadStatus // ignore: cast_nullable_to_non_nullable
              as PartnerSettingsStatus,
      saveStatus: null == saveStatus
          ? _value.saveStatus
          : saveStatus // ignore: cast_nullable_to_non_nullable
              as PartnerSettingsStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      successMessage: freezed == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PartnerSettingsStateImpl extends _PartnerSettingsState {
  const _$PartnerSettingsStateImpl(
      {this.settings,
      this.editingWorkingHours,
      this.loadStatus = PartnerSettingsStatus.initial,
      this.saveStatus = PartnerSettingsStatus.initial,
      this.errorMessage,
      this.successMessage})
      : super._();

// Settings data
  @override
  final PartnerSettings? settings;
  @override
  final GymWorkingHours? editingWorkingHours;
// Status
  @override
  @JsonKey()
  final PartnerSettingsStatus loadStatus;
  @override
  @JsonKey()
  final PartnerSettingsStatus saveStatus;
// Error
  @override
  final String? errorMessage;
  @override
  final String? successMessage;

  @override
  String toString() {
    return 'PartnerSettingsState(settings: $settings, editingWorkingHours: $editingWorkingHours, loadStatus: $loadStatus, saveStatus: $saveStatus, errorMessage: $errorMessage, successMessage: $successMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartnerSettingsStateImpl &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.editingWorkingHours, editingWorkingHours) ||
                other.editingWorkingHours == editingWorkingHours) &&
            (identical(other.loadStatus, loadStatus) ||
                other.loadStatus == loadStatus) &&
            (identical(other.saveStatus, saveStatus) ||
                other.saveStatus == saveStatus) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.successMessage, successMessage) ||
                other.successMessage == successMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, settings, editingWorkingHours,
      loadStatus, saveStatus, errorMessage, successMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PartnerSettingsStateImplCopyWith<_$PartnerSettingsStateImpl>
      get copyWith =>
          __$$PartnerSettingsStateImplCopyWithImpl<_$PartnerSettingsStateImpl>(
              this, _$identity);
}

abstract class _PartnerSettingsState extends PartnerSettingsState {
  const factory _PartnerSettingsState(
      {final PartnerSettings? settings,
      final GymWorkingHours? editingWorkingHours,
      final PartnerSettingsStatus loadStatus,
      final PartnerSettingsStatus saveStatus,
      final String? errorMessage,
      final String? successMessage}) = _$PartnerSettingsStateImpl;
  const _PartnerSettingsState._() : super._();

  @override // Settings data
  PartnerSettings? get settings;
  @override
  GymWorkingHours? get editingWorkingHours;
  @override // Status
  PartnerSettingsStatus get loadStatus;
  @override
  PartnerSettingsStatus get saveStatus;
  @override // Error
  String? get errorMessage;
  @override
  String? get successMessage;
  @override
  @JsonKey(ignore: true)
  _$$PartnerSettingsStateImplCopyWith<_$PartnerSettingsStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
