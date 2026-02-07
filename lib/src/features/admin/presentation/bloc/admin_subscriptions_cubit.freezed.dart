// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_subscriptions_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AdminSubscriptionsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            SubscriptionsStats stats,
            List<AdminSubscription> subscriptions,
            int totalCount,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminSubscriptionFilter filter,
            bool isLoadingMore)
        loaded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            SubscriptionsStats stats,
            List<AdminSubscription> subscriptions,
            int totalCount,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminSubscriptionFilter filter,
            bool isLoadingMore)?
        loaded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            SubscriptionsStats stats,
            List<AdminSubscription> subscriptions,
            int totalCount,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminSubscriptionFilter filter,
            bool isLoadingMore)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AdminSubscriptionsInitial value) initial,
    required TResult Function(AdminSubscriptionsLoading value) loading,
    required TResult Function(AdminSubscriptionsLoaded value) loaded,
    required TResult Function(AdminSubscriptionsError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdminSubscriptionsInitial value)? initial,
    TResult? Function(AdminSubscriptionsLoading value)? loading,
    TResult? Function(AdminSubscriptionsLoaded value)? loaded,
    TResult? Function(AdminSubscriptionsError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdminSubscriptionsInitial value)? initial,
    TResult Function(AdminSubscriptionsLoading value)? loading,
    TResult Function(AdminSubscriptionsLoaded value)? loaded,
    TResult Function(AdminSubscriptionsError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminSubscriptionsStateCopyWith<$Res> {
  factory $AdminSubscriptionsStateCopyWith(AdminSubscriptionsState value,
          $Res Function(AdminSubscriptionsState) then) =
      _$AdminSubscriptionsStateCopyWithImpl<$Res, AdminSubscriptionsState>;
}

/// @nodoc
class _$AdminSubscriptionsStateCopyWithImpl<$Res,
        $Val extends AdminSubscriptionsState>
    implements $AdminSubscriptionsStateCopyWith<$Res> {
  _$AdminSubscriptionsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AdminSubscriptionsInitialImplCopyWith<$Res> {
  factory _$$AdminSubscriptionsInitialImplCopyWith(
          _$AdminSubscriptionsInitialImpl value,
          $Res Function(_$AdminSubscriptionsInitialImpl) then) =
      __$$AdminSubscriptionsInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AdminSubscriptionsInitialImplCopyWithImpl<$Res>
    extends _$AdminSubscriptionsStateCopyWithImpl<$Res,
        _$AdminSubscriptionsInitialImpl>
    implements _$$AdminSubscriptionsInitialImplCopyWith<$Res> {
  __$$AdminSubscriptionsInitialImplCopyWithImpl(
      _$AdminSubscriptionsInitialImpl _value,
      $Res Function(_$AdminSubscriptionsInitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AdminSubscriptionsInitialImpl implements AdminSubscriptionsInitial {
  const _$AdminSubscriptionsInitialImpl();

  @override
  String toString() {
    return 'AdminSubscriptionsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminSubscriptionsInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            SubscriptionsStats stats,
            List<AdminSubscription> subscriptions,
            int totalCount,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminSubscriptionFilter filter,
            bool isLoadingMore)
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
            SubscriptionsStats stats,
            List<AdminSubscription> subscriptions,
            int totalCount,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminSubscriptionFilter filter,
            bool isLoadingMore)?
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
            SubscriptionsStats stats,
            List<AdminSubscription> subscriptions,
            int totalCount,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminSubscriptionFilter filter,
            bool isLoadingMore)?
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
    required TResult Function(AdminSubscriptionsInitial value) initial,
    required TResult Function(AdminSubscriptionsLoading value) loading,
    required TResult Function(AdminSubscriptionsLoaded value) loaded,
    required TResult Function(AdminSubscriptionsError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdminSubscriptionsInitial value)? initial,
    TResult? Function(AdminSubscriptionsLoading value)? loading,
    TResult? Function(AdminSubscriptionsLoaded value)? loaded,
    TResult? Function(AdminSubscriptionsError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdminSubscriptionsInitial value)? initial,
    TResult Function(AdminSubscriptionsLoading value)? loading,
    TResult Function(AdminSubscriptionsLoaded value)? loaded,
    TResult Function(AdminSubscriptionsError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class AdminSubscriptionsInitial implements AdminSubscriptionsState {
  const factory AdminSubscriptionsInitial() = _$AdminSubscriptionsInitialImpl;
}

/// @nodoc
abstract class _$$AdminSubscriptionsLoadingImplCopyWith<$Res> {
  factory _$$AdminSubscriptionsLoadingImplCopyWith(
          _$AdminSubscriptionsLoadingImpl value,
          $Res Function(_$AdminSubscriptionsLoadingImpl) then) =
      __$$AdminSubscriptionsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AdminSubscriptionsLoadingImplCopyWithImpl<$Res>
    extends _$AdminSubscriptionsStateCopyWithImpl<$Res,
        _$AdminSubscriptionsLoadingImpl>
    implements _$$AdminSubscriptionsLoadingImplCopyWith<$Res> {
  __$$AdminSubscriptionsLoadingImplCopyWithImpl(
      _$AdminSubscriptionsLoadingImpl _value,
      $Res Function(_$AdminSubscriptionsLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AdminSubscriptionsLoadingImpl implements AdminSubscriptionsLoading {
  const _$AdminSubscriptionsLoadingImpl();

  @override
  String toString() {
    return 'AdminSubscriptionsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminSubscriptionsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            SubscriptionsStats stats,
            List<AdminSubscription> subscriptions,
            int totalCount,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminSubscriptionFilter filter,
            bool isLoadingMore)
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
            SubscriptionsStats stats,
            List<AdminSubscription> subscriptions,
            int totalCount,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminSubscriptionFilter filter,
            bool isLoadingMore)?
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
            SubscriptionsStats stats,
            List<AdminSubscription> subscriptions,
            int totalCount,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminSubscriptionFilter filter,
            bool isLoadingMore)?
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
    required TResult Function(AdminSubscriptionsInitial value) initial,
    required TResult Function(AdminSubscriptionsLoading value) loading,
    required TResult Function(AdminSubscriptionsLoaded value) loaded,
    required TResult Function(AdminSubscriptionsError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdminSubscriptionsInitial value)? initial,
    TResult? Function(AdminSubscriptionsLoading value)? loading,
    TResult? Function(AdminSubscriptionsLoaded value)? loaded,
    TResult? Function(AdminSubscriptionsError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdminSubscriptionsInitial value)? initial,
    TResult Function(AdminSubscriptionsLoading value)? loading,
    TResult Function(AdminSubscriptionsLoaded value)? loaded,
    TResult Function(AdminSubscriptionsError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class AdminSubscriptionsLoading implements AdminSubscriptionsState {
  const factory AdminSubscriptionsLoading() = _$AdminSubscriptionsLoadingImpl;
}

/// @nodoc
abstract class _$$AdminSubscriptionsLoadedImplCopyWith<$Res> {
  factory _$$AdminSubscriptionsLoadedImplCopyWith(
          _$AdminSubscriptionsLoadedImpl value,
          $Res Function(_$AdminSubscriptionsLoadedImpl) then) =
      __$$AdminSubscriptionsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {SubscriptionsStats stats,
      List<AdminSubscription> subscriptions,
      int totalCount,
      int currentPage,
      int totalPages,
      bool hasMore,
      AdminSubscriptionFilter filter,
      bool isLoadingMore});
}

/// @nodoc
class __$$AdminSubscriptionsLoadedImplCopyWithImpl<$Res>
    extends _$AdminSubscriptionsStateCopyWithImpl<$Res,
        _$AdminSubscriptionsLoadedImpl>
    implements _$$AdminSubscriptionsLoadedImplCopyWith<$Res> {
  __$$AdminSubscriptionsLoadedImplCopyWithImpl(
      _$AdminSubscriptionsLoadedImpl _value,
      $Res Function(_$AdminSubscriptionsLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stats = null,
    Object? subscriptions = null,
    Object? totalCount = null,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? hasMore = null,
    Object? filter = null,
    Object? isLoadingMore = null,
  }) {
    return _then(_$AdminSubscriptionsLoadedImpl(
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as SubscriptionsStats,
      subscriptions: null == subscriptions
          ? _value._subscriptions
          : subscriptions // ignore: cast_nullable_to_non_nullable
              as List<AdminSubscription>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
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
              as AdminSubscriptionFilter,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AdminSubscriptionsLoadedImpl implements AdminSubscriptionsLoaded {
  const _$AdminSubscriptionsLoadedImpl(
      {required this.stats,
      required final List<AdminSubscription> subscriptions,
      required this.totalCount,
      required this.currentPage,
      required this.totalPages,
      required this.hasMore,
      required this.filter,
      this.isLoadingMore = false})
      : _subscriptions = subscriptions;

  @override
  final SubscriptionsStats stats;
  final List<AdminSubscription> _subscriptions;
  @override
  List<AdminSubscription> get subscriptions {
    if (_subscriptions is EqualUnmodifiableListView) return _subscriptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subscriptions);
  }

  @override
  final int totalCount;
  @override
  final int currentPage;
  @override
  final int totalPages;
  @override
  final bool hasMore;
  @override
  final AdminSubscriptionFilter filter;
  @override
  @JsonKey()
  final bool isLoadingMore;

  @override
  String toString() {
    return 'AdminSubscriptionsState.loaded(stats: $stats, subscriptions: $subscriptions, totalCount: $totalCount, currentPage: $currentPage, totalPages: $totalPages, hasMore: $hasMore, filter: $filter, isLoadingMore: $isLoadingMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminSubscriptionsLoadedImpl &&
            (identical(other.stats, stats) || other.stats == stats) &&
            const DeepCollectionEquality()
                .equals(other._subscriptions, _subscriptions) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      stats,
      const DeepCollectionEquality().hash(_subscriptions),
      totalCount,
      currentPage,
      totalPages,
      hasMore,
      filter,
      isLoadingMore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminSubscriptionsLoadedImplCopyWith<_$AdminSubscriptionsLoadedImpl>
      get copyWith => __$$AdminSubscriptionsLoadedImplCopyWithImpl<
          _$AdminSubscriptionsLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            SubscriptionsStats stats,
            List<AdminSubscription> subscriptions,
            int totalCount,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminSubscriptionFilter filter,
            bool isLoadingMore)
        loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(stats, subscriptions, totalCount, currentPage, totalPages,
        hasMore, filter, isLoadingMore);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            SubscriptionsStats stats,
            List<AdminSubscription> subscriptions,
            int totalCount,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminSubscriptionFilter filter,
            bool isLoadingMore)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(stats, subscriptions, totalCount, currentPage,
        totalPages, hasMore, filter, isLoadingMore);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            SubscriptionsStats stats,
            List<AdminSubscription> subscriptions,
            int totalCount,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminSubscriptionFilter filter,
            bool isLoadingMore)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(stats, subscriptions, totalCount, currentPage, totalPages,
          hasMore, filter, isLoadingMore);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AdminSubscriptionsInitial value) initial,
    required TResult Function(AdminSubscriptionsLoading value) loading,
    required TResult Function(AdminSubscriptionsLoaded value) loaded,
    required TResult Function(AdminSubscriptionsError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdminSubscriptionsInitial value)? initial,
    TResult? Function(AdminSubscriptionsLoading value)? loading,
    TResult? Function(AdminSubscriptionsLoaded value)? loaded,
    TResult? Function(AdminSubscriptionsError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdminSubscriptionsInitial value)? initial,
    TResult Function(AdminSubscriptionsLoading value)? loading,
    TResult Function(AdminSubscriptionsLoaded value)? loaded,
    TResult Function(AdminSubscriptionsError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class AdminSubscriptionsLoaded implements AdminSubscriptionsState {
  const factory AdminSubscriptionsLoaded(
      {required final SubscriptionsStats stats,
      required final List<AdminSubscription> subscriptions,
      required final int totalCount,
      required final int currentPage,
      required final int totalPages,
      required final bool hasMore,
      required final AdminSubscriptionFilter filter,
      final bool isLoadingMore}) = _$AdminSubscriptionsLoadedImpl;

  SubscriptionsStats get stats;
  List<AdminSubscription> get subscriptions;
  int get totalCount;
  int get currentPage;
  int get totalPages;
  bool get hasMore;
  AdminSubscriptionFilter get filter;
  bool get isLoadingMore;
  @JsonKey(ignore: true)
  _$$AdminSubscriptionsLoadedImplCopyWith<_$AdminSubscriptionsLoadedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AdminSubscriptionsErrorImplCopyWith<$Res> {
  factory _$$AdminSubscriptionsErrorImplCopyWith(
          _$AdminSubscriptionsErrorImpl value,
          $Res Function(_$AdminSubscriptionsErrorImpl) then) =
      __$$AdminSubscriptionsErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$AdminSubscriptionsErrorImplCopyWithImpl<$Res>
    extends _$AdminSubscriptionsStateCopyWithImpl<$Res,
        _$AdminSubscriptionsErrorImpl>
    implements _$$AdminSubscriptionsErrorImplCopyWith<$Res> {
  __$$AdminSubscriptionsErrorImplCopyWithImpl(
      _$AdminSubscriptionsErrorImpl _value,
      $Res Function(_$AdminSubscriptionsErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$AdminSubscriptionsErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AdminSubscriptionsErrorImpl implements AdminSubscriptionsError {
  const _$AdminSubscriptionsErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'AdminSubscriptionsState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminSubscriptionsErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminSubscriptionsErrorImplCopyWith<_$AdminSubscriptionsErrorImpl>
      get copyWith => __$$AdminSubscriptionsErrorImplCopyWithImpl<
          _$AdminSubscriptionsErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            SubscriptionsStats stats,
            List<AdminSubscription> subscriptions,
            int totalCount,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminSubscriptionFilter filter,
            bool isLoadingMore)
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
            SubscriptionsStats stats,
            List<AdminSubscription> subscriptions,
            int totalCount,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminSubscriptionFilter filter,
            bool isLoadingMore)?
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
            SubscriptionsStats stats,
            List<AdminSubscription> subscriptions,
            int totalCount,
            int currentPage,
            int totalPages,
            bool hasMore,
            AdminSubscriptionFilter filter,
            bool isLoadingMore)?
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
    required TResult Function(AdminSubscriptionsInitial value) initial,
    required TResult Function(AdminSubscriptionsLoading value) loading,
    required TResult Function(AdminSubscriptionsLoaded value) loaded,
    required TResult Function(AdminSubscriptionsError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AdminSubscriptionsInitial value)? initial,
    TResult? Function(AdminSubscriptionsLoading value)? loading,
    TResult? Function(AdminSubscriptionsLoaded value)? loaded,
    TResult? Function(AdminSubscriptionsError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AdminSubscriptionsInitial value)? initial,
    TResult Function(AdminSubscriptionsLoading value)? loading,
    TResult Function(AdminSubscriptionsLoaded value)? loaded,
    TResult Function(AdminSubscriptionsError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class AdminSubscriptionsError implements AdminSubscriptionsState {
  const factory AdminSubscriptionsError(final String message) =
      _$AdminSubscriptionsErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$AdminSubscriptionsErrorImplCopyWith<_$AdminSubscriptionsErrorImpl>
      get copyWith => throw _privateConstructorUsedError;
}
