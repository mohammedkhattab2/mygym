import 'package:injectable/injectable.dart';

import '../../../settings/domain/entities/app_settings.dart';
import '../../domain/repositories/support_repository.dart';
import '../datasources/support_local_data_source.dart';

@LazySingleton(as: SupportRepository)
class SupportRepositoryImpl implements SupportRepository {
  final SupportLocalDataSource _local;

  // ملاحظة: هنا مفترضين إن عندك userId متاح من auth؛
  // مؤقتًا هنستخدم userId ثابت 'user_1'
  static const _dummyUserId = 'user_1';

  SupportRepositoryImpl(this._local);

  @override
  Future<List<FaqItem>> getFaqItems() {
    return _local.getFaqItems();
  }

  @override
  Future<AboutInfo> getAboutInfo() {
    return _local.getAbout();
  }

  @override
  Future<List<SupportTicket>> getMyTickets() {
    return _local.getMyTickets(_dummyUserId);
  }

  @override
  Future<SupportTicket> createTicket({
    required String subject,
    required String description,
    required SupportCategory category,
    SupportPriority priority = SupportPriority.normal,
  }) {
    return _local.createTicket(
      userId: _dummyUserId,
      subject: subject,
      description: description,
      category: category,
      priority: priority,
    );
  }

  @override
  Future<SupportTicket> getTicketById(String ticketId) {
    return _local.getTicketById(ticketId);
  }

  @override
  Future<TicketMessage> addMessage({
    required String ticketId,
    required String message,
    bool fromStaff = false,
  }) {
    return _local.addMessage(
      ticketId: ticketId,
      senderId: _dummyUserId,
      senderName: 'You',
      isStaff: fromStaff,
      content: message,
    );
  }
}