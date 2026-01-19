// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gyms_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GymsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GymFilter? filter, int page, bool refresh)
        loadGyms,
    required TResult Function() loadMore,
    required TResult Function(String query) search,
    required TResult Function() clearSearch,
    required TResult Function(GymFilter filter) applyFilter,
    required TResult Function() clearFilters,
    required TResult Function(String gymId) toggleFavorite,
    required TResult Function(double latitude, double longitude) updateLocation,
    required TResult Function(String gymId) selectGym,
    required TResult Function(String gymId) loadGymDetails,
    required TResult Function(String gymId) loadReviews,
    required TResult Function(String gymId, int rating, String? comment)
        submitReview,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult? Function()? loadMore,
    TResult? Function(String query)? search,
    TResult? Function()? clearSearch,
    TResult? Function(GymFilter filter)? applyFilter,
    TResult? Function()? clearFilters,
    TResult? Function(String gymId)? toggleFavorite,
    TResult? Function(double latitude, double longitude)? updateLocation,
    TResult? Function(String gymId)? selectGym,
    TResult? Function(String gymId)? loadGymDetails,
    TResult? Function(String gymId)? loadReviews,
    TResult? Function(String gymId, int rating, String? comment)? submitReview,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult Function()? loadMore,
    TResult Function(String query)? search,
    TResult Function()? clearSearch,
    TResult Function(GymFilter filter)? applyFilter,
    TResult Function()? clearFilters,
    TResult Function(String gymId)? toggleFavorite,
    TResult Function(double latitude, double longitude)? updateLocation,
    TResult Function(String gymId)? selectGym,
    TResult Function(String gymId)? loadGymDetails,
    TResult Function(String gymId)? loadReviews,
    TResult Function(String gymId, int rating, String? comment)? submitReview,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadGyms value) loadGyms,
    required TResult Function(_LoadMore value) loadMore,
    required TResult Function(_Search value) search,
    required TResult Function(_ClearSearch value) clearSearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_ClearFilters value) clearFilters,
    required TResult Function(_ToggleFavorite value) toggleFavorite,
    required TResult Function(_UpdateLocation value) updateLocation,
    required TResult Function(_SelectGym value) selectGym,
    required TResult Function(_LoadGymDetails value) loadGymDetails,
    required TResult Function(_LoadReviews value) loadReviews,
    required TResult Function(_SubmitReview value) submitReview,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadGyms value)? loadGyms,
    TResult? Function(_LoadMore value)? loadMore,
    TResult? Function(_Search value)? search,
    TResult? Function(_ClearSearch value)? clearSearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_ClearFilters value)? clearFilters,
    TResult? Function(_ToggleFavorite value)? toggleFavorite,
    TResult? Function(_UpdateLocation value)? updateLocation,
    TResult? Function(_SelectGym value)? selectGym,
    TResult? Function(_LoadGymDetails value)? loadGymDetails,
    TResult? Function(_LoadReviews value)? loadReviews,
    TResult? Function(_SubmitReview value)? submitReview,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadGyms value)? loadGyms,
    TResult Function(_LoadMore value)? loadMore,
    TResult Function(_Search value)? search,
    TResult Function(_ClearSearch value)? clearSearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_ClearFilters value)? clearFilters,
    TResult Function(_ToggleFavorite value)? toggleFavorite,
    TResult Function(_UpdateLocation value)? updateLocation,
    TResult Function(_SelectGym value)? selectGym,
    TResult Function(_LoadGymDetails value)? loadGymDetails,
    TResult Function(_LoadReviews value)? loadReviews,
    TResult Function(_SubmitReview value)? submitReview,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GymsEventCopyWith<$Res> {
  factory $GymsEventCopyWith(GymsEvent value, $Res Function(GymsEvent) then) =
      _$GymsEventCopyWithImpl<$Res, GymsEvent>;
}

/// @nodoc
class _$GymsEventCopyWithImpl<$Res, $Val extends GymsEvent>
    implements $GymsEventCopyWith<$Res> {
  _$GymsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LoadGymsImplCopyWith<$Res> {
  factory _$$LoadGymsImplCopyWith(
          _$LoadGymsImpl value, $Res Function(_$LoadGymsImpl) then) =
      __$$LoadGymsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({GymFilter? filter, int page, bool refresh});
}

/// @nodoc
class __$$LoadGymsImplCopyWithImpl<$Res>
    extends _$GymsEventCopyWithImpl<$Res, _$LoadGymsImpl>
    implements _$$LoadGymsImplCopyWith<$Res> {
  __$$LoadGymsImplCopyWithImpl(
      _$LoadGymsImpl _value, $Res Function(_$LoadGymsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filter = freezed,
    Object? page = null,
    Object? refresh = null,
  }) {
    return _then(_$LoadGymsImpl(
      filter: freezed == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as GymFilter?,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      refresh: null == refresh
          ? _value.refresh
          : refresh // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$LoadGymsImpl implements _LoadGyms {
  const _$LoadGymsImpl({this.filter, this.page = 1, this.refresh = false});

  @override
  final GymFilter? filter;
  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final bool refresh;

  @override
  String toString() {
    return 'GymsEvent.loadGyms(filter: $filter, page: $page, refresh: $refresh)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadGymsImpl &&
            (identical(other.filter, filter) || other.filter == filter) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.refresh, refresh) || other.refresh == refresh));
  }

  @override
  int get hashCode => Object.hash(runtimeType, filter, page, refresh);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadGymsImplCopyWith<_$LoadGymsImpl> get copyWith =>
      __$$LoadGymsImplCopyWithImpl<_$LoadGymsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GymFilter? filter, int page, bool refresh)
        loadGyms,
    required TResult Function() loadMore,
    required TResult Function(String query) search,
    required TResult Function() clearSearch,
    required TResult Function(GymFilter filter) applyFilter,
    required TResult Function() clearFilters,
    required TResult Function(String gymId) toggleFavorite,
    required TResult Function(double latitude, double longitude) updateLocation,
    required TResult Function(String gymId) selectGym,
    required TResult Function(String gymId) loadGymDetails,
    required TResult Function(String gymId) loadReviews,
    required TResult Function(String gymId, int rating, String? comment)
        submitReview,
  }) {
    return loadGyms(filter, page, refresh);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult? Function()? loadMore,
    TResult? Function(String query)? search,
    TResult? Function()? clearSearch,
    TResult? Function(GymFilter filter)? applyFilter,
    TResult? Function()? clearFilters,
    TResult? Function(String gymId)? toggleFavorite,
    TResult? Function(double latitude, double longitude)? updateLocation,
    TResult? Function(String gymId)? selectGym,
    TResult? Function(String gymId)? loadGymDetails,
    TResult? Function(String gymId)? loadReviews,
    TResult? Function(String gymId, int rating, String? comment)? submitReview,
  }) {
    return loadGyms?.call(filter, page, refresh);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult Function()? loadMore,
    TResult Function(String query)? search,
    TResult Function()? clearSearch,
    TResult Function(GymFilter filter)? applyFilter,
    TResult Function()? clearFilters,
    TResult Function(String gymId)? toggleFavorite,
    TResult Function(double latitude, double longitude)? updateLocation,
    TResult Function(String gymId)? selectGym,
    TResult Function(String gymId)? loadGymDetails,
    TResult Function(String gymId)? loadReviews,
    TResult Function(String gymId, int rating, String? comment)? submitReview,
    required TResult orElse(),
  }) {
    if (loadGyms != null) {
      return loadGyms(filter, page, refresh);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadGyms value) loadGyms,
    required TResult Function(_LoadMore value) loadMore,
    required TResult Function(_Search value) search,
    required TResult Function(_ClearSearch value) clearSearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_ClearFilters value) clearFilters,
    required TResult Function(_ToggleFavorite value) toggleFavorite,
    required TResult Function(_UpdateLocation value) updateLocation,
    required TResult Function(_SelectGym value) selectGym,
    required TResult Function(_LoadGymDetails value) loadGymDetails,
    required TResult Function(_LoadReviews value) loadReviews,
    required TResult Function(_SubmitReview value) submitReview,
  }) {
    return loadGyms(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadGyms value)? loadGyms,
    TResult? Function(_LoadMore value)? loadMore,
    TResult? Function(_Search value)? search,
    TResult? Function(_ClearSearch value)? clearSearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_ClearFilters value)? clearFilters,
    TResult? Function(_ToggleFavorite value)? toggleFavorite,
    TResult? Function(_UpdateLocation value)? updateLocation,
    TResult? Function(_SelectGym value)? selectGym,
    TResult? Function(_LoadGymDetails value)? loadGymDetails,
    TResult? Function(_LoadReviews value)? loadReviews,
    TResult? Function(_SubmitReview value)? submitReview,
  }) {
    return loadGyms?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadGyms value)? loadGyms,
    TResult Function(_LoadMore value)? loadMore,
    TResult Function(_Search value)? search,
    TResult Function(_ClearSearch value)? clearSearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_ClearFilters value)? clearFilters,
    TResult Function(_ToggleFavorite value)? toggleFavorite,
    TResult Function(_UpdateLocation value)? updateLocation,
    TResult Function(_SelectGym value)? selectGym,
    TResult Function(_LoadGymDetails value)? loadGymDetails,
    TResult Function(_LoadReviews value)? loadReviews,
    TResult Function(_SubmitReview value)? submitReview,
    required TResult orElse(),
  }) {
    if (loadGyms != null) {
      return loadGyms(this);
    }
    return orElse();
  }
}

abstract class _LoadGyms implements GymsEvent {
  const factory _LoadGyms(
      {final GymFilter? filter,
      final int page,
      final bool refresh}) = _$LoadGymsImpl;

  GymFilter? get filter;
  int get page;
  bool get refresh;
  @JsonKey(ignore: true)
  _$$LoadGymsImplCopyWith<_$LoadGymsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadMoreImplCopyWith<$Res> {
  factory _$$LoadMoreImplCopyWith(
          _$LoadMoreImpl value, $Res Function(_$LoadMoreImpl) then) =
      __$$LoadMoreImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadMoreImplCopyWithImpl<$Res>
    extends _$GymsEventCopyWithImpl<$Res, _$LoadMoreImpl>
    implements _$$LoadMoreImplCopyWith<$Res> {
  __$$LoadMoreImplCopyWithImpl(
      _$LoadMoreImpl _value, $Res Function(_$LoadMoreImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadMoreImpl implements _LoadMore {
  const _$LoadMoreImpl();

  @override
  String toString() {
    return 'GymsEvent.loadMore()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadMoreImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GymFilter? filter, int page, bool refresh)
        loadGyms,
    required TResult Function() loadMore,
    required TResult Function(String query) search,
    required TResult Function() clearSearch,
    required TResult Function(GymFilter filter) applyFilter,
    required TResult Function() clearFilters,
    required TResult Function(String gymId) toggleFavorite,
    required TResult Function(double latitude, double longitude) updateLocation,
    required TResult Function(String gymId) selectGym,
    required TResult Function(String gymId) loadGymDetails,
    required TResult Function(String gymId) loadReviews,
    required TResult Function(String gymId, int rating, String? comment)
        submitReview,
  }) {
    return loadMore();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult? Function()? loadMore,
    TResult? Function(String query)? search,
    TResult? Function()? clearSearch,
    TResult? Function(GymFilter filter)? applyFilter,
    TResult? Function()? clearFilters,
    TResult? Function(String gymId)? toggleFavorite,
    TResult? Function(double latitude, double longitude)? updateLocation,
    TResult? Function(String gymId)? selectGym,
    TResult? Function(String gymId)? loadGymDetails,
    TResult? Function(String gymId)? loadReviews,
    TResult? Function(String gymId, int rating, String? comment)? submitReview,
  }) {
    return loadMore?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult Function()? loadMore,
    TResult Function(String query)? search,
    TResult Function()? clearSearch,
    TResult Function(GymFilter filter)? applyFilter,
    TResult Function()? clearFilters,
    TResult Function(String gymId)? toggleFavorite,
    TResult Function(double latitude, double longitude)? updateLocation,
    TResult Function(String gymId)? selectGym,
    TResult Function(String gymId)? loadGymDetails,
    TResult Function(String gymId)? loadReviews,
    TResult Function(String gymId, int rating, String? comment)? submitReview,
    required TResult orElse(),
  }) {
    if (loadMore != null) {
      return loadMore();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadGyms value) loadGyms,
    required TResult Function(_LoadMore value) loadMore,
    required TResult Function(_Search value) search,
    required TResult Function(_ClearSearch value) clearSearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_ClearFilters value) clearFilters,
    required TResult Function(_ToggleFavorite value) toggleFavorite,
    required TResult Function(_UpdateLocation value) updateLocation,
    required TResult Function(_SelectGym value) selectGym,
    required TResult Function(_LoadGymDetails value) loadGymDetails,
    required TResult Function(_LoadReviews value) loadReviews,
    required TResult Function(_SubmitReview value) submitReview,
  }) {
    return loadMore(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadGyms value)? loadGyms,
    TResult? Function(_LoadMore value)? loadMore,
    TResult? Function(_Search value)? search,
    TResult? Function(_ClearSearch value)? clearSearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_ClearFilters value)? clearFilters,
    TResult? Function(_ToggleFavorite value)? toggleFavorite,
    TResult? Function(_UpdateLocation value)? updateLocation,
    TResult? Function(_SelectGym value)? selectGym,
    TResult? Function(_LoadGymDetails value)? loadGymDetails,
    TResult? Function(_LoadReviews value)? loadReviews,
    TResult? Function(_SubmitReview value)? submitReview,
  }) {
    return loadMore?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadGyms value)? loadGyms,
    TResult Function(_LoadMore value)? loadMore,
    TResult Function(_Search value)? search,
    TResult Function(_ClearSearch value)? clearSearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_ClearFilters value)? clearFilters,
    TResult Function(_ToggleFavorite value)? toggleFavorite,
    TResult Function(_UpdateLocation value)? updateLocation,
    TResult Function(_SelectGym value)? selectGym,
    TResult Function(_LoadGymDetails value)? loadGymDetails,
    TResult Function(_LoadReviews value)? loadReviews,
    TResult Function(_SubmitReview value)? submitReview,
    required TResult orElse(),
  }) {
    if (loadMore != null) {
      return loadMore(this);
    }
    return orElse();
  }
}

abstract class _LoadMore implements GymsEvent {
  const factory _LoadMore() = _$LoadMoreImpl;
}

/// @nodoc
abstract class _$$SearchImplCopyWith<$Res> {
  factory _$$SearchImplCopyWith(
          _$SearchImpl value, $Res Function(_$SearchImpl) then) =
      __$$SearchImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String query});
}

/// @nodoc
class __$$SearchImplCopyWithImpl<$Res>
    extends _$GymsEventCopyWithImpl<$Res, _$SearchImpl>
    implements _$$SearchImplCopyWith<$Res> {
  __$$SearchImplCopyWithImpl(
      _$SearchImpl _value, $Res Function(_$SearchImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
  }) {
    return _then(_$SearchImpl(
      null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SearchImpl implements _Search {
  const _$SearchImpl(this.query);

  @override
  final String query;

  @override
  String toString() {
    return 'GymsEvent.search(query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchImpl &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchImplCopyWith<_$SearchImpl> get copyWith =>
      __$$SearchImplCopyWithImpl<_$SearchImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GymFilter? filter, int page, bool refresh)
        loadGyms,
    required TResult Function() loadMore,
    required TResult Function(String query) search,
    required TResult Function() clearSearch,
    required TResult Function(GymFilter filter) applyFilter,
    required TResult Function() clearFilters,
    required TResult Function(String gymId) toggleFavorite,
    required TResult Function(double latitude, double longitude) updateLocation,
    required TResult Function(String gymId) selectGym,
    required TResult Function(String gymId) loadGymDetails,
    required TResult Function(String gymId) loadReviews,
    required TResult Function(String gymId, int rating, String? comment)
        submitReview,
  }) {
    return search(query);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult? Function()? loadMore,
    TResult? Function(String query)? search,
    TResult? Function()? clearSearch,
    TResult? Function(GymFilter filter)? applyFilter,
    TResult? Function()? clearFilters,
    TResult? Function(String gymId)? toggleFavorite,
    TResult? Function(double latitude, double longitude)? updateLocation,
    TResult? Function(String gymId)? selectGym,
    TResult? Function(String gymId)? loadGymDetails,
    TResult? Function(String gymId)? loadReviews,
    TResult? Function(String gymId, int rating, String? comment)? submitReview,
  }) {
    return search?.call(query);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult Function()? loadMore,
    TResult Function(String query)? search,
    TResult Function()? clearSearch,
    TResult Function(GymFilter filter)? applyFilter,
    TResult Function()? clearFilters,
    TResult Function(String gymId)? toggleFavorite,
    TResult Function(double latitude, double longitude)? updateLocation,
    TResult Function(String gymId)? selectGym,
    TResult Function(String gymId)? loadGymDetails,
    TResult Function(String gymId)? loadReviews,
    TResult Function(String gymId, int rating, String? comment)? submitReview,
    required TResult orElse(),
  }) {
    if (search != null) {
      return search(query);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadGyms value) loadGyms,
    required TResult Function(_LoadMore value) loadMore,
    required TResult Function(_Search value) search,
    required TResult Function(_ClearSearch value) clearSearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_ClearFilters value) clearFilters,
    required TResult Function(_ToggleFavorite value) toggleFavorite,
    required TResult Function(_UpdateLocation value) updateLocation,
    required TResult Function(_SelectGym value) selectGym,
    required TResult Function(_LoadGymDetails value) loadGymDetails,
    required TResult Function(_LoadReviews value) loadReviews,
    required TResult Function(_SubmitReview value) submitReview,
  }) {
    return search(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadGyms value)? loadGyms,
    TResult? Function(_LoadMore value)? loadMore,
    TResult? Function(_Search value)? search,
    TResult? Function(_ClearSearch value)? clearSearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_ClearFilters value)? clearFilters,
    TResult? Function(_ToggleFavorite value)? toggleFavorite,
    TResult? Function(_UpdateLocation value)? updateLocation,
    TResult? Function(_SelectGym value)? selectGym,
    TResult? Function(_LoadGymDetails value)? loadGymDetails,
    TResult? Function(_LoadReviews value)? loadReviews,
    TResult? Function(_SubmitReview value)? submitReview,
  }) {
    return search?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadGyms value)? loadGyms,
    TResult Function(_LoadMore value)? loadMore,
    TResult Function(_Search value)? search,
    TResult Function(_ClearSearch value)? clearSearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_ClearFilters value)? clearFilters,
    TResult Function(_ToggleFavorite value)? toggleFavorite,
    TResult Function(_UpdateLocation value)? updateLocation,
    TResult Function(_SelectGym value)? selectGym,
    TResult Function(_LoadGymDetails value)? loadGymDetails,
    TResult Function(_LoadReviews value)? loadReviews,
    TResult Function(_SubmitReview value)? submitReview,
    required TResult orElse(),
  }) {
    if (search != null) {
      return search(this);
    }
    return orElse();
  }
}

abstract class _Search implements GymsEvent {
  const factory _Search(final String query) = _$SearchImpl;

  String get query;
  @JsonKey(ignore: true)
  _$$SearchImplCopyWith<_$SearchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClearSearchImplCopyWith<$Res> {
  factory _$$ClearSearchImplCopyWith(
          _$ClearSearchImpl value, $Res Function(_$ClearSearchImpl) then) =
      __$$ClearSearchImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearSearchImplCopyWithImpl<$Res>
    extends _$GymsEventCopyWithImpl<$Res, _$ClearSearchImpl>
    implements _$$ClearSearchImplCopyWith<$Res> {
  __$$ClearSearchImplCopyWithImpl(
      _$ClearSearchImpl _value, $Res Function(_$ClearSearchImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ClearSearchImpl implements _ClearSearch {
  const _$ClearSearchImpl();

  @override
  String toString() {
    return 'GymsEvent.clearSearch()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearSearchImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GymFilter? filter, int page, bool refresh)
        loadGyms,
    required TResult Function() loadMore,
    required TResult Function(String query) search,
    required TResult Function() clearSearch,
    required TResult Function(GymFilter filter) applyFilter,
    required TResult Function() clearFilters,
    required TResult Function(String gymId) toggleFavorite,
    required TResult Function(double latitude, double longitude) updateLocation,
    required TResult Function(String gymId) selectGym,
    required TResult Function(String gymId) loadGymDetails,
    required TResult Function(String gymId) loadReviews,
    required TResult Function(String gymId, int rating, String? comment)
        submitReview,
  }) {
    return clearSearch();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult? Function()? loadMore,
    TResult? Function(String query)? search,
    TResult? Function()? clearSearch,
    TResult? Function(GymFilter filter)? applyFilter,
    TResult? Function()? clearFilters,
    TResult? Function(String gymId)? toggleFavorite,
    TResult? Function(double latitude, double longitude)? updateLocation,
    TResult? Function(String gymId)? selectGym,
    TResult? Function(String gymId)? loadGymDetails,
    TResult? Function(String gymId)? loadReviews,
    TResult? Function(String gymId, int rating, String? comment)? submitReview,
  }) {
    return clearSearch?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult Function()? loadMore,
    TResult Function(String query)? search,
    TResult Function()? clearSearch,
    TResult Function(GymFilter filter)? applyFilter,
    TResult Function()? clearFilters,
    TResult Function(String gymId)? toggleFavorite,
    TResult Function(double latitude, double longitude)? updateLocation,
    TResult Function(String gymId)? selectGym,
    TResult Function(String gymId)? loadGymDetails,
    TResult Function(String gymId)? loadReviews,
    TResult Function(String gymId, int rating, String? comment)? submitReview,
    required TResult orElse(),
  }) {
    if (clearSearch != null) {
      return clearSearch();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadGyms value) loadGyms,
    required TResult Function(_LoadMore value) loadMore,
    required TResult Function(_Search value) search,
    required TResult Function(_ClearSearch value) clearSearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_ClearFilters value) clearFilters,
    required TResult Function(_ToggleFavorite value) toggleFavorite,
    required TResult Function(_UpdateLocation value) updateLocation,
    required TResult Function(_SelectGym value) selectGym,
    required TResult Function(_LoadGymDetails value) loadGymDetails,
    required TResult Function(_LoadReviews value) loadReviews,
    required TResult Function(_SubmitReview value) submitReview,
  }) {
    return clearSearch(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadGyms value)? loadGyms,
    TResult? Function(_LoadMore value)? loadMore,
    TResult? Function(_Search value)? search,
    TResult? Function(_ClearSearch value)? clearSearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_ClearFilters value)? clearFilters,
    TResult? Function(_ToggleFavorite value)? toggleFavorite,
    TResult? Function(_UpdateLocation value)? updateLocation,
    TResult? Function(_SelectGym value)? selectGym,
    TResult? Function(_LoadGymDetails value)? loadGymDetails,
    TResult? Function(_LoadReviews value)? loadReviews,
    TResult? Function(_SubmitReview value)? submitReview,
  }) {
    return clearSearch?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadGyms value)? loadGyms,
    TResult Function(_LoadMore value)? loadMore,
    TResult Function(_Search value)? search,
    TResult Function(_ClearSearch value)? clearSearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_ClearFilters value)? clearFilters,
    TResult Function(_ToggleFavorite value)? toggleFavorite,
    TResult Function(_UpdateLocation value)? updateLocation,
    TResult Function(_SelectGym value)? selectGym,
    TResult Function(_LoadGymDetails value)? loadGymDetails,
    TResult Function(_LoadReviews value)? loadReviews,
    TResult Function(_SubmitReview value)? submitReview,
    required TResult orElse(),
  }) {
    if (clearSearch != null) {
      return clearSearch(this);
    }
    return orElse();
  }
}

abstract class _ClearSearch implements GymsEvent {
  const factory _ClearSearch() = _$ClearSearchImpl;
}

/// @nodoc
abstract class _$$ApplyFilterImplCopyWith<$Res> {
  factory _$$ApplyFilterImplCopyWith(
          _$ApplyFilterImpl value, $Res Function(_$ApplyFilterImpl) then) =
      __$$ApplyFilterImplCopyWithImpl<$Res>;
  @useResult
  $Res call({GymFilter filter});
}

/// @nodoc
class __$$ApplyFilterImplCopyWithImpl<$Res>
    extends _$GymsEventCopyWithImpl<$Res, _$ApplyFilterImpl>
    implements _$$ApplyFilterImplCopyWith<$Res> {
  __$$ApplyFilterImplCopyWithImpl(
      _$ApplyFilterImpl _value, $Res Function(_$ApplyFilterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filter = null,
  }) {
    return _then(_$ApplyFilterImpl(
      null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as GymFilter,
    ));
  }
}

/// @nodoc

class _$ApplyFilterImpl implements _ApplyFilter {
  const _$ApplyFilterImpl(this.filter);

  @override
  final GymFilter filter;

  @override
  String toString() {
    return 'GymsEvent.applyFilter(filter: $filter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplyFilterImpl &&
            (identical(other.filter, filter) || other.filter == filter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, filter);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplyFilterImplCopyWith<_$ApplyFilterImpl> get copyWith =>
      __$$ApplyFilterImplCopyWithImpl<_$ApplyFilterImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GymFilter? filter, int page, bool refresh)
        loadGyms,
    required TResult Function() loadMore,
    required TResult Function(String query) search,
    required TResult Function() clearSearch,
    required TResult Function(GymFilter filter) applyFilter,
    required TResult Function() clearFilters,
    required TResult Function(String gymId) toggleFavorite,
    required TResult Function(double latitude, double longitude) updateLocation,
    required TResult Function(String gymId) selectGym,
    required TResult Function(String gymId) loadGymDetails,
    required TResult Function(String gymId) loadReviews,
    required TResult Function(String gymId, int rating, String? comment)
        submitReview,
  }) {
    return applyFilter(filter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult? Function()? loadMore,
    TResult? Function(String query)? search,
    TResult? Function()? clearSearch,
    TResult? Function(GymFilter filter)? applyFilter,
    TResult? Function()? clearFilters,
    TResult? Function(String gymId)? toggleFavorite,
    TResult? Function(double latitude, double longitude)? updateLocation,
    TResult? Function(String gymId)? selectGym,
    TResult? Function(String gymId)? loadGymDetails,
    TResult? Function(String gymId)? loadReviews,
    TResult? Function(String gymId, int rating, String? comment)? submitReview,
  }) {
    return applyFilter?.call(filter);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult Function()? loadMore,
    TResult Function(String query)? search,
    TResult Function()? clearSearch,
    TResult Function(GymFilter filter)? applyFilter,
    TResult Function()? clearFilters,
    TResult Function(String gymId)? toggleFavorite,
    TResult Function(double latitude, double longitude)? updateLocation,
    TResult Function(String gymId)? selectGym,
    TResult Function(String gymId)? loadGymDetails,
    TResult Function(String gymId)? loadReviews,
    TResult Function(String gymId, int rating, String? comment)? submitReview,
    required TResult orElse(),
  }) {
    if (applyFilter != null) {
      return applyFilter(filter);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadGyms value) loadGyms,
    required TResult Function(_LoadMore value) loadMore,
    required TResult Function(_Search value) search,
    required TResult Function(_ClearSearch value) clearSearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_ClearFilters value) clearFilters,
    required TResult Function(_ToggleFavorite value) toggleFavorite,
    required TResult Function(_UpdateLocation value) updateLocation,
    required TResult Function(_SelectGym value) selectGym,
    required TResult Function(_LoadGymDetails value) loadGymDetails,
    required TResult Function(_LoadReviews value) loadReviews,
    required TResult Function(_SubmitReview value) submitReview,
  }) {
    return applyFilter(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadGyms value)? loadGyms,
    TResult? Function(_LoadMore value)? loadMore,
    TResult? Function(_Search value)? search,
    TResult? Function(_ClearSearch value)? clearSearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_ClearFilters value)? clearFilters,
    TResult? Function(_ToggleFavorite value)? toggleFavorite,
    TResult? Function(_UpdateLocation value)? updateLocation,
    TResult? Function(_SelectGym value)? selectGym,
    TResult? Function(_LoadGymDetails value)? loadGymDetails,
    TResult? Function(_LoadReviews value)? loadReviews,
    TResult? Function(_SubmitReview value)? submitReview,
  }) {
    return applyFilter?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadGyms value)? loadGyms,
    TResult Function(_LoadMore value)? loadMore,
    TResult Function(_Search value)? search,
    TResult Function(_ClearSearch value)? clearSearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_ClearFilters value)? clearFilters,
    TResult Function(_ToggleFavorite value)? toggleFavorite,
    TResult Function(_UpdateLocation value)? updateLocation,
    TResult Function(_SelectGym value)? selectGym,
    TResult Function(_LoadGymDetails value)? loadGymDetails,
    TResult Function(_LoadReviews value)? loadReviews,
    TResult Function(_SubmitReview value)? submitReview,
    required TResult orElse(),
  }) {
    if (applyFilter != null) {
      return applyFilter(this);
    }
    return orElse();
  }
}

abstract class _ApplyFilter implements GymsEvent {
  const factory _ApplyFilter(final GymFilter filter) = _$ApplyFilterImpl;

  GymFilter get filter;
  @JsonKey(ignore: true)
  _$$ApplyFilterImplCopyWith<_$ApplyFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClearFiltersImplCopyWith<$Res> {
  factory _$$ClearFiltersImplCopyWith(
          _$ClearFiltersImpl value, $Res Function(_$ClearFiltersImpl) then) =
      __$$ClearFiltersImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearFiltersImplCopyWithImpl<$Res>
    extends _$GymsEventCopyWithImpl<$Res, _$ClearFiltersImpl>
    implements _$$ClearFiltersImplCopyWith<$Res> {
  __$$ClearFiltersImplCopyWithImpl(
      _$ClearFiltersImpl _value, $Res Function(_$ClearFiltersImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ClearFiltersImpl implements _ClearFilters {
  const _$ClearFiltersImpl();

  @override
  String toString() {
    return 'GymsEvent.clearFilters()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearFiltersImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GymFilter? filter, int page, bool refresh)
        loadGyms,
    required TResult Function() loadMore,
    required TResult Function(String query) search,
    required TResult Function() clearSearch,
    required TResult Function(GymFilter filter) applyFilter,
    required TResult Function() clearFilters,
    required TResult Function(String gymId) toggleFavorite,
    required TResult Function(double latitude, double longitude) updateLocation,
    required TResult Function(String gymId) selectGym,
    required TResult Function(String gymId) loadGymDetails,
    required TResult Function(String gymId) loadReviews,
    required TResult Function(String gymId, int rating, String? comment)
        submitReview,
  }) {
    return clearFilters();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult? Function()? loadMore,
    TResult? Function(String query)? search,
    TResult? Function()? clearSearch,
    TResult? Function(GymFilter filter)? applyFilter,
    TResult? Function()? clearFilters,
    TResult? Function(String gymId)? toggleFavorite,
    TResult? Function(double latitude, double longitude)? updateLocation,
    TResult? Function(String gymId)? selectGym,
    TResult? Function(String gymId)? loadGymDetails,
    TResult? Function(String gymId)? loadReviews,
    TResult? Function(String gymId, int rating, String? comment)? submitReview,
  }) {
    return clearFilters?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult Function()? loadMore,
    TResult Function(String query)? search,
    TResult Function()? clearSearch,
    TResult Function(GymFilter filter)? applyFilter,
    TResult Function()? clearFilters,
    TResult Function(String gymId)? toggleFavorite,
    TResult Function(double latitude, double longitude)? updateLocation,
    TResult Function(String gymId)? selectGym,
    TResult Function(String gymId)? loadGymDetails,
    TResult Function(String gymId)? loadReviews,
    TResult Function(String gymId, int rating, String? comment)? submitReview,
    required TResult orElse(),
  }) {
    if (clearFilters != null) {
      return clearFilters();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadGyms value) loadGyms,
    required TResult Function(_LoadMore value) loadMore,
    required TResult Function(_Search value) search,
    required TResult Function(_ClearSearch value) clearSearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_ClearFilters value) clearFilters,
    required TResult Function(_ToggleFavorite value) toggleFavorite,
    required TResult Function(_UpdateLocation value) updateLocation,
    required TResult Function(_SelectGym value) selectGym,
    required TResult Function(_LoadGymDetails value) loadGymDetails,
    required TResult Function(_LoadReviews value) loadReviews,
    required TResult Function(_SubmitReview value) submitReview,
  }) {
    return clearFilters(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadGyms value)? loadGyms,
    TResult? Function(_LoadMore value)? loadMore,
    TResult? Function(_Search value)? search,
    TResult? Function(_ClearSearch value)? clearSearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_ClearFilters value)? clearFilters,
    TResult? Function(_ToggleFavorite value)? toggleFavorite,
    TResult? Function(_UpdateLocation value)? updateLocation,
    TResult? Function(_SelectGym value)? selectGym,
    TResult? Function(_LoadGymDetails value)? loadGymDetails,
    TResult? Function(_LoadReviews value)? loadReviews,
    TResult? Function(_SubmitReview value)? submitReview,
  }) {
    return clearFilters?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadGyms value)? loadGyms,
    TResult Function(_LoadMore value)? loadMore,
    TResult Function(_Search value)? search,
    TResult Function(_ClearSearch value)? clearSearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_ClearFilters value)? clearFilters,
    TResult Function(_ToggleFavorite value)? toggleFavorite,
    TResult Function(_UpdateLocation value)? updateLocation,
    TResult Function(_SelectGym value)? selectGym,
    TResult Function(_LoadGymDetails value)? loadGymDetails,
    TResult Function(_LoadReviews value)? loadReviews,
    TResult Function(_SubmitReview value)? submitReview,
    required TResult orElse(),
  }) {
    if (clearFilters != null) {
      return clearFilters(this);
    }
    return orElse();
  }
}

abstract class _ClearFilters implements GymsEvent {
  const factory _ClearFilters() = _$ClearFiltersImpl;
}

/// @nodoc
abstract class _$$ToggleFavoriteImplCopyWith<$Res> {
  factory _$$ToggleFavoriteImplCopyWith(_$ToggleFavoriteImpl value,
          $Res Function(_$ToggleFavoriteImpl) then) =
      __$$ToggleFavoriteImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String gymId});
}

/// @nodoc
class __$$ToggleFavoriteImplCopyWithImpl<$Res>
    extends _$GymsEventCopyWithImpl<$Res, _$ToggleFavoriteImpl>
    implements _$$ToggleFavoriteImplCopyWith<$Res> {
  __$$ToggleFavoriteImplCopyWithImpl(
      _$ToggleFavoriteImpl _value, $Res Function(_$ToggleFavoriteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gymId = null,
  }) {
    return _then(_$ToggleFavoriteImpl(
      null == gymId
          ? _value.gymId
          : gymId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ToggleFavoriteImpl implements _ToggleFavorite {
  const _$ToggleFavoriteImpl(this.gymId);

  @override
  final String gymId;

  @override
  String toString() {
    return 'GymsEvent.toggleFavorite(gymId: $gymId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToggleFavoriteImpl &&
            (identical(other.gymId, gymId) || other.gymId == gymId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, gymId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ToggleFavoriteImplCopyWith<_$ToggleFavoriteImpl> get copyWith =>
      __$$ToggleFavoriteImplCopyWithImpl<_$ToggleFavoriteImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GymFilter? filter, int page, bool refresh)
        loadGyms,
    required TResult Function() loadMore,
    required TResult Function(String query) search,
    required TResult Function() clearSearch,
    required TResult Function(GymFilter filter) applyFilter,
    required TResult Function() clearFilters,
    required TResult Function(String gymId) toggleFavorite,
    required TResult Function(double latitude, double longitude) updateLocation,
    required TResult Function(String gymId) selectGym,
    required TResult Function(String gymId) loadGymDetails,
    required TResult Function(String gymId) loadReviews,
    required TResult Function(String gymId, int rating, String? comment)
        submitReview,
  }) {
    return toggleFavorite(gymId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult? Function()? loadMore,
    TResult? Function(String query)? search,
    TResult? Function()? clearSearch,
    TResult? Function(GymFilter filter)? applyFilter,
    TResult? Function()? clearFilters,
    TResult? Function(String gymId)? toggleFavorite,
    TResult? Function(double latitude, double longitude)? updateLocation,
    TResult? Function(String gymId)? selectGym,
    TResult? Function(String gymId)? loadGymDetails,
    TResult? Function(String gymId)? loadReviews,
    TResult? Function(String gymId, int rating, String? comment)? submitReview,
  }) {
    return toggleFavorite?.call(gymId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult Function()? loadMore,
    TResult Function(String query)? search,
    TResult Function()? clearSearch,
    TResult Function(GymFilter filter)? applyFilter,
    TResult Function()? clearFilters,
    TResult Function(String gymId)? toggleFavorite,
    TResult Function(double latitude, double longitude)? updateLocation,
    TResult Function(String gymId)? selectGym,
    TResult Function(String gymId)? loadGymDetails,
    TResult Function(String gymId)? loadReviews,
    TResult Function(String gymId, int rating, String? comment)? submitReview,
    required TResult orElse(),
  }) {
    if (toggleFavorite != null) {
      return toggleFavorite(gymId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadGyms value) loadGyms,
    required TResult Function(_LoadMore value) loadMore,
    required TResult Function(_Search value) search,
    required TResult Function(_ClearSearch value) clearSearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_ClearFilters value) clearFilters,
    required TResult Function(_ToggleFavorite value) toggleFavorite,
    required TResult Function(_UpdateLocation value) updateLocation,
    required TResult Function(_SelectGym value) selectGym,
    required TResult Function(_LoadGymDetails value) loadGymDetails,
    required TResult Function(_LoadReviews value) loadReviews,
    required TResult Function(_SubmitReview value) submitReview,
  }) {
    return toggleFavorite(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadGyms value)? loadGyms,
    TResult? Function(_LoadMore value)? loadMore,
    TResult? Function(_Search value)? search,
    TResult? Function(_ClearSearch value)? clearSearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_ClearFilters value)? clearFilters,
    TResult? Function(_ToggleFavorite value)? toggleFavorite,
    TResult? Function(_UpdateLocation value)? updateLocation,
    TResult? Function(_SelectGym value)? selectGym,
    TResult? Function(_LoadGymDetails value)? loadGymDetails,
    TResult? Function(_LoadReviews value)? loadReviews,
    TResult? Function(_SubmitReview value)? submitReview,
  }) {
    return toggleFavorite?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadGyms value)? loadGyms,
    TResult Function(_LoadMore value)? loadMore,
    TResult Function(_Search value)? search,
    TResult Function(_ClearSearch value)? clearSearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_ClearFilters value)? clearFilters,
    TResult Function(_ToggleFavorite value)? toggleFavorite,
    TResult Function(_UpdateLocation value)? updateLocation,
    TResult Function(_SelectGym value)? selectGym,
    TResult Function(_LoadGymDetails value)? loadGymDetails,
    TResult Function(_LoadReviews value)? loadReviews,
    TResult Function(_SubmitReview value)? submitReview,
    required TResult orElse(),
  }) {
    if (toggleFavorite != null) {
      return toggleFavorite(this);
    }
    return orElse();
  }
}

abstract class _ToggleFavorite implements GymsEvent {
  const factory _ToggleFavorite(final String gymId) = _$ToggleFavoriteImpl;

  String get gymId;
  @JsonKey(ignore: true)
  _$$ToggleFavoriteImplCopyWith<_$ToggleFavoriteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateLocationImplCopyWith<$Res> {
  factory _$$UpdateLocationImplCopyWith(_$UpdateLocationImpl value,
          $Res Function(_$UpdateLocationImpl) then) =
      __$$UpdateLocationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double latitude, double longitude});
}

/// @nodoc
class __$$UpdateLocationImplCopyWithImpl<$Res>
    extends _$GymsEventCopyWithImpl<$Res, _$UpdateLocationImpl>
    implements _$$UpdateLocationImplCopyWith<$Res> {
  __$$UpdateLocationImplCopyWithImpl(
      _$UpdateLocationImpl _value, $Res Function(_$UpdateLocationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_$UpdateLocationImpl(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$UpdateLocationImpl implements _UpdateLocation {
  const _$UpdateLocationImpl({required this.latitude, required this.longitude});

  @override
  final double latitude;
  @override
  final double longitude;

  @override
  String toString() {
    return 'GymsEvent.updateLocation(latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateLocationImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @override
  int get hashCode => Object.hash(runtimeType, latitude, longitude);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateLocationImplCopyWith<_$UpdateLocationImpl> get copyWith =>
      __$$UpdateLocationImplCopyWithImpl<_$UpdateLocationImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GymFilter? filter, int page, bool refresh)
        loadGyms,
    required TResult Function() loadMore,
    required TResult Function(String query) search,
    required TResult Function() clearSearch,
    required TResult Function(GymFilter filter) applyFilter,
    required TResult Function() clearFilters,
    required TResult Function(String gymId) toggleFavorite,
    required TResult Function(double latitude, double longitude) updateLocation,
    required TResult Function(String gymId) selectGym,
    required TResult Function(String gymId) loadGymDetails,
    required TResult Function(String gymId) loadReviews,
    required TResult Function(String gymId, int rating, String? comment)
        submitReview,
  }) {
    return updateLocation(latitude, longitude);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult? Function()? loadMore,
    TResult? Function(String query)? search,
    TResult? Function()? clearSearch,
    TResult? Function(GymFilter filter)? applyFilter,
    TResult? Function()? clearFilters,
    TResult? Function(String gymId)? toggleFavorite,
    TResult? Function(double latitude, double longitude)? updateLocation,
    TResult? Function(String gymId)? selectGym,
    TResult? Function(String gymId)? loadGymDetails,
    TResult? Function(String gymId)? loadReviews,
    TResult? Function(String gymId, int rating, String? comment)? submitReview,
  }) {
    return updateLocation?.call(latitude, longitude);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult Function()? loadMore,
    TResult Function(String query)? search,
    TResult Function()? clearSearch,
    TResult Function(GymFilter filter)? applyFilter,
    TResult Function()? clearFilters,
    TResult Function(String gymId)? toggleFavorite,
    TResult Function(double latitude, double longitude)? updateLocation,
    TResult Function(String gymId)? selectGym,
    TResult Function(String gymId)? loadGymDetails,
    TResult Function(String gymId)? loadReviews,
    TResult Function(String gymId, int rating, String? comment)? submitReview,
    required TResult orElse(),
  }) {
    if (updateLocation != null) {
      return updateLocation(latitude, longitude);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadGyms value) loadGyms,
    required TResult Function(_LoadMore value) loadMore,
    required TResult Function(_Search value) search,
    required TResult Function(_ClearSearch value) clearSearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_ClearFilters value) clearFilters,
    required TResult Function(_ToggleFavorite value) toggleFavorite,
    required TResult Function(_UpdateLocation value) updateLocation,
    required TResult Function(_SelectGym value) selectGym,
    required TResult Function(_LoadGymDetails value) loadGymDetails,
    required TResult Function(_LoadReviews value) loadReviews,
    required TResult Function(_SubmitReview value) submitReview,
  }) {
    return updateLocation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadGyms value)? loadGyms,
    TResult? Function(_LoadMore value)? loadMore,
    TResult? Function(_Search value)? search,
    TResult? Function(_ClearSearch value)? clearSearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_ClearFilters value)? clearFilters,
    TResult? Function(_ToggleFavorite value)? toggleFavorite,
    TResult? Function(_UpdateLocation value)? updateLocation,
    TResult? Function(_SelectGym value)? selectGym,
    TResult? Function(_LoadGymDetails value)? loadGymDetails,
    TResult? Function(_LoadReviews value)? loadReviews,
    TResult? Function(_SubmitReview value)? submitReview,
  }) {
    return updateLocation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadGyms value)? loadGyms,
    TResult Function(_LoadMore value)? loadMore,
    TResult Function(_Search value)? search,
    TResult Function(_ClearSearch value)? clearSearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_ClearFilters value)? clearFilters,
    TResult Function(_ToggleFavorite value)? toggleFavorite,
    TResult Function(_UpdateLocation value)? updateLocation,
    TResult Function(_SelectGym value)? selectGym,
    TResult Function(_LoadGymDetails value)? loadGymDetails,
    TResult Function(_LoadReviews value)? loadReviews,
    TResult Function(_SubmitReview value)? submitReview,
    required TResult orElse(),
  }) {
    if (updateLocation != null) {
      return updateLocation(this);
    }
    return orElse();
  }
}

abstract class _UpdateLocation implements GymsEvent {
  const factory _UpdateLocation(
      {required final double latitude,
      required final double longitude}) = _$UpdateLocationImpl;

  double get latitude;
  double get longitude;
  @JsonKey(ignore: true)
  _$$UpdateLocationImplCopyWith<_$UpdateLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SelectGymImplCopyWith<$Res> {
  factory _$$SelectGymImplCopyWith(
          _$SelectGymImpl value, $Res Function(_$SelectGymImpl) then) =
      __$$SelectGymImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String gymId});
}

/// @nodoc
class __$$SelectGymImplCopyWithImpl<$Res>
    extends _$GymsEventCopyWithImpl<$Res, _$SelectGymImpl>
    implements _$$SelectGymImplCopyWith<$Res> {
  __$$SelectGymImplCopyWithImpl(
      _$SelectGymImpl _value, $Res Function(_$SelectGymImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gymId = null,
  }) {
    return _then(_$SelectGymImpl(
      null == gymId
          ? _value.gymId
          : gymId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SelectGymImpl implements _SelectGym {
  const _$SelectGymImpl(this.gymId);

  @override
  final String gymId;

  @override
  String toString() {
    return 'GymsEvent.selectGym(gymId: $gymId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectGymImpl &&
            (identical(other.gymId, gymId) || other.gymId == gymId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, gymId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectGymImplCopyWith<_$SelectGymImpl> get copyWith =>
      __$$SelectGymImplCopyWithImpl<_$SelectGymImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GymFilter? filter, int page, bool refresh)
        loadGyms,
    required TResult Function() loadMore,
    required TResult Function(String query) search,
    required TResult Function() clearSearch,
    required TResult Function(GymFilter filter) applyFilter,
    required TResult Function() clearFilters,
    required TResult Function(String gymId) toggleFavorite,
    required TResult Function(double latitude, double longitude) updateLocation,
    required TResult Function(String gymId) selectGym,
    required TResult Function(String gymId) loadGymDetails,
    required TResult Function(String gymId) loadReviews,
    required TResult Function(String gymId, int rating, String? comment)
        submitReview,
  }) {
    return selectGym(gymId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult? Function()? loadMore,
    TResult? Function(String query)? search,
    TResult? Function()? clearSearch,
    TResult? Function(GymFilter filter)? applyFilter,
    TResult? Function()? clearFilters,
    TResult? Function(String gymId)? toggleFavorite,
    TResult? Function(double latitude, double longitude)? updateLocation,
    TResult? Function(String gymId)? selectGym,
    TResult? Function(String gymId)? loadGymDetails,
    TResult? Function(String gymId)? loadReviews,
    TResult? Function(String gymId, int rating, String? comment)? submitReview,
  }) {
    return selectGym?.call(gymId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult Function()? loadMore,
    TResult Function(String query)? search,
    TResult Function()? clearSearch,
    TResult Function(GymFilter filter)? applyFilter,
    TResult Function()? clearFilters,
    TResult Function(String gymId)? toggleFavorite,
    TResult Function(double latitude, double longitude)? updateLocation,
    TResult Function(String gymId)? selectGym,
    TResult Function(String gymId)? loadGymDetails,
    TResult Function(String gymId)? loadReviews,
    TResult Function(String gymId, int rating, String? comment)? submitReview,
    required TResult orElse(),
  }) {
    if (selectGym != null) {
      return selectGym(gymId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadGyms value) loadGyms,
    required TResult Function(_LoadMore value) loadMore,
    required TResult Function(_Search value) search,
    required TResult Function(_ClearSearch value) clearSearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_ClearFilters value) clearFilters,
    required TResult Function(_ToggleFavorite value) toggleFavorite,
    required TResult Function(_UpdateLocation value) updateLocation,
    required TResult Function(_SelectGym value) selectGym,
    required TResult Function(_LoadGymDetails value) loadGymDetails,
    required TResult Function(_LoadReviews value) loadReviews,
    required TResult Function(_SubmitReview value) submitReview,
  }) {
    return selectGym(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadGyms value)? loadGyms,
    TResult? Function(_LoadMore value)? loadMore,
    TResult? Function(_Search value)? search,
    TResult? Function(_ClearSearch value)? clearSearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_ClearFilters value)? clearFilters,
    TResult? Function(_ToggleFavorite value)? toggleFavorite,
    TResult? Function(_UpdateLocation value)? updateLocation,
    TResult? Function(_SelectGym value)? selectGym,
    TResult? Function(_LoadGymDetails value)? loadGymDetails,
    TResult? Function(_LoadReviews value)? loadReviews,
    TResult? Function(_SubmitReview value)? submitReview,
  }) {
    return selectGym?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadGyms value)? loadGyms,
    TResult Function(_LoadMore value)? loadMore,
    TResult Function(_Search value)? search,
    TResult Function(_ClearSearch value)? clearSearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_ClearFilters value)? clearFilters,
    TResult Function(_ToggleFavorite value)? toggleFavorite,
    TResult Function(_UpdateLocation value)? updateLocation,
    TResult Function(_SelectGym value)? selectGym,
    TResult Function(_LoadGymDetails value)? loadGymDetails,
    TResult Function(_LoadReviews value)? loadReviews,
    TResult Function(_SubmitReview value)? submitReview,
    required TResult orElse(),
  }) {
    if (selectGym != null) {
      return selectGym(this);
    }
    return orElse();
  }
}

abstract class _SelectGym implements GymsEvent {
  const factory _SelectGym(final String gymId) = _$SelectGymImpl;

  String get gymId;
  @JsonKey(ignore: true)
  _$$SelectGymImplCopyWith<_$SelectGymImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadGymDetailsImplCopyWith<$Res> {
  factory _$$LoadGymDetailsImplCopyWith(_$LoadGymDetailsImpl value,
          $Res Function(_$LoadGymDetailsImpl) then) =
      __$$LoadGymDetailsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String gymId});
}

/// @nodoc
class __$$LoadGymDetailsImplCopyWithImpl<$Res>
    extends _$GymsEventCopyWithImpl<$Res, _$LoadGymDetailsImpl>
    implements _$$LoadGymDetailsImplCopyWith<$Res> {
  __$$LoadGymDetailsImplCopyWithImpl(
      _$LoadGymDetailsImpl _value, $Res Function(_$LoadGymDetailsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gymId = null,
  }) {
    return _then(_$LoadGymDetailsImpl(
      null == gymId
          ? _value.gymId
          : gymId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LoadGymDetailsImpl implements _LoadGymDetails {
  const _$LoadGymDetailsImpl(this.gymId);

  @override
  final String gymId;

  @override
  String toString() {
    return 'GymsEvent.loadGymDetails(gymId: $gymId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadGymDetailsImpl &&
            (identical(other.gymId, gymId) || other.gymId == gymId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, gymId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadGymDetailsImplCopyWith<_$LoadGymDetailsImpl> get copyWith =>
      __$$LoadGymDetailsImplCopyWithImpl<_$LoadGymDetailsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GymFilter? filter, int page, bool refresh)
        loadGyms,
    required TResult Function() loadMore,
    required TResult Function(String query) search,
    required TResult Function() clearSearch,
    required TResult Function(GymFilter filter) applyFilter,
    required TResult Function() clearFilters,
    required TResult Function(String gymId) toggleFavorite,
    required TResult Function(double latitude, double longitude) updateLocation,
    required TResult Function(String gymId) selectGym,
    required TResult Function(String gymId) loadGymDetails,
    required TResult Function(String gymId) loadReviews,
    required TResult Function(String gymId, int rating, String? comment)
        submitReview,
  }) {
    return loadGymDetails(gymId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult? Function()? loadMore,
    TResult? Function(String query)? search,
    TResult? Function()? clearSearch,
    TResult? Function(GymFilter filter)? applyFilter,
    TResult? Function()? clearFilters,
    TResult? Function(String gymId)? toggleFavorite,
    TResult? Function(double latitude, double longitude)? updateLocation,
    TResult? Function(String gymId)? selectGym,
    TResult? Function(String gymId)? loadGymDetails,
    TResult? Function(String gymId)? loadReviews,
    TResult? Function(String gymId, int rating, String? comment)? submitReview,
  }) {
    return loadGymDetails?.call(gymId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult Function()? loadMore,
    TResult Function(String query)? search,
    TResult Function()? clearSearch,
    TResult Function(GymFilter filter)? applyFilter,
    TResult Function()? clearFilters,
    TResult Function(String gymId)? toggleFavorite,
    TResult Function(double latitude, double longitude)? updateLocation,
    TResult Function(String gymId)? selectGym,
    TResult Function(String gymId)? loadGymDetails,
    TResult Function(String gymId)? loadReviews,
    TResult Function(String gymId, int rating, String? comment)? submitReview,
    required TResult orElse(),
  }) {
    if (loadGymDetails != null) {
      return loadGymDetails(gymId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadGyms value) loadGyms,
    required TResult Function(_LoadMore value) loadMore,
    required TResult Function(_Search value) search,
    required TResult Function(_ClearSearch value) clearSearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_ClearFilters value) clearFilters,
    required TResult Function(_ToggleFavorite value) toggleFavorite,
    required TResult Function(_UpdateLocation value) updateLocation,
    required TResult Function(_SelectGym value) selectGym,
    required TResult Function(_LoadGymDetails value) loadGymDetails,
    required TResult Function(_LoadReviews value) loadReviews,
    required TResult Function(_SubmitReview value) submitReview,
  }) {
    return loadGymDetails(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadGyms value)? loadGyms,
    TResult? Function(_LoadMore value)? loadMore,
    TResult? Function(_Search value)? search,
    TResult? Function(_ClearSearch value)? clearSearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_ClearFilters value)? clearFilters,
    TResult? Function(_ToggleFavorite value)? toggleFavorite,
    TResult? Function(_UpdateLocation value)? updateLocation,
    TResult? Function(_SelectGym value)? selectGym,
    TResult? Function(_LoadGymDetails value)? loadGymDetails,
    TResult? Function(_LoadReviews value)? loadReviews,
    TResult? Function(_SubmitReview value)? submitReview,
  }) {
    return loadGymDetails?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadGyms value)? loadGyms,
    TResult Function(_LoadMore value)? loadMore,
    TResult Function(_Search value)? search,
    TResult Function(_ClearSearch value)? clearSearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_ClearFilters value)? clearFilters,
    TResult Function(_ToggleFavorite value)? toggleFavorite,
    TResult Function(_UpdateLocation value)? updateLocation,
    TResult Function(_SelectGym value)? selectGym,
    TResult Function(_LoadGymDetails value)? loadGymDetails,
    TResult Function(_LoadReviews value)? loadReviews,
    TResult Function(_SubmitReview value)? submitReview,
    required TResult orElse(),
  }) {
    if (loadGymDetails != null) {
      return loadGymDetails(this);
    }
    return orElse();
  }
}

abstract class _LoadGymDetails implements GymsEvent {
  const factory _LoadGymDetails(final String gymId) = _$LoadGymDetailsImpl;

  String get gymId;
  @JsonKey(ignore: true)
  _$$LoadGymDetailsImplCopyWith<_$LoadGymDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadReviewsImplCopyWith<$Res> {
  factory _$$LoadReviewsImplCopyWith(
          _$LoadReviewsImpl value, $Res Function(_$LoadReviewsImpl) then) =
      __$$LoadReviewsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String gymId});
}

/// @nodoc
class __$$LoadReviewsImplCopyWithImpl<$Res>
    extends _$GymsEventCopyWithImpl<$Res, _$LoadReviewsImpl>
    implements _$$LoadReviewsImplCopyWith<$Res> {
  __$$LoadReviewsImplCopyWithImpl(
      _$LoadReviewsImpl _value, $Res Function(_$LoadReviewsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gymId = null,
  }) {
    return _then(_$LoadReviewsImpl(
      null == gymId
          ? _value.gymId
          : gymId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LoadReviewsImpl implements _LoadReviews {
  const _$LoadReviewsImpl(this.gymId);

  @override
  final String gymId;

  @override
  String toString() {
    return 'GymsEvent.loadReviews(gymId: $gymId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadReviewsImpl &&
            (identical(other.gymId, gymId) || other.gymId == gymId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, gymId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadReviewsImplCopyWith<_$LoadReviewsImpl> get copyWith =>
      __$$LoadReviewsImplCopyWithImpl<_$LoadReviewsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GymFilter? filter, int page, bool refresh)
        loadGyms,
    required TResult Function() loadMore,
    required TResult Function(String query) search,
    required TResult Function() clearSearch,
    required TResult Function(GymFilter filter) applyFilter,
    required TResult Function() clearFilters,
    required TResult Function(String gymId) toggleFavorite,
    required TResult Function(double latitude, double longitude) updateLocation,
    required TResult Function(String gymId) selectGym,
    required TResult Function(String gymId) loadGymDetails,
    required TResult Function(String gymId) loadReviews,
    required TResult Function(String gymId, int rating, String? comment)
        submitReview,
  }) {
    return loadReviews(gymId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult? Function()? loadMore,
    TResult? Function(String query)? search,
    TResult? Function()? clearSearch,
    TResult? Function(GymFilter filter)? applyFilter,
    TResult? Function()? clearFilters,
    TResult? Function(String gymId)? toggleFavorite,
    TResult? Function(double latitude, double longitude)? updateLocation,
    TResult? Function(String gymId)? selectGym,
    TResult? Function(String gymId)? loadGymDetails,
    TResult? Function(String gymId)? loadReviews,
    TResult? Function(String gymId, int rating, String? comment)? submitReview,
  }) {
    return loadReviews?.call(gymId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult Function()? loadMore,
    TResult Function(String query)? search,
    TResult Function()? clearSearch,
    TResult Function(GymFilter filter)? applyFilter,
    TResult Function()? clearFilters,
    TResult Function(String gymId)? toggleFavorite,
    TResult Function(double latitude, double longitude)? updateLocation,
    TResult Function(String gymId)? selectGym,
    TResult Function(String gymId)? loadGymDetails,
    TResult Function(String gymId)? loadReviews,
    TResult Function(String gymId, int rating, String? comment)? submitReview,
    required TResult orElse(),
  }) {
    if (loadReviews != null) {
      return loadReviews(gymId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadGyms value) loadGyms,
    required TResult Function(_LoadMore value) loadMore,
    required TResult Function(_Search value) search,
    required TResult Function(_ClearSearch value) clearSearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_ClearFilters value) clearFilters,
    required TResult Function(_ToggleFavorite value) toggleFavorite,
    required TResult Function(_UpdateLocation value) updateLocation,
    required TResult Function(_SelectGym value) selectGym,
    required TResult Function(_LoadGymDetails value) loadGymDetails,
    required TResult Function(_LoadReviews value) loadReviews,
    required TResult Function(_SubmitReview value) submitReview,
  }) {
    return loadReviews(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadGyms value)? loadGyms,
    TResult? Function(_LoadMore value)? loadMore,
    TResult? Function(_Search value)? search,
    TResult? Function(_ClearSearch value)? clearSearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_ClearFilters value)? clearFilters,
    TResult? Function(_ToggleFavorite value)? toggleFavorite,
    TResult? Function(_UpdateLocation value)? updateLocation,
    TResult? Function(_SelectGym value)? selectGym,
    TResult? Function(_LoadGymDetails value)? loadGymDetails,
    TResult? Function(_LoadReviews value)? loadReviews,
    TResult? Function(_SubmitReview value)? submitReview,
  }) {
    return loadReviews?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadGyms value)? loadGyms,
    TResult Function(_LoadMore value)? loadMore,
    TResult Function(_Search value)? search,
    TResult Function(_ClearSearch value)? clearSearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_ClearFilters value)? clearFilters,
    TResult Function(_ToggleFavorite value)? toggleFavorite,
    TResult Function(_UpdateLocation value)? updateLocation,
    TResult Function(_SelectGym value)? selectGym,
    TResult Function(_LoadGymDetails value)? loadGymDetails,
    TResult Function(_LoadReviews value)? loadReviews,
    TResult Function(_SubmitReview value)? submitReview,
    required TResult orElse(),
  }) {
    if (loadReviews != null) {
      return loadReviews(this);
    }
    return orElse();
  }
}

abstract class _LoadReviews implements GymsEvent {
  const factory _LoadReviews(final String gymId) = _$LoadReviewsImpl;

  String get gymId;
  @JsonKey(ignore: true)
  _$$LoadReviewsImplCopyWith<_$LoadReviewsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SubmitReviewImplCopyWith<$Res> {
  factory _$$SubmitReviewImplCopyWith(
          _$SubmitReviewImpl value, $Res Function(_$SubmitReviewImpl) then) =
      __$$SubmitReviewImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String gymId, int rating, String? comment});
}

/// @nodoc
class __$$SubmitReviewImplCopyWithImpl<$Res>
    extends _$GymsEventCopyWithImpl<$Res, _$SubmitReviewImpl>
    implements _$$SubmitReviewImplCopyWith<$Res> {
  __$$SubmitReviewImplCopyWithImpl(
      _$SubmitReviewImpl _value, $Res Function(_$SubmitReviewImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gymId = null,
    Object? rating = null,
    Object? comment = freezed,
  }) {
    return _then(_$SubmitReviewImpl(
      gymId: null == gymId
          ? _value.gymId
          : gymId // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SubmitReviewImpl implements _SubmitReview {
  const _$SubmitReviewImpl(
      {required this.gymId, required this.rating, this.comment});

  @override
  final String gymId;
  @override
  final int rating;
  @override
  final String? comment;

  @override
  String toString() {
    return 'GymsEvent.submitReview(gymId: $gymId, rating: $rating, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmitReviewImpl &&
            (identical(other.gymId, gymId) || other.gymId == gymId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @override
  int get hashCode => Object.hash(runtimeType, gymId, rating, comment);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmitReviewImplCopyWith<_$SubmitReviewImpl> get copyWith =>
      __$$SubmitReviewImplCopyWithImpl<_$SubmitReviewImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(GymFilter? filter, int page, bool refresh)
        loadGyms,
    required TResult Function() loadMore,
    required TResult Function(String query) search,
    required TResult Function() clearSearch,
    required TResult Function(GymFilter filter) applyFilter,
    required TResult Function() clearFilters,
    required TResult Function(String gymId) toggleFavorite,
    required TResult Function(double latitude, double longitude) updateLocation,
    required TResult Function(String gymId) selectGym,
    required TResult Function(String gymId) loadGymDetails,
    required TResult Function(String gymId) loadReviews,
    required TResult Function(String gymId, int rating, String? comment)
        submitReview,
  }) {
    return submitReview(gymId, rating, comment);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult? Function()? loadMore,
    TResult? Function(String query)? search,
    TResult? Function()? clearSearch,
    TResult? Function(GymFilter filter)? applyFilter,
    TResult? Function()? clearFilters,
    TResult? Function(String gymId)? toggleFavorite,
    TResult? Function(double latitude, double longitude)? updateLocation,
    TResult? Function(String gymId)? selectGym,
    TResult? Function(String gymId)? loadGymDetails,
    TResult? Function(String gymId)? loadReviews,
    TResult? Function(String gymId, int rating, String? comment)? submitReview,
  }) {
    return submitReview?.call(gymId, rating, comment);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GymFilter? filter, int page, bool refresh)? loadGyms,
    TResult Function()? loadMore,
    TResult Function(String query)? search,
    TResult Function()? clearSearch,
    TResult Function(GymFilter filter)? applyFilter,
    TResult Function()? clearFilters,
    TResult Function(String gymId)? toggleFavorite,
    TResult Function(double latitude, double longitude)? updateLocation,
    TResult Function(String gymId)? selectGym,
    TResult Function(String gymId)? loadGymDetails,
    TResult Function(String gymId)? loadReviews,
    TResult Function(String gymId, int rating, String? comment)? submitReview,
    required TResult orElse(),
  }) {
    if (submitReview != null) {
      return submitReview(gymId, rating, comment);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadGyms value) loadGyms,
    required TResult Function(_LoadMore value) loadMore,
    required TResult Function(_Search value) search,
    required TResult Function(_ClearSearch value) clearSearch,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_ClearFilters value) clearFilters,
    required TResult Function(_ToggleFavorite value) toggleFavorite,
    required TResult Function(_UpdateLocation value) updateLocation,
    required TResult Function(_SelectGym value) selectGym,
    required TResult Function(_LoadGymDetails value) loadGymDetails,
    required TResult Function(_LoadReviews value) loadReviews,
    required TResult Function(_SubmitReview value) submitReview,
  }) {
    return submitReview(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadGyms value)? loadGyms,
    TResult? Function(_LoadMore value)? loadMore,
    TResult? Function(_Search value)? search,
    TResult? Function(_ClearSearch value)? clearSearch,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_ClearFilters value)? clearFilters,
    TResult? Function(_ToggleFavorite value)? toggleFavorite,
    TResult? Function(_UpdateLocation value)? updateLocation,
    TResult? Function(_SelectGym value)? selectGym,
    TResult? Function(_LoadGymDetails value)? loadGymDetails,
    TResult? Function(_LoadReviews value)? loadReviews,
    TResult? Function(_SubmitReview value)? submitReview,
  }) {
    return submitReview?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadGyms value)? loadGyms,
    TResult Function(_LoadMore value)? loadMore,
    TResult Function(_Search value)? search,
    TResult Function(_ClearSearch value)? clearSearch,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_ClearFilters value)? clearFilters,
    TResult Function(_ToggleFavorite value)? toggleFavorite,
    TResult Function(_UpdateLocation value)? updateLocation,
    TResult Function(_SelectGym value)? selectGym,
    TResult Function(_LoadGymDetails value)? loadGymDetails,
    TResult Function(_LoadReviews value)? loadReviews,
    TResult Function(_SubmitReview value)? submitReview,
    required TResult orElse(),
  }) {
    if (submitReview != null) {
      return submitReview(this);
    }
    return orElse();
  }
}

abstract class _SubmitReview implements GymsEvent {
  const factory _SubmitReview(
      {required final String gymId,
      required final int rating,
      final String? comment}) = _$SubmitReviewImpl;

  String get gymId;
  int get rating;
  String? get comment;
  @JsonKey(ignore: true)
  _$$SubmitReviewImplCopyWith<_$SubmitReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GymsState {
  List<Gym> get gyms => throw _privateConstructorUsedError;
  List<Gym> get searchResults => throw _privateConstructorUsedError;
  List<String> get favoriteIds => throw _privateConstructorUsedError;
  Gym? get selectedGym => throw _privateConstructorUsedError;
  List<GymReview> get reviews => throw _privateConstructorUsedError;
  GymFilter? get currentFilter => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  double? get userLatitude => throw _privateConstructorUsedError;
  double? get userLongitude => throw _privateConstructorUsedError;
  GymsStatus get status => throw _privateConstructorUsedError;
  GymsStatus get detailStatus => throw _privateConstructorUsedError;
  GymsStatus get reviewStatus => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GymsStateCopyWith<GymsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GymsStateCopyWith<$Res> {
  factory $GymsStateCopyWith(GymsState value, $Res Function(GymsState) then) =
      _$GymsStateCopyWithImpl<$Res, GymsState>;
  @useResult
  $Res call(
      {List<Gym> gyms,
      List<Gym> searchResults,
      List<String> favoriteIds,
      Gym? selectedGym,
      List<GymReview> reviews,
      GymFilter? currentFilter,
      String searchQuery,
      int currentPage,
      bool hasMore,
      double? userLatitude,
      double? userLongitude,
      GymsStatus status,
      GymsStatus detailStatus,
      GymsStatus reviewStatus,
      String? errorMessage});
}

/// @nodoc
class _$GymsStateCopyWithImpl<$Res, $Val extends GymsState>
    implements $GymsStateCopyWith<$Res> {
  _$GymsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gyms = null,
    Object? searchResults = null,
    Object? favoriteIds = null,
    Object? selectedGym = freezed,
    Object? reviews = null,
    Object? currentFilter = freezed,
    Object? searchQuery = null,
    Object? currentPage = null,
    Object? hasMore = null,
    Object? userLatitude = freezed,
    Object? userLongitude = freezed,
    Object? status = null,
    Object? detailStatus = null,
    Object? reviewStatus = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      gyms: null == gyms
          ? _value.gyms
          : gyms // ignore: cast_nullable_to_non_nullable
              as List<Gym>,
      searchResults: null == searchResults
          ? _value.searchResults
          : searchResults // ignore: cast_nullable_to_non_nullable
              as List<Gym>,
      favoriteIds: null == favoriteIds
          ? _value.favoriteIds
          : favoriteIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedGym: freezed == selectedGym
          ? _value.selectedGym
          : selectedGym // ignore: cast_nullable_to_non_nullable
              as Gym?,
      reviews: null == reviews
          ? _value.reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<GymReview>,
      currentFilter: freezed == currentFilter
          ? _value.currentFilter
          : currentFilter // ignore: cast_nullable_to_non_nullable
              as GymFilter?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      userLatitude: freezed == userLatitude
          ? _value.userLatitude
          : userLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      userLongitude: freezed == userLongitude
          ? _value.userLongitude
          : userLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as GymsStatus,
      detailStatus: null == detailStatus
          ? _value.detailStatus
          : detailStatus // ignore: cast_nullable_to_non_nullable
              as GymsStatus,
      reviewStatus: null == reviewStatus
          ? _value.reviewStatus
          : reviewStatus // ignore: cast_nullable_to_non_nullable
              as GymsStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GymsStateImplCopyWith<$Res>
    implements $GymsStateCopyWith<$Res> {
  factory _$$GymsStateImplCopyWith(
          _$GymsStateImpl value, $Res Function(_$GymsStateImpl) then) =
      __$$GymsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Gym> gyms,
      List<Gym> searchResults,
      List<String> favoriteIds,
      Gym? selectedGym,
      List<GymReview> reviews,
      GymFilter? currentFilter,
      String searchQuery,
      int currentPage,
      bool hasMore,
      double? userLatitude,
      double? userLongitude,
      GymsStatus status,
      GymsStatus detailStatus,
      GymsStatus reviewStatus,
      String? errorMessage});
}

/// @nodoc
class __$$GymsStateImplCopyWithImpl<$Res>
    extends _$GymsStateCopyWithImpl<$Res, _$GymsStateImpl>
    implements _$$GymsStateImplCopyWith<$Res> {
  __$$GymsStateImplCopyWithImpl(
      _$GymsStateImpl _value, $Res Function(_$GymsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gyms = null,
    Object? searchResults = null,
    Object? favoriteIds = null,
    Object? selectedGym = freezed,
    Object? reviews = null,
    Object? currentFilter = freezed,
    Object? searchQuery = null,
    Object? currentPage = null,
    Object? hasMore = null,
    Object? userLatitude = freezed,
    Object? userLongitude = freezed,
    Object? status = null,
    Object? detailStatus = null,
    Object? reviewStatus = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$GymsStateImpl(
      gyms: null == gyms
          ? _value._gyms
          : gyms // ignore: cast_nullable_to_non_nullable
              as List<Gym>,
      searchResults: null == searchResults
          ? _value._searchResults
          : searchResults // ignore: cast_nullable_to_non_nullable
              as List<Gym>,
      favoriteIds: null == favoriteIds
          ? _value._favoriteIds
          : favoriteIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedGym: freezed == selectedGym
          ? _value.selectedGym
          : selectedGym // ignore: cast_nullable_to_non_nullable
              as Gym?,
      reviews: null == reviews
          ? _value._reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<GymReview>,
      currentFilter: freezed == currentFilter
          ? _value.currentFilter
          : currentFilter // ignore: cast_nullable_to_non_nullable
              as GymFilter?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      userLatitude: freezed == userLatitude
          ? _value.userLatitude
          : userLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      userLongitude: freezed == userLongitude
          ? _value.userLongitude
          : userLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as GymsStatus,
      detailStatus: null == detailStatus
          ? _value.detailStatus
          : detailStatus // ignore: cast_nullable_to_non_nullable
              as GymsStatus,
      reviewStatus: null == reviewStatus
          ? _value.reviewStatus
          : reviewStatus // ignore: cast_nullable_to_non_nullable
              as GymsStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$GymsStateImpl implements _GymsState {
  const _$GymsStateImpl(
      {final List<Gym> gyms = const [],
      final List<Gym> searchResults = const [],
      final List<String> favoriteIds = const [],
      this.selectedGym,
      final List<GymReview> reviews = const [],
      this.currentFilter,
      this.searchQuery = '',
      this.currentPage = 1,
      this.hasMore = false,
      this.userLatitude,
      this.userLongitude,
      this.status = GymsStatus.initial,
      this.detailStatus = GymsStatus.initial,
      this.reviewStatus = GymsStatus.initial,
      this.errorMessage})
      : _gyms = gyms,
        _searchResults = searchResults,
        _favoriteIds = favoriteIds,
        _reviews = reviews;

  final List<Gym> _gyms;
  @override
  @JsonKey()
  List<Gym> get gyms {
    if (_gyms is EqualUnmodifiableListView) return _gyms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_gyms);
  }

  final List<Gym> _searchResults;
  @override
  @JsonKey()
  List<Gym> get searchResults {
    if (_searchResults is EqualUnmodifiableListView) return _searchResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_searchResults);
  }

  final List<String> _favoriteIds;
  @override
  @JsonKey()
  List<String> get favoriteIds {
    if (_favoriteIds is EqualUnmodifiableListView) return _favoriteIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favoriteIds);
  }

  @override
  final Gym? selectedGym;
  final List<GymReview> _reviews;
  @override
  @JsonKey()
  List<GymReview> get reviews {
    if (_reviews is EqualUnmodifiableListView) return _reviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reviews);
  }

  @override
  final GymFilter? currentFilter;
  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  final double? userLatitude;
  @override
  final double? userLongitude;
  @override
  @JsonKey()
  final GymsStatus status;
  @override
  @JsonKey()
  final GymsStatus detailStatus;
  @override
  @JsonKey()
  final GymsStatus reviewStatus;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'GymsState(gyms: $gyms, searchResults: $searchResults, favoriteIds: $favoriteIds, selectedGym: $selectedGym, reviews: $reviews, currentFilter: $currentFilter, searchQuery: $searchQuery, currentPage: $currentPage, hasMore: $hasMore, userLatitude: $userLatitude, userLongitude: $userLongitude, status: $status, detailStatus: $detailStatus, reviewStatus: $reviewStatus, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GymsStateImpl &&
            const DeepCollectionEquality().equals(other._gyms, _gyms) &&
            const DeepCollectionEquality()
                .equals(other._searchResults, _searchResults) &&
            const DeepCollectionEquality()
                .equals(other._favoriteIds, _favoriteIds) &&
            (identical(other.selectedGym, selectedGym) ||
                other.selectedGym == selectedGym) &&
            const DeepCollectionEquality().equals(other._reviews, _reviews) &&
            (identical(other.currentFilter, currentFilter) ||
                other.currentFilter == currentFilter) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.userLatitude, userLatitude) ||
                other.userLatitude == userLatitude) &&
            (identical(other.userLongitude, userLongitude) ||
                other.userLongitude == userLongitude) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.detailStatus, detailStatus) ||
                other.detailStatus == detailStatus) &&
            (identical(other.reviewStatus, reviewStatus) ||
                other.reviewStatus == reviewStatus) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_gyms),
      const DeepCollectionEquality().hash(_searchResults),
      const DeepCollectionEquality().hash(_favoriteIds),
      selectedGym,
      const DeepCollectionEquality().hash(_reviews),
      currentFilter,
      searchQuery,
      currentPage,
      hasMore,
      userLatitude,
      userLongitude,
      status,
      detailStatus,
      reviewStatus,
      errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GymsStateImplCopyWith<_$GymsStateImpl> get copyWith =>
      __$$GymsStateImplCopyWithImpl<_$GymsStateImpl>(this, _$identity);
}

abstract class _GymsState implements GymsState {
  const factory _GymsState(
      {final List<Gym> gyms,
      final List<Gym> searchResults,
      final List<String> favoriteIds,
      final Gym? selectedGym,
      final List<GymReview> reviews,
      final GymFilter? currentFilter,
      final String searchQuery,
      final int currentPage,
      final bool hasMore,
      final double? userLatitude,
      final double? userLongitude,
      final GymsStatus status,
      final GymsStatus detailStatus,
      final GymsStatus reviewStatus,
      final String? errorMessage}) = _$GymsStateImpl;

  @override
  List<Gym> get gyms;
  @override
  List<Gym> get searchResults;
  @override
  List<String> get favoriteIds;
  @override
  Gym? get selectedGym;
  @override
  List<GymReview> get reviews;
  @override
  GymFilter? get currentFilter;
  @override
  String get searchQuery;
  @override
  int get currentPage;
  @override
  bool get hasMore;
  @override
  double? get userLatitude;
  @override
  double? get userLongitude;
  @override
  GymsStatus get status;
  @override
  GymsStatus get detailStatus;
  @override
  GymsStatus get reviewStatus;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$GymsStateImplCopyWith<_$GymsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
