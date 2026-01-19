import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/gym.dart';
import '../../domain/repositories/gym_repository.dart';
part 'gyms_bloc.freezed.dart';

/// Events for Gyms Bloc
@freezed
class GymsEvent with _$GymsEvent {
  /// Load gyms with optional filters
  const factory GymsEvent.loadGyms({
    GymFilter? filter,
    @Default(1) int page,
    @Default(false) bool refresh,
  }) = _LoadGyms;

  /// Load more gyms (pagination)
  const factory GymsEvent.loadMore() = _LoadMore;

  /// Search gyms by query
  const factory GymsEvent.search(String query) = _Search;

  /// Clear search
  const factory GymsEvent.clearSearch() = _ClearSearch;

  /// Apply filter
  const factory GymsEvent.applyFilter(GymFilter filter) = _ApplyFilter;

  /// Clear all filters
  const factory GymsEvent.clearFilters() = _ClearFilters;

  /// Toggle gym favorite
  const factory GymsEvent.toggleFavorite(String gymId) = _ToggleFavorite;

  /// Update user location
  const factory GymsEvent.updateLocation({
    required double latitude,
    required double longitude,
  }) = _UpdateLocation;

  /// Select gym for detail view
  const factory GymsEvent.selectGym(String gymId) = _SelectGym;

  /// Load gym details
  const factory GymsEvent.loadGymDetails(String gymId) = _LoadGymDetails;

  /// Load gym reviews
  const factory GymsEvent.loadReviews(String gymId) = _LoadReviews;

  /// Submit review
  const factory GymsEvent.submitReview({
    required String gymId,
    required int rating,
    String? comment,
  }) = _SubmitReview;
}

/// State for Gyms Bloc
@freezed
class GymsState with _$GymsState {
  const factory GymsState({
    @Default([]) List<Gym> gyms,
    @Default([]) List<Gym> searchResults,
    @Default([]) List<String> favoriteIds,
    Gym? selectedGym,
    @Default([]) List<GymReview> reviews,
    GymFilter? currentFilter,
    @Default('') String searchQuery,
    @Default(1) int currentPage,
    @Default(false) bool hasMore,
    double? userLatitude,
    double? userLongitude,
    @Default(GymsStatus.initial) GymsStatus status,
    @Default(GymsStatus.initial) GymsStatus detailStatus,
    @Default(GymsStatus.initial) GymsStatus reviewStatus,
    String? errorMessage,
  }) = _GymsState;
}

/// Status enum for gyms operations
enum GymsStatus {
  initial,
  loading,
  loadingMore,
  success,
  failure,
}

/// Bloc for managing gym list and details
@injectable
class GymsBloc extends Bloc<GymsEvent, GymsState> {
  final GymRepository _gymRepository;

  GymsBloc(this._gymRepository) : super(const GymsState()) {
    on<_LoadGyms>(_onLoadGyms);
    on<_LoadMore>(_onLoadMore);
    on<_Search>(_onSearch);
    on<_ClearSearch>(_onClearSearch);
    on<_ApplyFilter>(_onApplyFilter);
    on<_ClearFilters>(_onClearFilters);
    on<_ToggleFavorite>(_onToggleFavorite);
    on<_UpdateLocation>(_onUpdateLocation);
    on<_SelectGym>(_onSelectGym);
    on<_LoadGymDetails>(_onLoadGymDetails);
    on<_LoadReviews>(_onLoadReviews);
    on<_SubmitReview>(_onSubmitReview);
  }

  Future<void> _onLoadGyms(
    _LoadGyms event,
    Emitter<GymsState> emit,
  ) async {
    if (state.userLatitude == null || state.userLongitude == null) {
      emit(state.copyWith(
        status: GymsStatus.failure,
        errorMessage: 'Location not available',
      ));
      return;
    }

    emit(state.copyWith(
      status: event.refresh ? GymsStatus.loading : state.status,
      currentPage: event.page,
      currentFilter: event.filter ?? state.currentFilter,
    ));

    final result = await _gymRepository.getGyms(
      latitude: state.userLatitude!,
      longitude: state.userLongitude!,
      filter: event.filter ?? state.currentFilter,
      page: event.page,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: GymsStatus.failure,
        errorMessage: failure.message,
      )),
      (gyms) => emit(state.copyWith(
        status: GymsStatus.success,
        gyms: event.page == 1 ? gyms : [...state.gyms, ...gyms],
        hasMore: gyms.length >= 20,
        currentPage: event.page,
      )),
    );
  }

  Future<void> _onLoadMore(
    _LoadMore event,
    Emitter<GymsState> emit,
  ) async {
    if (!state.hasMore || state.status == GymsStatus.loadingMore) return;

    emit(state.copyWith(status: GymsStatus.loadingMore));

    add(GymsEvent.loadGyms(
      filter: state.currentFilter,
      page: state.currentPage + 1,
    ));
  }

  Future<void> _onSearch(
    _Search event,
    Emitter<GymsState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(
        searchQuery: '',
        searchResults: [],
      ));
      return;
    }

    emit(state.copyWith(
      searchQuery: event.query,
      status: GymsStatus.loading,
    ));

    final result = await _gymRepository.searchGyms(
      query: event.query,
      latitude: state.userLatitude,
      longitude: state.userLongitude,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: GymsStatus.failure,
        errorMessage: failure.message,
      )),
      (gyms) => emit(state.copyWith(
        status: GymsStatus.success,
        searchResults: gyms,
      )),
    );
  }

  Future<void> _onClearSearch(
    _ClearSearch event,
    Emitter<GymsState> emit,
  ) async {
    emit(state.copyWith(
      searchQuery: '',
      searchResults: [],
    ));
  }

  Future<void> _onApplyFilter(
    _ApplyFilter event,
    Emitter<GymsState> emit,
  ) async {
    add(GymsEvent.loadGyms(filter: event.filter, refresh: true));
  }

  Future<void> _onClearFilters(
    _ClearFilters event,
    Emitter<GymsState> emit,
  ) async {
    emit(state.copyWith(currentFilter: null));
    add(const GymsEvent.loadGyms(refresh: true));
  }

  Future<void> _onToggleFavorite(
    _ToggleFavorite event,
    Emitter<GymsState> emit,
  ) async {
    final isFavorite = state.favoriteIds.contains(event.gymId);
    
    // Optimistic update
    final updatedFavorites = isFavorite
        ? state.favoriteIds.where((id) => id != event.gymId).toList()
        : [...state.favoriteIds, event.gymId];
    
    emit(state.copyWith(favoriteIds: updatedFavorites));

    final result = isFavorite
        ? await _gymRepository.removeFromFavorites(event.gymId)
        : await _gymRepository.addToFavorites(event.gymId);

    result.fold(
      (failure) {
        // Revert on failure
        emit(state.copyWith(favoriteIds: state.favoriteIds));
      },
      (_) {},
    );
  }

  Future<void> _onUpdateLocation(
    _UpdateLocation event,
    Emitter<GymsState> emit,
  ) async {
    emit(state.copyWith(
      userLatitude: event.latitude,
      userLongitude: event.longitude,
    ));

    // Reload gyms with new location
    add(const GymsEvent.loadGyms(refresh: true));
  }

  Future<void> _onSelectGym(
    _SelectGym event,
    Emitter<GymsState> emit,
  ) async {
    final gym = state.gyms.firstWhere(
      (g) => g.id == event.gymId,
      orElse: () => state.searchResults.firstWhere(
        (g) => g.id == event.gymId,
      ),
    );
    emit(state.copyWith(selectedGym: gym));
  }

  Future<void> _onLoadGymDetails(
    _LoadGymDetails event,
    Emitter<GymsState> emit,
  ) async {
    emit(state.copyWith(detailStatus: GymsStatus.loading));

    final result = await _gymRepository.getGymById(event.gymId);

    result.fold(
      (failure) => emit(state.copyWith(
        detailStatus: GymsStatus.failure,
        errorMessage: failure.message,
      )),
      (gym) => emit(state.copyWith(
        detailStatus: GymsStatus.success,
        selectedGym: gym,
      )),
    );
  }

  Future<void> _onLoadReviews(
    _LoadReviews event,
    Emitter<GymsState> emit,
  ) async {
    emit(state.copyWith(reviewStatus: GymsStatus.loading));

    final result = await _gymRepository.getGymReviews(gymId: event.gymId);

    result.fold(
      (failure) => emit(state.copyWith(
        reviewStatus: GymsStatus.failure,
        errorMessage: failure.message,
      )),
      (reviews) => emit(state.copyWith(
        reviewStatus: GymsStatus.success,
        reviews: reviews,
      )),
    );
  }

  Future<void> _onSubmitReview(
    _SubmitReview event,
    Emitter<GymsState> emit,
  ) async {
    emit(state.copyWith(reviewStatus: GymsStatus.loading));

    final result = await _gymRepository.submitReview(
      gymId: event.gymId,
      rating: event.rating,
      comment: event.comment,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        reviewStatus: GymsStatus.failure,
        errorMessage: failure.message,
      )),
      (review) => emit(state.copyWith(
        reviewStatus: GymsStatus.success,
        reviews: [review, ...state.reviews],
      )),
    );
  }
}