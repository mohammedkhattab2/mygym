import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/subscription_plan.dart';
import '../entities/admin_subscription.dart';

abstract class SubscriptionPlansRepository {
  // Plans
  Future<Either<Failure, List<SubscriptionPlan>>> getAllPlans();
  Future<Either<Failure, SubscriptionPlan>> getPlanById(String planId);
  Future<Either<Failure, SubscriptionPlan>> createPlan(SubscriptionPlanFormData data);
  Future<Either<Failure, SubscriptionPlan>> updatePlan(String planId, SubscriptionPlanFormData data);
  Future<Either<Failure, void>> deletePlan(String planId);
  Future<Either<Failure, SubscriptionPlan>> togglePlanStatus(String planId);
  Future<Either<Failure, void>> reorderPlans(List<String> planIds);

  // Promotions
  Future<Either<Failure, List<Promotion>>> getAllPromotions();
  Future<Either<Failure, Promotion>> getPromotionById(String promotionId);
  Future<Either<Failure, Promotion>> createPromotion(PromotionFormData data);
  Future<Either<Failure, Promotion>> updatePromotion(String promotionId, PromotionFormData data);
  Future<Either<Failure, void>> deletePromotion(String promotionId);
  Future<Either<Failure, Promotion>> togglePromotionStatus(String promotionId);
  Future<Either<Failure, Promotion>> validatePromoCode(String code);
}