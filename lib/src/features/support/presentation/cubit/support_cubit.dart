import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../settings/domain/entities/app_settings.dart';
import '../../domain/repositories/support_repository.dart';

class SupportState {
  final bool isLoading;
  final String? errorMessage;

  final List<FaqItem> faqItems;
  final AboutInfo? aboutInfo;
  final List<SupportTicket> tickets;

  final bool isCreatingTicket;

  const SupportState({
    this.isLoading = false,
    this.errorMessage,
    this.faqItems = const [],
    this.aboutInfo,
    this.tickets = const [],
    this.isCreatingTicket = false,
  });

  SupportState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<FaqItem>? faqItems,
    AboutInfo? aboutInfo,
    List<SupportTicket>? tickets,
    bool? isCreatingTicket,
  }) {
    return SupportState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      faqItems: faqItems ?? this.faqItems,
      aboutInfo: aboutInfo ?? this.aboutInfo,
      tickets: tickets ?? this.tickets,
      isCreatingTicket: isCreatingTicket ?? this.isCreatingTicket,
    );
  }

  factory SupportState.initial() => const SupportState();
}

@injectable
class SupportCubit extends Cubit<SupportState> {
  final SupportRepository _repository;

  SupportCubit(this._repository) : super(SupportState.initial()) {
    loadAll();
  }

  Future<void> loadAll() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final faq = await _repository.getFaqItems();
      final about = await _repository.getAboutInfo();
      final tickets = await _repository.getMyTickets();
      emit(
        state.copyWith(
          isLoading: false,
          faqItems: faq,
          aboutInfo: about,
          tickets: tickets,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> refreshTickets() async {
    try {
      final tickets = await _repository.getMyTickets();
      emit(state.copyWith(tickets: tickets));
    } catch (_) {}
  }

  Future<void> createTicket({
    required String subject,
    required String description,
    required SupportCategory category,
    SupportPriority priority = SupportPriority.normal,
  }) async {
    emit(state.copyWith(isCreatingTicket: true, errorMessage: null));
    try {
      final ticket = await _repository.createTicket(
        subject: subject,
        description: description,
        category: category,
        priority: priority,
      );
      emit(
        state.copyWith(
          isCreatingTicket: false,
          tickets: [ticket, ...state.tickets],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isCreatingTicket: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}