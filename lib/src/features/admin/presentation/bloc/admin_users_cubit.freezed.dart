// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_users_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AdminUsersState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            UsersStats stats,
            List<AdminUser> users,
            int totalUsers,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminUserFilter filter,
            bool isLoadingMore,
            Set<String> selectedUserIds)
        loaded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            UsersStats stats,
            List<AdminUser> users,
            int totalUsers,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminUserFilter filter,
            bool isLoadingMore,
            Set<String> selectedUserIds)?
        loaded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            UsersStats stats,
            List<AdminUser> users,
            int totalUsers,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminUserFilter filter,
            bool isLoadingMore,
            Set<String> selectedUserIds)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AdminUsersInitial value) initial,
    required TResult Function(AdminUsersLoading value) loading,
    required TResult Function(AdminUsersLoaded value) loaded,
    required TResult Function(AdminUsersError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdminUsersInitial value)? initial,
    TResult? Function(AdminUsersLoading value)? loading,
    TResult? Function(AdminUsersLoaded value)? loaded,
    TResult? Function(AdminUsersError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdminUsersInitial value)? initial,
    TResult Function(AdminUsersLoading value)? loading,
    TResult Function(AdminUsersLoaded value)? loaded,
    TResult Function(AdminUsersError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminUsersStateCopyWith<$Res> {
  factory $AdminUsersStateCopyWith(
          AdminUsersState value, $Res Function(AdminUsersState) then) =
      _$AdminUsersStateCopyWithImpl<$Res, AdminUsersState>;
}

/// @nodoc
class _$AdminUsersStateCopyWithImpl<$Res, $Val extends AdminUsersState>
    implements $AdminUsersStateCopyWith<$Res> {
  _$AdminUsersStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AdminUsersInitialImplCopyWith<$Res> {
  factory _$$AdminUsersInitialImplCopyWith(_$AdminUsersInitialImpl value,
          $Res Function(_$AdminUsersInitialImpl) then) =
      __$$AdminUsersInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AdminUsersInitialImplCopyWithImpl<$Res>
    extends _$AdminUsersStateCopyWithImpl<$Res, _$AdminUsersInitialImpl>
    implements _$$AdminUsersInitialImplCopyWith<$Res> {
  __$$AdminUsersInitialImplCopyWithImpl(_$AdminUsersInitialImpl _value,
      $Res Function(_$AdminUsersInitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AdminUsersInitialImpl implements AdminUsersInitial {
  const _$AdminUsersInitialImpl();

  @override
  String toString() {
    return 'AdminUsersState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AdminUsersInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            UsersStats stats,
            List<AdminUser> users,
            int totalUsers,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminUserFilter filter,
            bool isLoadingMore,
            Set<String> selectedUserIds)
        loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            UsersStats stats,
            List<AdminUser> users,
            int totalUsers,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminUserFilter filter,
            bool isLoadingMore,
            Set<String> selectedUserIds)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            UsersStats stats,
            List<AdminUser> users,
            int totalUsers,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminUserFilter filter,
            bool isLoadingMore,
            Set<String> selectedUserIds)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AdminUsersInitial value) initial,
    required TResult Function(AdminUsersLoading value) loading,
    required TResult Function(AdminUsersLoaded value) loaded,
    required TResult Function(AdminUsersError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdminUsersInitial value)? initial,
    TResult? Function(AdminUsersLoading value)? loading,
    TResult? Function(AdminUsersLoaded value)? loaded,
    TResult? Function(AdminUsersError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdminUsersInitial value)? initial,
    TResult Function(AdminUsersLoading value)? loading,
    TResult Function(AdminUsersLoaded value)? loaded,
    TResult Function(AdminUsersError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class AdminUsersInitial implements AdminUsersState {
  const factory AdminUsersInitial() = _$AdminUsersInitialImpl;
}

/// @nodoc
abstract class _$$AdminUsersLoadingImplCopyWith<$Res> {
  factory _$$AdminUsersLoadingImplCopyWith(_$AdminUsersLoadingImpl value,
          $Res Function(_$AdminUsersLoadingImpl) then) =
      __$$AdminUsersLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AdminUsersLoadingImplCopyWithImpl<$Res>
    extends _$AdminUsersStateCopyWithImpl<$Res, _$AdminUsersLoadingImpl>
    implements _$$AdminUsersLoadingImplCopyWith<$Res> {
  __$$AdminUsersLoadingImplCopyWithImpl(_$AdminUsersLoadingImpl _value,
      $Res Function(_$AdminUsersLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AdminUsersLoadingImpl implements AdminUsersLoading {
  const _$AdminUsersLoadingImpl();

  @override
  String toString() {
    return 'AdminUsersState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AdminUsersLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            UsersStats stats,
            List<AdminUser> users,
            int totalUsers,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminUserFilter filter,
            bool isLoadingMore,
            Set<String> selectedUserIds)
        loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            UsersStats stats,
            List<AdminUser> users,
            int totalUsers,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminUserFilter filter,
            bool isLoadingMore,
            Set<String> selectedUserIds)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            UsersStats stats,
            List<AdminUser> users,
            int totalUsers,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminUserFilter filter,
            bool isLoadingMore,
            Set<String> selectedUserIds)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AdminUsersInitial value) initial,
    required TResult Function(AdminUsersLoading value) loading,
    required TResult Function(AdminUsersLoaded value) loaded,
    required TResult Function(AdminUsersError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdminUsersInitial value)? initial,
    TResult? Function(AdminUsersLoading value)? loading,
    TResult? Function(AdminUsersLoaded value)? loaded,
    TResult? Function(AdminUsersError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdminUsersInitial value)? initial,
    TResult Function(AdminUsersLoading value)? loading,
    TResult Function(AdminUsersLoaded value)? loaded,
    TResult Function(AdminUsersError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class AdminUsersLoading implements AdminUsersState {
  const factory AdminUsersLoading() = _$AdminUsersLoadingImpl;
}

/// @nodoc
abstract class _$$AdminUsersLoadedImplCopyWith<$Res> {
  factory _$$AdminUsersLoadedImplCopyWith(_$AdminUsersLoadedImpl value,
          $Res Function(_$AdminUsersLoadedImpl) then) =
      __$$AdminUsersLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {UsersStats stats,
      List<AdminUser> users,
      int totalUsers,
      int currentPage,
      int totalPages,
      bool hasMore,
      AdminUserFilter filter,
      bool isLoadingMore,
      Set<String> selectedUserIds});
}

/// @nodoc
class __$$AdminUsersLoadedImplCopyWithImpl<$Res>
    extends _$AdminUsersStateCopyWithImpl<$Res, _$AdminUsersLoadedImpl>
    implements _$$AdminUsersLoadedImplCopyWith<$Res> {
  __$$AdminUsersLoadedImplCopyWithImpl(_$AdminUsersLoadedImpl _value,
      $Res Function(_$AdminUsersLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stats = null,
    Object? users = null,
    Object? totalUsers = null,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? hasMore = null,
    Object? filter = null,
    Object? isLoadingMore = null,
    Object? selectedUserIds = null,
  }) {
    return _then(_$AdminUsersLoadedImpl(
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as UsersStats,
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<AdminUser>,
      totalUsers: null == totalUsers
          ? _value.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as AdminUserFilter,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedUserIds: null == selectedUserIds
          ? _value._selectedUserIds
          : selectedUserIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
    ));
  }
}

/// @nodoc

class _$AdminUsersLoadedImpl implements AdminUsersLoaded {
  const _$AdminUsersLoadedImpl(
      {required this.stats,
      required final List<AdminUser> users,
      required this.totalUsers,
      required this.currentPage,
      required this.totalPages,
      required this.hasMore,
      required this.filter,
      this.isLoadingMore = false,
      final Set<String> selectedUserIds = const <String>{}})
      : _users = users,
        _selectedUserIds = selectedUserIds;

  @override
  final UsersStats stats;
  final List<AdminUser> _users;
  @override
  List<AdminUser> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  final int totalUsers;
  @override
  final int currentPage;
  @override
  final int totalPages;
  @override
  final bool hasMore;
  @override
  final AdminUserFilter filter;
  @override
  @JsonKey()
  final bool isLoadingMore;
  final Set<String> _selectedUserIds;
  @override
  @JsonKey()
  Set<String> get selectedUserIds {
    if (_selectedUserIds is EqualUnmodifiableSetView) return _selectedUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedUserIds);
  }

  @override
  String toString() {
    return 'AdminUsersState.loaded(stats: $stats, users: $users, totalUsers: $totalUsers, currentPage: $currentPage, totalPages: $totalPages, hasMore: $hasMore, filter: $filter, isLoadingMore: $isLoadingMore, selectedUserIds: $selectedUserIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminUsersLoadedImpl &&
            (identical(other.stats, stats) || other.stats == stats) &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            (identical(other.totalUsers, totalUsers) ||
                other.totalUsers == totalUsers) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            const DeepCollectionEquality()
                .equals(other._selectedUserIds, _selectedUserIds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      stats,
      const DeepCollectionEquality().hash(_users),
      totalUsers,
      currentPage,
      totalPages,
      hasMore,
      filter,
      isLoadingMore,
      const DeepCollectionEquality().hash(_selectedUserIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminUsersLoadedImplCopyWith<_$AdminUsersLoadedImpl> get copyWith =>
      __$$AdminUsersLoadedImplCopyWithImpl<_$AdminUsersLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            UsersStats stats,
            List<AdminUser> users,
            int totalUsers,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminUserFilter filter,
            bool isLoadingMore,
            Set<String> selectedUserIds)
        loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(stats, users, totalUsers, currentPage, totalPages, hasMore,
        filter, isLoadingMore, selectedUserIds);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            UsersStats stats,
            List<AdminUser> users,
            int totalUsers,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminUserFilter filter,
            bool isLoadingMore,
            Set<String> selectedUserIds)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(stats, users, totalUsers, currentPage, totalPages,
        hasMore, filter, isLoadingMore, selectedUserIds);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            UsersStats stats,
            List<AdminUser> users,
            int totalUsers,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminUserFilter filter,
            bool isLoadingMore,
            Set<String> selectedUserIds)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(stats, users, totalUsers, currentPage, totalPages, hasMore,
          filter, isLoadingMore, selectedUserIds);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AdminUsersInitial value) initial,
    required TResult Function(AdminUsersLoading value) loading,
    required TResult Function(AdminUsersLoaded value) loaded,
    required TResult Function(AdminUsersError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdminUsersInitial value)? initial,
    TResult? Function(AdminUsersLoading value)? loading,
    TResult? Function(AdminUsersLoaded value)? loaded,
    TResult? Function(AdminUsersError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdminUsersInitial value)? initial,
    TResult Function(AdminUsersLoading value)? loading,
    TResult Function(AdminUsersLoaded value)? loaded,
    TResult Function(AdminUsersError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class AdminUsersLoaded implements AdminUsersState {
  const factory AdminUsersLoaded(
      {required final UsersStats stats,
      required final List<AdminUser> users,
      required final int totalUsers,
      required final int currentPage,
      required final int totalPages,
      required final bool hasMore,
      required final AdminUserFilter filter,
      final bool isLoadingMore,
      final Set<String> selectedUserIds}) = _$AdminUsersLoadedImpl;

  UsersStats get stats;
  List<AdminUser> get users;
  int get totalUsers;
  int get currentPage;
  int get totalPages;
  bool get hasMore;
  AdminUserFilter get filter;
  bool get isLoadingMore;
  Set<String> get selectedUserIds;
  @JsonKey(ignore: true)
  _$$AdminUsersLoadedImplCopyWith<_$AdminUsersLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AdminUsersErrorImplCopyWith<$Res> {
  factory _$$AdminUsersErrorImplCopyWith(_$AdminUsersErrorImpl value,
          $Res Function(_$AdminUsersErrorImpl) then) =
      __$$AdminUsersErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$AdminUsersErrorImplCopyWithImpl<$Res>
    extends _$AdminUsersStateCopyWithImpl<$Res, _$AdminUsersErrorImpl>
    implements _$$AdminUsersErrorImplCopyWith<$Res> {
  __$$AdminUsersErrorImplCopyWithImpl(
      _$AdminUsersErrorImpl _value, $Res Function(_$AdminUsersErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$AdminUsersErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AdminUsersErrorImpl implements AdminUsersError {
  const _$AdminUsersErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'AdminUsersState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminUsersErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminUsersErrorImplCopyWith<_$AdminUsersErrorImpl> get copyWith =>
      __$$AdminUsersErrorImplCopyWithImpl<_$AdminUsersErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            UsersStats stats,
            List<AdminUser> users,
            int totalUsers,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminUserFilter filter,
            bool isLoadingMore,
            Set<String> selectedUserIds)
        loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            UsersStats stats,
            List<AdminUser> users,
            int totalUsers,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminUserFilter filter,
            bool isLoadingMore,
            Set<String> selectedUserIds)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            UsersStats stats,
            List<AdminUser> users,
            int totalUsers,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminUserFilter filter,
            bool isLoadingMore,
            Set<String> selectedUserIds)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AdminUsersInitial value) initial,
    required TResult Function(AdminUsersLoading value) loading,
    required TResult Function(AdminUsersLoaded value) loaded,
    required TResult Function(AdminUsersError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdminUsersInitial value)? initial,
    TResult? Function(AdminUsersLoading value)? loading,
    TResult? Function(AdminUsersLoaded value)? loaded,
    TResult? Function(AdminUsersError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdminUsersInitial value)? initial,
    TResult Function(AdminUsersLoading value)? loading,
    TResult Function(AdminUsersLoaded value)? loaded,
    TResult Function(AdminUsersError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class AdminUsersError implements AdminUsersState {
  const factory AdminUsersError(final String message) = _$AdminUsersErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$AdminUsersErrorImplCopyWith<_$AdminUsersErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
