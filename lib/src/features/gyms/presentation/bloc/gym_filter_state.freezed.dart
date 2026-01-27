// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gym_filter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GymFilterState {
  double? get maxDistance => throw _privateConstructorUsedError;
  List<String> get selectedFacilities => throw _privateConstructorUsedError;
  double? get minRating => throw _privateConstructorUsedError;
  bool get openNow => throw _privateConstructorUsedError;
  String? get crowdLevel => throw _privateConstructorUsedError;
  String? get sortBy => throw _privateConstructorUsedError;
  bool get isApplying => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GymFilterStateCopyWith<GymFilterState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GymFilterStateCopyWith<$Res> {
  factory $GymFilterStateCopyWith(
          GymFilterState value, $Res Function(GymFilterState) then) =
      _$GymFilterStateCopyWithImpl<$Res, GymFilterState>;
  @useResult
  $Res call(
      {double? maxDistance,
      List<String> selectedFacilities,
      double? minRating,
      bool openNow,
      String? crowdLevel,
      String? sortBy,
      bool isApplying});
}

/// @nodoc
class _$GymFilterStateCopyWithImpl<$Res, $Val extends GymFilterState>
    implements $GymFilterStateCopyWith<$Res> {
  _$GymFilterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxDistance = freezed,
    Object? selectedFacilities = null,
    Object? minRating = freezed,
    Object? openNow = null,
    Object? crowdLevel = freezed,
    Object? sortBy = freezed,
    Object? isApplying = null,
  }) {
    return _then(_value.copyWith(
      maxDistance: freezed == maxDistance
          ? _value.maxDistance
          : maxDistance // ignore: cast_nullable_to_non_nullable
              as double?,
      selectedFacilities: null == selectedFacilities
          ? _value.selectedFacilities
          : selectedFacilities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      minRating: freezed == minRating
          ? _value.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as double?,
      openNow: null == openNow
          ? _value.openNow
          : openNow // ignore: cast_nullable_to_non_nullable
              as bool,
      crowdLevel: freezed == crowdLevel
          ? _value.crowdLevel
          : crowdLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      sortBy: freezed == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String?,
      isApplying: null == isApplying
          ? _value.isApplying
          : isApplying // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GymFilterStateImplCopyWith<$Res>
    implements $GymFilterStateCopyWith<$Res> {
  factory _$$GymFilterStateImplCopyWith(_$GymFilterStateImpl value,
          $Res Function(_$GymFilterStateImpl) then) =
      __$$GymFilterStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? maxDistance,
      List<String> selectedFacilities,
      double? minRating,
      bool openNow,
      String? crowdLevel,
      String? sortBy,
      bool isApplying});
}

/// @nodoc
class __$$GymFilterStateImplCopyWithImpl<$Res>
    extends _$GymFilterStateCopyWithImpl<$Res, _$GymFilterStateImpl>
    implements _$$GymFilterStateImplCopyWith<$Res> {
  __$$GymFilterStateImplCopyWithImpl(
      _$GymFilterStateImpl _value, $Res Function(_$GymFilterStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxDistance = freezed,
    Object? selectedFacilities = null,
    Object? minRating = freezed,
    Object? openNow = null,
    Object? crowdLevel = freezed,
    Object? sortBy = freezed,
    Object? isApplying = null,
  }) {
    return _then(_$GymFilterStateImpl(
      maxDistance: freezed == maxDistance
          ? _value.maxDistance
          : maxDistance // ignore: cast_nullable_to_non_nullable
              as double?,
      selectedFacilities: null == selectedFacilities
          ? _value._selectedFacilities
          : selectedFacilities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      minRating: freezed == minRating
          ? _value.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as double?,
      openNow: null == openNow
          ? _value.openNow
          : openNow // ignore: cast_nullable_to_non_nullable
              as bool,
      crowdLevel: freezed == crowdLevel
          ? _value.crowdLevel
          : crowdLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      sortBy: freezed == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String?,
      isApplying: null == isApplying
          ? _value.isApplying
          : isApplying // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$GymFilterStateImpl extends _GymFilterState {
  const _$GymFilterStateImpl(
      {this.maxDistance = null,
      final List<String> selectedFacilities = const [],
      this.minRating = null,
      this.openNow = false,
      this.crowdLevel = null,
      this.sortBy = null,
      this.isApplying = false})
      : _selectedFacilities = selectedFacilities,
        super._();

  @override
  @JsonKey()
  final double? maxDistance;
  final List<String> _selectedFacilities;
  @override
  @JsonKey()
  List<String> get selectedFacilities {
    if (_selectedFacilities is EqualUnmodifiableListView)
      return _selectedFacilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedFacilities);
  }

  @override
  @JsonKey()
  final double? minRating;
  @override
  @JsonKey()
  final bool openNow;
  @override
  @JsonKey()
  final String? crowdLevel;
  @override
  @JsonKey()
  final String? sortBy;
  @override
  @JsonKey()
  final bool isApplying;

  @override
  String toString() {
    return 'GymFilterState(maxDistance: $maxDistance, selectedFacilities: $selectedFacilities, minRating: $minRating, openNow: $openNow, crowdLevel: $crowdLevel, sortBy: $sortBy, isApplying: $isApplying)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GymFilterStateImpl &&
            (identical(other.maxDistance, maxDistance) ||
                other.maxDistance == maxDistance) &&
            const DeepCollectionEquality()
                .equals(other._selectedFacilities, _selectedFacilities) &&
            (identical(other.minRating, minRating) ||
                other.minRating == minRating) &&
            (identical(other.openNow, openNow) || other.openNow == openNow) &&
            (identical(other.crowdLevel, crowdLevel) ||
                other.crowdLevel == crowdLevel) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.isApplying, isApplying) ||
                other.isApplying == isApplying));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      maxDistance,
      const DeepCollectionEquality().hash(_selectedFacilities),
      minRating,
      openNow,
      crowdLevel,
      sortBy,
      isApplying);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GymFilterStateImplCopyWith<_$GymFilterStateImpl> get copyWith =>
      __$$GymFilterStateImplCopyWithImpl<_$GymFilterStateImpl>(
          this, _$identity);
}

abstract class _GymFilterState extends GymFilterState {
  const factory _GymFilterState(
      {final double? maxDistance,
      final List<String> selectedFacilities,
      final double? minRating,
      final bool openNow,
      final String? crowdLevel,
      final String? sortBy,
      final bool isApplying}) = _$GymFilterStateImpl;
  const _GymFilterState._() : super._();

  @override
  double? get maxDistance;
  @override
  List<String> get selectedFacilities;
  @override
  double? get minRating;
  @override
  bool get openNow;
  @override
  String? get crowdLevel;
  @override
  String? get sortBy;
  @override
  bool get isApplying;
  @override
  @JsonKey(ignore: true)
  _$$GymFilterStateImplCopyWith<_$GymFilterStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
