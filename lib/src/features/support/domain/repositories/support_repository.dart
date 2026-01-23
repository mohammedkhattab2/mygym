import '../../../settings/domain/entities/app_settings.dart';

abstract class SupportRepository {
  /// Get FAQ items (could be remote/local)
  Future<List<FaqItem>> getFaqItems();

  /// Get about app info
  Future<AboutInfo> getAboutInfo();

  /// Get support tickets for current user
  Future<List<SupportTicket>> getMyTickets();

  /// Create a new support ticket
  Future<SupportTicket> createTicket({
    required String subject,
    required String description,
    required SupportCategory category,
    SupportPriority priority,
  });

  /// Get single ticket details
  Future<SupportTicket> getTicketById(String ticketId);

  /// Add message to ticket
  Future<TicketMessage> addMessage({
    required String ticketId,
    required String message,
    bool fromStaff,
  });
}