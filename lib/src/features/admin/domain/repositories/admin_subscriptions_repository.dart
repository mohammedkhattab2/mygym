import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/admin_subscription.dart';

abstract class AdminSubscriptionsRepository {
  Future<Either<Failure, PaginatedSubscriptions>> getSubscriptions(AdminSubscriptionFilter filter);
  Future<Either<Failure, AdminSubscription>> getSubscriptionById(String subscriptionId);
  Future<Either<Failure, SubscriptionsStats>> getSubscriptionsStats();
  Future<Either<Failure, AdminSubscription>> cancelSubscription(String subscriptionId, String reason);
  Future<Either<Failure, AdminSubscription>> pauseSubscription(String subscriptionId);
  Future<Either<Failure, AdminSubscription>> resumeSubscription(String subscriptionId);
  Future<Either<Failure, AdminSubscription>> extendSubscription(String subscriptionId, int days);
  Future<Either<Failure, String>> exportSubscriptionsToCSV(AdminSubscriptionFilter filter);
  Future<Either<Failure, int>> sendRenewalReminders(List<String> subscriptionIds);
}