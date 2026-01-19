import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../auth/domain/repositories/auth_repository.dart';
import '../../domain/entities/onboarding_slide.dart';

/// State for onboarding flow
class OnboardingState {
  final int currentPage;
  final String? selectedCity;
  final List<String> selectedInterests;
  final bool isLoading;
  final String? error;
  final bool isComplete;

  const OnboardingState({
    this.currentPage = 0,
    this.selectedCity,
    this.selectedInterests = const [],
    this.isLoading = false,
    this.error,
    this.isComplete = false,
  });

  OnboardingState copyWith({
    int? currentPage,
    String? selectedCity,
    List<String>? selectedInterests,
    bool? isLoading,
    String? error,
    bool? isComplete,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      selectedCity: selectedCity ?? this.selectedCity,
      selectedInterests: selectedInterests ?? this.selectedInterests,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  /// Check if user can proceed to next step
  bool get canProceedToPreferences => currentPage >= OnboardingSlides.slides.length - 1;

  /// Check if preferences are complete
  bool get hasValidPreferences => selectedCity != null && selectedInterests.isNotEmpty;

  /// Total number of slides
  int get totalSlides => OnboardingSlides.slides.length;

  /// Current slide data
  OnboardingSlide? get currentSlide {
    if (currentPage < OnboardingSlides.slides.length) {
      return OnboardingSlides.slides[currentPage];
    }
    return null;
  }
}

/// Cubit for managing onboarding flow
@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  final AuthRepository _authRepository;

  OnboardingCubit(this._authRepository) : super(const OnboardingState());

  /// Move to next slide
  void nextPage() {
    if (state.currentPage < state.totalSlides - 1) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    }
  }

  /// Move to previous slide
  void previousPage() {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }

  /// Jump to specific page
  void goToPage(int page) {
    if (page >= 0 && page < state.totalSlides) {
      emit(state.copyWith(currentPage: page));
    }
  }

  /// Skip onboarding slides
  void skipSlides() {
    emit(state.copyWith(currentPage: state.totalSlides));
  }

  /// Select city
  void selectCity(String cityId) {
    emit(state.copyWith(selectedCity: cityId));
  }

  /// Toggle interest selection
  void toggleInterest(String interestId) {
    final interests = List<String>.from(state.selectedInterests);
    if (interests.contains(interestId)) {
      interests.remove(interestId);
    } else {
      interests.add(interestId);
    }
    emit(state.copyWith(selectedInterests: interests));
  }

  /// Select multiple interests at once
  void setInterests(List<String> interestIds) {
    emit(state.copyWith(selectedInterests: interestIds));
  }

  /// Complete onboarding and save preferences
  Future<void> completeOnboarding() async {
    if (!state.hasValidPreferences) {
      emit(state.copyWith(error: 'Please select a city and at least one interest'));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    final result = await _authRepository.updatePreferences(
      city: state.selectedCity!,
      interests: state.selectedInterests,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (_) => emit(state.copyWith(
        isLoading: false,
        isComplete: true,
      )),
    );
  }

  /// Skip preferences (for guest users)
  Future<void> skipPreferences() async {
    emit(state.copyWith(isComplete: true));
  }

  /// Reset onboarding state
  void reset() {
    emit(const OnboardingState());
  }
}