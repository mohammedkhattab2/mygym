// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'classes_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ClassesState {
// Schedule data
  List<ClassSchedule> get schedules => throw _privateConstructorUsedError;
  List<DaySchedule> get weekSchedule =>
      throw _privateConstructorUsedError; // Selected class detail
  ClassSchedule? get selectedSchedule => throw _privateConstructorUsedError;
  FitnessClass? get selectedClass =>
      throw _privateConstructorUsedError; // Bookings
  List<ClassBooking> get myBookings => throw _privateConstructorUsedError;
  List<ClassBooking> get upcomingBookings => throw _privateConstructorUsedError;
  List<ClassBooking> get pastBookings =>
      throw _privateConstructorUsedError; // Filter
  ClassFilter get filter =>
      throw _privateConstructorUsedError; // Date range for schedule
  DateTime? get scheduleStartDate => throw _privateConstructorUsedError;
  DateTime? get scheduleEndDate => throw _privateConstructorUsedError; // Status
  ClassesStatus get scheduleStatus => throw _privateConstructorUsedError;
  ClassesStatus get bookingsStatus => throw _privateConstructorUsedError;
  ClassesStatus get bookingActionStatus =>
      throw _privateConstructorUsedError; // Error
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ClassesStateCopyWith<ClassesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClassesStateCopyWith<$Res> {
  factory $ClassesStateCopyWith(
          ClassesState value, $Res Function(ClassesState) then) =
      _$ClassesStateCopyWithImpl<$Res, ClassesState>;
  @useResult
  $Res call(
      {List<ClassSchedule> schedules,
      List<DaySchedule> weekSchedule,
      ClassSchedule? selectedSchedule,
      FitnessClass? selectedClass,
      List<ClassBooking> myBookings,
      List<ClassBooking> upcomingBookings,
      List<ClassBooking> pastBookings,
      ClassFilter filter,
      DateTime? scheduleStartDate,
      DateTime? scheduleEndDate,
      ClassesStatus scheduleStatus,
      ClassesStatus bookingsStatus,
      ClassesStatus bookingActionStatus,
      String? errorMessage});
}

/// @nodoc
class _$ClassesStateCopyWithImpl<$Res, $Val extends ClassesState>
    implements $ClassesStateCopyWith<$Res> {
  _$ClassesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schedules = null,
    Object? weekSchedule = null,
    Object? selectedSchedule = freezed,
    Object? selectedClass = freezed,
    Object? myBookings = null,
    Object? upcomingBookings = null,
    Object? pastBookings = null,
    Object? filter = null,
    Object? scheduleStartDate = freezed,
    Object? scheduleEndDate = freezed,
    Object? scheduleStatus = null,
    Object? bookingsStatus = null,
    Object? bookingActionStatus = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      schedules: null == schedules
          ? _value.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as List<ClassSchedule>,
      weekSchedule: null == weekSchedule
          ? _value.weekSchedule
          : weekSchedule // ignore: cast_nullable_to_non_nullable
              as List<DaySchedule>,
      selectedSchedule: freezed == selectedSchedule
          ? _value.selectedSchedule
          : selectedSchedule // ignore: cast_nullable_to_non_nullable
              as ClassSchedule?,
      selectedClass: freezed == selectedClass
          ? _value.selectedClass
          : selectedClass // ignore: cast_nullable_to_non_nullable
              as FitnessClass?,
      myBookings: null == myBookings
          ? _value.myBookings
          : myBookings // ignore: cast_nullable_to_non_nullable
              as List<ClassBooking>,
      upcomingBookings: null == upcomingBookings
          ? _value.upcomingBookings
          : upcomingBookings // ignore: cast_nullable_to_non_nullable
              as List<ClassBooking>,
      pastBookings: null == pastBookings
          ? _value.pastBookings
          : pastBookings // ignore: cast_nullable_to_non_nullable
              as List<ClassBooking>,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as ClassFilter,
      scheduleStartDate: freezed == scheduleStartDate
          ? _value.scheduleStartDate
          : scheduleStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduleEndDate: freezed == scheduleEndDate
          ? _value.scheduleEndDate
          : scheduleEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduleStatus: null == scheduleStatus
          ? _value.scheduleStatus
          : scheduleStatus // ignore: cast_nullable_to_non_nullable
              as ClassesStatus,
      bookingsStatus: null == bookingsStatus
          ? _value.bookingsStatus
          : bookingsStatus // ignore: cast_nullable_to_non_nullable
              as ClassesStatus,
      bookingActionStatus: null == bookingActionStatus
          ? _value.bookingActionStatus
          : bookingActionStatus // ignore: cast_nullable_to_non_nullable
              as ClassesStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClassesStateImplCopyWith<$Res>
    implements $ClassesStateCopyWith<$Res> {
  factory _$$ClassesStateImplCopyWith(
          _$ClassesStateImpl value, $Res Function(_$ClassesStateImpl) then) =
      __$$ClassesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ClassSchedule> schedules,
      List<DaySchedule> weekSchedule,
      ClassSchedule? selectedSchedule,
      FitnessClass? selectedClass,
      List<ClassBooking> myBookings,
      List<ClassBooking> upcomingBookings,
      List<ClassBooking> pastBookings,
      ClassFilter filter,
      DateTime? scheduleStartDate,
      DateTime? scheduleEndDate,
      ClassesStatus scheduleStatus,
      ClassesStatus bookingsStatus,
      ClassesStatus bookingActionStatus,
      String? errorMessage});
}

/// @nodoc
class __$$ClassesStateImplCopyWithImpl<$Res>
    extends _$ClassesStateCopyWithImpl<$Res, _$ClassesStateImpl>
    implements _$$ClassesStateImplCopyWith<$Res> {
  __$$ClassesStateImplCopyWithImpl(
      _$ClassesStateImpl _value, $Res Function(_$ClassesStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schedules = null,
    Object? weekSchedule = null,
    Object? selectedSchedule = freezed,
    Object? selectedClass = freezed,
    Object? myBookings = null,
    Object? upcomingBookings = null,
    Object? pastBookings = null,
    Object? filter = null,
    Object? scheduleStartDate = freezed,
    Object? scheduleEndDate = freezed,
    Object? scheduleStatus = null,
    Object? bookingsStatus = null,
    Object? bookingActionStatus = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$ClassesStateImpl(
      schedules: null == schedules
          ? _value._schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as List<ClassSchedule>,
      weekSchedule: null == weekSchedule
          ? _value._weekSchedule
          : weekSchedule // ignore: cast_nullable_to_non_nullable
              as List<DaySchedule>,
      selectedSchedule: freezed == selectedSchedule
          ? _value.selectedSchedule
          : selectedSchedule // ignore: cast_nullable_to_non_nullable
              as ClassSchedule?,
      selectedClass: freezed == selectedClass
          ? _value.selectedClass
          : selectedClass // ignore: cast_nullable_to_non_nullable
              as FitnessClass?,
      myBookings: null == myBookings
          ? _value._myBookings
          : myBookings // ignore: cast_nullable_to_non_nullable
              as List<ClassBooking>,
      upcomingBookings: null == upcomingBookings
          ? _value._upcomingBookings
          : upcomingBookings // ignore: cast_nullable_to_non_nullable
              as List<ClassBooking>,
      pastBookings: null == pastBookings
          ? _value._pastBookings
          : pastBookings // ignore: cast_nullable_to_non_nullable
              as List<ClassBooking>,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as ClassFilter,
      scheduleStartDate: freezed == scheduleStartDate
          ? _value.scheduleStartDate
          : scheduleStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduleEndDate: freezed == scheduleEndDate
          ? _value.scheduleEndDate
          : scheduleEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduleStatus: null == scheduleStatus
          ? _value.scheduleStatus
          : scheduleStatus // ignore: cast_nullable_to_non_nullable
              as ClassesStatus,
      bookingsStatus: null == bookingsStatus
          ? _value.bookingsStatus
          : bookingsStatus // ignore: cast_nullable_to_non_nullable
              as ClassesStatus,
      bookingActionStatus: null == bookingActionStatus
          ? _value.bookingActionStatus
          : bookingActionStatus // ignore: cast_nullable_to_non_nullable
              as ClassesStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ClassesStateImpl extends _ClassesState {
  const _$ClassesStateImpl(
      {final List<ClassSchedule> schedules = const [],
      final List<DaySchedule> weekSchedule = const [],
      this.selectedSchedule,
      this.selectedClass,
      final List<ClassBooking> myBookings = const [],
      final List<ClassBooking> upcomingBookings = const [],
      final List<ClassBooking> pastBookings = const [],
      this.filter = const ClassFilter(),
      this.scheduleStartDate,
      this.scheduleEndDate,
      this.scheduleStatus = ClassesStatus.initial,
      this.bookingsStatus = ClassesStatus.initial,
      this.bookingActionStatus = ClassesStatus.initial,
      this.errorMessage})
      : _schedules = schedules,
        _weekSchedule = weekSchedule,
        _myBookings = myBookings,
        _upcomingBookings = upcomingBookings,
        _pastBookings = pastBookings,
        super._();

// Schedule data
  final List<ClassSchedule> _schedules;
// Schedule data
  @override
  @JsonKey()
  List<ClassSchedule> get schedules {
    if (_schedules is EqualUnmodifiableListView) return _schedules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_schedules);
  }

  final List<DaySchedule> _weekSchedule;
  @override
  @JsonKey()
  List<DaySchedule> get weekSchedule {
    if (_weekSchedule is EqualUnmodifiableListView) return _weekSchedule;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weekSchedule);
  }

// Selected class detail
  @override
  final ClassSchedule? selectedSchedule;
  @override
  final FitnessClass? selectedClass;
// Bookings
  final List<ClassBooking> _myBookings;
// Bookings
  @override
  @JsonKey()
  List<ClassBooking> get myBookings {
    if (_myBookings is EqualUnmodifiableListView) return _myBookings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_myBookings);
  }

  final List<ClassBooking> _upcomingBookings;
  @override
  @JsonKey()
  List<ClassBooking> get upcomingBookings {
    if (_upcomingBookings is EqualUnmodifiableListView)
      return _upcomingBookings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_upcomingBookings);
  }

  final List<ClassBooking> _pastBookings;
  @override
  @JsonKey()
  List<ClassBooking> get pastBookings {
    if (_pastBookings is EqualUnmodifiableListView) return _pastBookings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pastBookings);
  }

// Filter
  @override
  @JsonKey()
  final ClassFilter filter;
// Date range for schedule
  @override
  final DateTime? scheduleStartDate;
  @override
  final DateTime? scheduleEndDate;
// Status
  @override
  @JsonKey()
  final ClassesStatus scheduleStatus;
  @override
  @JsonKey()
  final ClassesStatus bookingsStatus;
  @override
  @JsonKey()
  final ClassesStatus bookingActionStatus;
// Error
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'ClassesState(schedules: $schedules, weekSchedule: $weekSchedule, selectedSchedule: $selectedSchedule, selectedClass: $selectedClass, myBookings: $myBookings, upcomingBookings: $upcomingBookings, pastBookings: $pastBookings, filter: $filter, scheduleStartDate: $scheduleStartDate, scheduleEndDate: $scheduleEndDate, scheduleStatus: $scheduleStatus, bookingsStatus: $bookingsStatus, bookingActionStatus: $bookingActionStatus, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClassesStateImpl &&
            const DeepCollectionEquality()
                .equals(other._schedules, _schedules) &&
            const DeepCollectionEquality()
                .equals(other._weekSchedule, _weekSchedule) &&
            (identical(other.selectedSchedule, selectedSchedule) ||
                other.selectedSchedule == selectedSchedule) &&
            (identical(other.selectedClass, selectedClass) ||
                other.selectedClass == selectedClass) &&
            const DeepCollectionEquality()
                .equals(other._myBookings, _myBookings) &&
            const DeepCollectionEquality()
                .equals(other._upcomingBookings, _upcomingBookings) &&
            const DeepCollectionEquality()
                .equals(other._pastBookings, _pastBookings) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            (identical(other.scheduleStartDate, scheduleStartDate) ||
                other.scheduleStartDate == scheduleStartDate) &&
            (identical(other.scheduleEndDate, scheduleEndDate) ||
                other.scheduleEndDate == scheduleEndDate) &&
            (identical(other.scheduleStatus, scheduleStatus) ||
                other.scheduleStatus == scheduleStatus) &&
            (identical(other.bookingsStatus, bookingsStatus) ||
                other.bookingsStatus == bookingsStatus) &&
            (identical(other.bookingActionStatus, bookingActionStatus) ||
                other.bookingActionStatus == bookingActionStatus) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_schedules),
      const DeepCollectionEquality().hash(_weekSchedule),
      selectedSchedule,
      selectedClass,
      const DeepCollectionEquality().hash(_myBookings),
      const DeepCollectionEquality().hash(_upcomingBookings),
      const DeepCollectionEquality().hash(_pastBookings),
      filter,
      scheduleStartDate,
      scheduleEndDate,
      scheduleStatus,
      bookingsStatus,
      bookingActionStatus,
      errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ClassesStateImplCopyWith<_$ClassesStateImpl> get copyWith =>
      __$$ClassesStateImplCopyWithImpl<_$ClassesStateImpl>(this, _$identity);
}

abstract class _ClassesState extends ClassesState {
  const factory _ClassesState(
      {final List<ClassSchedule> schedules,
      final List<DaySchedule> weekSchedule,
      final ClassSchedule? selectedSchedule,
      final FitnessClass? selectedClass,
      final List<ClassBooking> myBookings,
      final List<ClassBooking> upcomingBookings,
      final List<ClassBooking> pastBookings,
      final ClassFilter filter,
      final DateTime? scheduleStartDate,
      final DateTime? scheduleEndDate,
      final ClassesStatus scheduleStatus,
      final ClassesStatus bookingsStatus,
      final ClassesStatus bookingActionStatus,
      final String? errorMessage}) = _$ClassesStateImpl;
  const _ClassesState._() : super._();

  @override // Schedule data
  List<ClassSchedule> get schedules;
  @override
  List<DaySchedule> get weekSchedule;
  @override // Selected class detail
  ClassSchedule? get selectedSchedule;
  @override
  FitnessClass? get selectedClass;
  @override // Bookings
  List<ClassBooking> get myBookings;
  @override
  List<ClassBooking> get upcomingBookings;
  @override
  List<ClassBooking> get pastBookings;
  @override // Filter
  ClassFilter get filter;
  @override // Date range for schedule
  DateTime? get scheduleStartDate;
  @override
  DateTime? get scheduleEndDate;
  @override // Status
  ClassesStatus get scheduleStatus;
  @override
  ClassesStatus get bookingsStatus;
  @override
  ClassesStatus get bookingActionStatus;
  @override // Error
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$ClassesStateImplCopyWith<_$ClassesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
