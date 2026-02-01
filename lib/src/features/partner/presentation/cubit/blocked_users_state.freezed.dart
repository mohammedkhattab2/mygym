// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocked_users_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BlockedUsersState {
// Data
  List<BlockedUser> get blockedUsers => throw _privateConstructorUsedError;
  List<BlockedUser> get filteredUsers => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError; // Status
  BlockedUsersStatus get loadStatus => throw _privateConstructorUsedError;
  BlockedUsersStatus get actionStatus =>
      throw _privateConstructorUsedError; // Messages
  String? get errorMessage => throw _privateConstructorUsedError;
  String? get successMessage =>
      throw _privateConstructorUsedError; // Selected user for unblock confirmation
  BlockedUser? get selectedUser => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BlockedUsersStateCopyWith<BlockedUsersState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockedUsersStateCopyWith<$Res> {
  factory $BlockedUsersStateCopyWith(
          BlockedUsersState value, $Res Function(BlockedUsersState) then) =
      _$BlockedUsersStateCopyWithImpl<$Res, BlockedUsersState>;
  @useResult
  $Res call(
      {List<BlockedUser> blockedUsers,
      List<BlockedUser> filteredUsers,
      String searchQuery,
      BlockedUsersStatus loadStatus,
      BlockedUsersStatus actionStatus,
      String? errorMessage,
      String? successMessage,
      BlockedUser? selectedUser});
}

/// @nodoc
class _$BlockedUsersStateCopyWithImpl<$Res, $Val extends BlockedUsersState>
    implements $BlockedUsersStateCopyWith<$Res> {
  _$BlockedUsersStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blockedUsers = null,
    Object? filteredUsers = null,
    Object? searchQuery = null,
    Object? loadStatus = null,
    Object? actionStatus = null,
    Object? errorMessage = freezed,
    Object? successMessage = freezed,
    Object? selectedUser = freezed,
  }) {
    return _then(_value.copyWith(
      blockedUsers: null == blockedUsers
          ? _value.blockedUsers
          : blockedUsers // ignore: cast_nullable_to_non_nullable
              as List<BlockedUser>,
      filteredUsers: null == filteredUsers
          ? _value.filteredUsers
          : filteredUsers // ignore: cast_nullable_to_non_nullable
              as List<BlockedUser>,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      loadStatus: null == loadStatus
          ? _value.loadStatus
          : loadStatus // ignore: cast_nullable_to_non_nullable
              as BlockedUsersStatus,
      actionStatus: null == actionStatus
          ? _value.actionStatus
          : actionStatus // ignore: cast_nullable_to_non_nullable
              as BlockedUsersStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      successMessage: freezed == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedUser: freezed == selectedUser
          ? _value.selectedUser
          : selectedUser // ignore: cast_nullable_to_non_nullable
              as BlockedUser?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BlockedUsersStateImplCopyWith<$Res>
    implements $BlockedUsersStateCopyWith<$Res> {
  factory _$$BlockedUsersStateImplCopyWith(_$BlockedUsersStateImpl value,
          $Res Function(_$BlockedUsersStateImpl) then) =
      __$$BlockedUsersStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<BlockedUser> blockedUsers,
      List<BlockedUser> filteredUsers,
      String searchQuery,
      BlockedUsersStatus loadStatus,
      BlockedUsersStatus actionStatus,
      String? errorMessage,
      String? successMessage,
      BlockedUser? selectedUser});
}

/// @nodoc
class __$$BlockedUsersStateImplCopyWithImpl<$Res>
    extends _$BlockedUsersStateCopyWithImpl<$Res, _$BlockedUsersStateImpl>
    implements _$$BlockedUsersStateImplCopyWith<$Res> {
  __$$BlockedUsersStateImplCopyWithImpl(_$BlockedUsersStateImpl _value,
      $Res Function(_$BlockedUsersStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blockedUsers = null,
    Object? filteredUsers = null,
    Object? searchQuery = null,
    Object? loadStatus = null,
    Object? actionStatus = null,
    Object? errorMessage = freezed,
    Object? successMessage = freezed,
    Object? selectedUser = freezed,
  }) {
    return _then(_$BlockedUsersStateImpl(
      blockedUsers: null == blockedUsers
          ? _value._blockedUsers
          : blockedUsers // ignore: cast_nullable_to_non_nullable
              as List<BlockedUser>,
      filteredUsers: null == filteredUsers
          ? _value._filteredUsers
          : filteredUsers // ignore: cast_nullable_to_non_nullable
              as List<BlockedUser>,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      loadStatus: null == loadStatus
          ? _value.loadStatus
          : loadStatus // ignore: cast_nullable_to_non_nullable
              as BlockedUsersStatus,
      actionStatus: null == actionStatus
          ? _value.actionStatus
          : actionStatus // ignore: cast_nullable_to_non_nullable
              as BlockedUsersStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      successMessage: freezed == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedUser: freezed == selectedUser
          ? _value.selectedUser
          : selectedUser // ignore: cast_nullable_to_non_nullable
              as BlockedUser?,
    ));
  }
}

/// @nodoc

class _$BlockedUsersStateImpl extends _BlockedUsersState {
  const _$BlockedUsersStateImpl(
      {final List<BlockedUser> blockedUsers = const [],
      final List<BlockedUser> filteredUsers = const [],
      this.searchQuery = '',
      this.loadStatus = BlockedUsersStatus.initial,
      this.actionStatus = BlockedUsersStatus.initial,
      this.errorMessage,
      this.successMessage,
      this.selectedUser})
      : _blockedUsers = blockedUsers,
        _filteredUsers = filteredUsers,
        super._();

// Data
  final List<BlockedUser> _blockedUsers;
// Data
  @override
  @JsonKey()
  List<BlockedUser> get blockedUsers {
    if (_blockedUsers is EqualUnmodifiableListView) return _blockedUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blockedUsers);
  }

  final List<BlockedUser> _filteredUsers;
  @override
  @JsonKey()
  List<BlockedUser> get filteredUsers {
    if (_filteredUsers is EqualUnmodifiableListView) return _filteredUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredUsers);
  }

  @override
  @JsonKey()
  final String searchQuery;
// Status
  @override
  @JsonKey()
  final BlockedUsersStatus loadStatus;
  @override
  @JsonKey()
  final BlockedUsersStatus actionStatus;
// Messages
  @override
  final String? errorMessage;
  @override
  final String? successMessage;
// Selected user for unblock confirmation
  @override
  final BlockedUser? selectedUser;

  @override
  String toString() {
    return 'BlockedUsersState(blockedUsers: $blockedUsers, filteredUsers: $filteredUsers, searchQuery: $searchQuery, loadStatus: $loadStatus, actionStatus: $actionStatus, errorMessage: $errorMessage, successMessage: $successMessage, selectedUser: $selectedUser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlockedUsersStateImpl &&
            const DeepCollectionEquality()
                .equals(other._blockedUsers, _blockedUsers) &&
            const DeepCollectionEquality()
                .equals(other._filteredUsers, _filteredUsers) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.loadStatus, loadStatus) ||
                other.loadStatus == loadStatus) &&
            (identical(other.actionStatus, actionStatus) ||
                other.actionStatus == actionStatus) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.successMessage, successMessage) ||
                other.successMessage == successMessage) &&
            (identical(other.selectedUser, selectedUser) ||
                other.selectedUser == selectedUser));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_blockedUsers),
      const DeepCollectionEquality().hash(_filteredUsers),
      searchQuery,
      loadStatus,
      actionStatus,
      errorMessage,
      successMessage,
      selectedUser);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlockedUsersStateImplCopyWith<_$BlockedUsersStateImpl> get copyWith =>
      __$$BlockedUsersStateImplCopyWithImpl<_$BlockedUsersStateImpl>(
          this, _$identity);
}

abstract class _BlockedUsersState extends BlockedUsersState {
  const factory _BlockedUsersState(
      {final List<BlockedUser> blockedUsers,
      final List<BlockedUser> filteredUsers,
      final String searchQuery,
      final BlockedUsersStatus loadStatus,
      final BlockedUsersStatus actionStatus,
      final String? errorMessage,
      final String? successMessage,
      final BlockedUser? selectedUser}) = _$BlockedUsersStateImpl;
  const _BlockedUsersState._() : super._();

  @override // Data
  List<BlockedUser> get blockedUsers;
  @override
  List<BlockedUser> get filteredUsers;
  @override
  String get searchQuery;
  @override // Status
  BlockedUsersStatus get loadStatus;
  @override
  BlockedUsersStatus get actionStatus;
  @override // Messages
  String? get errorMessage;
  @override
  String? get successMessage;
  @override // Selected user for unblock confirmation
  BlockedUser? get selectedUser;
  @override
  @JsonKey(ignore: true)
  _$$BlockedUsersStateImplCopyWith<_$BlockedUsersStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
