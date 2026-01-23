import 'package:injectable/injectable.dart';

import '../../../settings/domain/entities/app_settings.dart';

@lazySingleton
class SupportLocalDataSource {
  // Fake in-memory storage (داتا وهمية للتطوير)
  final List<FaqItem> _faqItems = [
    const FaqItem(
      id: '1',
      question: 'How does the gym subscription work?',
      answer:
          'You can buy a bundle and use your visits across partner gyms during the validity period.',
      category: 'General',
    ),
    const FaqItem(
      id: '2',
      question: 'How do I check in at the gym?',
      answer:
          'Open the app, go to the QR Check-in tab, and show the QR code to the gym staff to scan.',
      category: 'Check-in',
    ),
  ];

  AboutInfo getAboutInfo() {
    return const AboutInfo(
      appName: 'MyGym',
      version: '1.0.0',
      buildNumber: '1',
      copyright: '© 2025 MyGym. All rights reserved.',
      privacyPolicyUrl: 'https://mygym.example.com/privacy',
      termsOfServiceUrl: 'https://mygym.example.com/terms',
      contactEmail: 'support@mygym.example.com',
      websiteUrl: 'https://mygym.example.com',
      socialLinks: [
        SocialLink(
          name: 'Instagram',
          url: 'https://instagram.com/mygym',
          icon: 'instagram',
        ),
        SocialLink(
          name: 'Facebook',
          url: 'https://facebook.com/mygym',
          icon: 'facebook',
        ),
      ],
    );
  }

  // in-memory tickets
  final List<SupportTicket> _tickets = [];
  final List<TicketMessage> _messages = [];

  Future<List<FaqItem>> getFaqItems() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _faqItems;
  }

  Future<AboutInfo> getAbout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return getAboutInfo();
  }

  Future<List<SupportTicket>> getMyTickets(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tickets.where((t) => t.userId == userId).toList();
  }

  Future<SupportTicket> createTicket({
    required String userId,
    required String subject,
    required String description,
    required SupportCategory category,
    SupportPriority priority = SupportPriority.normal,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    final ticket = SupportTicket(
      id: 'ticket_${now.millisecondsSinceEpoch}',
      userId: userId,
      subject: subject,
      description: description,
      category: category,
      priority: priority,
      status: TicketStatus.open,
      createdAt: now,
      messages: [],
    );
    _tickets.add(ticket);
    return ticket;
  }

  Future<SupportTicket> getTicketById(String ticketId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _tickets.firstWhere((t) => t.id == ticketId);
  }

  Future<TicketMessage> addMessage({
    required String ticketId,
    required String senderId,
    required String senderName,
    required bool isStaff,
    required String content,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    final msg = TicketMessage(
      id: 'msg_${now.millisecondsSinceEpoch}',
      ticketId: ticketId,
      senderId: senderId,
      senderName: senderName,
      isStaff: isStaff,
      content: content,
      sentAt: now,
    );
    _messages.add(msg);

    // append to ticket messages
    final index = _tickets.indexWhere((t) => t.id == ticketId);
    if (index != -1) {
      final t = _tickets[index];
      final updated = SupportTicket(
        id: t.id,
        userId: t.userId,
        subject: t.subject,
        description: t.description,
        category: t.category,
        priority: t.priority,
        status: t.status,
        createdAt: t.createdAt,
        updatedAt: now,
        resolvedAt: t.resolvedAt,
        messages: [...t.messages, msg],
        assignedTo: t.assignedTo,
      );
      _tickets[index] = updated;
    }

    return msg;
  }
}