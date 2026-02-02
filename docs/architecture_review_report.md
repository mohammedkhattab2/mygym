# Architecture Review Report — MyGym

This independent technical review compares the documented architecture with the current implementation and enumerates gaps, risks, and actionable recommendations to reach MVVM + Clean Architecture compliance.

## 1. Executive Summary

The project exhibits meaningful structure toward the target architecture: feature-driven folders, DI via get_it + injectable, go_router navigation, centralized error primitives, and environment-aware configuration. However, multiple critical gaps and deviations from the documented architecture persist:

- Domain use cases are broadly absent across features, weakening separation of concerns and testability.
- The subscription access model is incomplete and not enforced (missing guard integration).
- Token lifecycle (refresh on 401) is not implemented.
- Repositories directly call Dio and parse JSON internally instead of delegating to remote/local data sources and models.
- Inconsistent error mapping; central ErrorHandler exists but is not leveraged in repositories.
- Duplicate HTTP configuration pathways (raw Dio vs a DioClient wrapper) increase the risk of bypassing interceptors.
- Layering concerns: Flutter UI types appear in data/domain usage (e.g., TimeOfDay in gym parsing).
- Flavors/bootstrapping entrypoints defined in the documentation are missing.
- Caching/offline readiness is ad-hoc or stubbed; many features rely on dummy/in-memory sources.
- Testing coverage is minimal and does not reflect the documented testing strategy.

Net effect: current state is not yet production-ready. It is suitable for iterative UI/UX development and demos, but security, scalability, and maintainability need targeted improvements.

## 2. Architecture Alignment Score

Low

## 3. Missing or Incomplete Components

- Domain use cases absent or inconsistent per feature, despite being required by MVVM + Clean (see [architectureReport.md](docs/architectureReport.md)).
- Subscription access model incomplete and not enforced:
  - Incomplete status resolution (TODO) in [subscription_guard.dart](lib/src/core/router/guards/subscription_guard.dart)
  - No routing-time enforcement in [app_router.dart](lib/src/core/router/app_router.dart)
- Token refresh flow on 401 is not implemented in [auth_interceptor.dart](lib/src/core/network/interceptors/auth_interceptor.dart)
- Flavors and bootstrap entrypoints are missing vs documented folder structure (only [main.dart](lib/main.dart) exists; no main_development.dart, main_staging.dart, main_production.dart, bootstrap.dart)
- Data sources separation is inconsistent:
  - Repositories directly perform Dio calls and parse JSON inside the repository (e.g., [gym_repository_impl.dart](lib/src/features/gyms/data/repositories/gym_repository_impl.dart))
  - Subscriptions, classes, gyms rely on dummy/in-memory data instead of concrete remote/local sources and DTOs
- Central error mapping facility [error_handler.dart](lib/src/core/error/error_handler.dart) is not systematically used in repositories
- Environment config lacks flavor entrypoints and flavor_config despite partial config in [app_config.dart](lib/src/core/config/app_config.dart) and [environment.dart](lib/src/core/config/environment.dart)
- Caching/offline strategy is minimal; only basic Hive boxes are wired ([storage_module.dart](lib/src/core/di/modules/storage_module.dart)) with limited consistent use in data layer
- Security gaps in role/subscription routing enforcement (admin/partner/member access constrained but subscription access is not enforced)
- Testing coverage is insufficient (only scaffold test in [widget_test.dart](test/widget_test.dart))

## 4. Deviations from Architecture Report

What is documented but not implemented or only partially present (evidence in code):

- Documented use cases per feature (Auth, Gyms, Subscriptions, Classes, Rewards, History, Profile, Partner, Admin) are missing in the codebase. See the documented structure in [architectureReport.md](docs/architectureReport.md).
- Documented flavor-specific entrypoints and bootstrap are absent (main_development.dart, main_staging.dart, main_production.dart, bootstrap.dart). Current app uses a single [main.dart](lib/main.dart).
- Documented network layer using a central API client and structured data sources is not realized. Code mixes:
  - Raw Dio via DI with interceptors in [network_module.dart](lib/src/core/di/modules/network_module.dart)
  - A separate [dio_client.dart](lib/src/core/network/dio_client.dart) not consistently adopted by repositories
  - Repositories often embed parsing and HTTP logic directly (e.g., [gym_repository_impl.dart](lib/src/features/gyms/data/repositories/gym_repository_impl.dart))
- Route guards are defined ([auth_guard.dart](lib/src/core/router/guards/auth_guard.dart), [role_guard.dart](lib/src/core/router/guards/role_guard.dart), [subscription_guard.dart](lib/src/core/router/guards/subscription_guard.dart)) but subscription guard is neither implemented nor integrated in [app_router.dart](lib/src/core/router/app_router.dart)
- Error model alignment: centralized exceptions/failures exist ([exceptions.dart](lib/src/core/error/exceptions.dart), [failures.dart](lib/src/core/error/failures.dart), [error_handler.dart](lib/src/core/error/error_handler.dart)), but repositories typically map errors ad-hoc instead of routing them through ErrorHandler
- Security architecture around token refresh is incomplete (401 handling TODO in [auth_interceptor.dart](lib/src/core/network/interceptors/auth_interceptor.dart))
- Classes and other features rely on local/dummy sources (e.g., [classes_local_data_source.dart](lib/src/features/classes/data/datasources/classes_local_data_source.dart)) instead of the documented remote data sources, DTOs, and repositories

## 5. Technical Debt & Risks

Short-term risks:
- Unimplemented token refresh and subscription enforcement can lead to broken auth flows and unauthorized access in protected flows ([auth_interceptor.dart](lib/src/core/network/interceptors/auth_interceptor.dart), [subscription_guard.dart](lib/src/core/router/guards/subscription_guard.dart))
- Inconsistent error handling across repositories will cause fragmented UX and inconsistent failure semantics ([error_handler.dart](lib/src/core/error/error_handler.dart), repository code paths in [gym_repository_impl.dart](lib/src/features/gyms/data/repositories/gym_repository_impl.dart))
- Duplicate HTTP pathways (Dio vs DioClient) risk interceptors being bypassed and increases maintenance cost ([network_module.dart](lib/src/core/di/modules/network_module.dart), [dio_client.dart](lib/src/core/network/dio_client.dart))
- Role-based routing partially enforced; subscription-based access not enforced in router ([app_router.dart](lib/src/core/router/app_router.dart))
- Heavy reliance on dummy/in-memory data creates hidden coupling in UI expectations and weakens integration test coverage (e.g., [subscription_repository_impl.dart](lib/src/features/subscriptions/data/repositories/subscription_repository_impl.dart), [classes_local_data_source.dart](lib/src/features/classes/data/datasources/classes_local_data_source.dart))

Long-term risks:
- Missing domain use cases reduces modularity, reusability, and testability; business logic spreads across blocs/cubits and repositories
- Layering violations (e.g., TimeOfDay usage in data/domain types) bind core to Flutter and risk portability
- Absence of comprehensive tests undermines refactor safety and scalability ([widget_test.dart](test/widget_test.dart))
- Environment setup without flavor entrypoints impedes safe runtime configuration and secure secret management (partial in [app_config.dart](lib/src/core/config/app_config.dart), missing flavor entrypoints)
- Caching/offline readiness is not standardized; risk of inconsistent behavior and data integrity issues across features

## 6. Recommendations (Prioritized, Actionable)

1) Implement token lifecycle management
- Add refresh token flow on 401 in [auth_interceptor.dart](lib/src/core/network/interceptors/auth_interceptor.dart) and centralize retry logic; persist new tokens using [secure_storage.dart](lib/src/core/storage/secure_storage.dart)
- Ensure ErrorInterceptor continues mapping to domain exceptions ([error_interceptor.dart](lib/src/core/network/interceptors/error_interceptor.dart))

2) Enforce subscription access in routing
- Implement [subscription_guard.dart](lib/src/core/router/guards/subscription_guard.dart) to query the current subscription from the repository and cache status
- Apply the guard to routes requiring active subscription in [app_router.dart](lib/src/core/router/app_router.dart) and central redirect logic; use [route_paths.dart](lib/src/core/router/route_paths.dart) to keep paths centralized

3) Restore Clean Architecture vertical slice per feature
- Introduce domain use cases to isolate business logic across features (Auth, Gyms, Subscriptions, Classes, Rewards, Profile, Partner, Admin) following the documented structure in [architectureReport.md](docs/architectureReport.md)
- Ensure ViewModels/Blocs delegate to use cases; repositories depend only on abstractions in domain

4) Normalize the Data layer
- Create explicit remote/local data sources and DTO models; move HTTP calls and JSON parsing out of repositories (e.g., refactor [gym_repository_impl.dart](lib/src/features/gyms/data/repositories/gym_repository_impl.dart))
- Adopt a single HTTP client path:
  - Either standardize on DI-provided Dio in [network_module.dart](lib/src/core/di/modules/network_module.dart) (with interceptors) and remove [dio_client.dart](lib/src/core/network/dio_client.dart), or
  - Standardize on [dio_client.dart](lib/src/core/network/dio_client.dart) and have modules inject and wrap it consistently
- Guarantee all repository calls pass through interceptors

5) Apply centralized error mapping
- Route all repository exceptions through [error_handler.dart](lib/src/core/error/error_handler.dart) so presentation consistently handles Failure objects and user-friendly messages

6) Fix layering violations
- Eliminate Flutter UI types from domain/data (e.g., TimeOfDay usage in gym working hours found via [gym_repository_impl.dart](lib/src/features/gyms/data/repositories/gym_repository_impl.dart)); replace with pure value types in domain and map to UI types in presentation

7) Introduce flavors and bootstrap entrypoints
- Align runtime configuration with documentation: add main_development.dart, main_staging.dart, main_production.dart, and bootstrap wiring per [architectureReport.md](docs/architectureReport.md)
- Keep environment selection in [app_config.dart](lib/src/core/config/app_config.dart) and [environment.dart](lib/src/core/config/environment.dart) but source them from per-flavor entrypoints

8) Standardize caching and offline strategy
- Utilize Hive boxes provided in [storage_module.dart](lib/src/core/di/modules/storage_module.dart) uniformly; define per-feature cache policies and invalidation rules in local data sources

9) Strengthen security posture
- Ensure role-based routes stay enforced and expand to subscription-based guards in [app_router.dart](lib/src/core/router/app_router.dart); confirm sensitive screens/actions cannot be reached without proper status
- Audit QR-related flows to ensure ephemeral token handling aligns with security design once backends are present

10) Establish testing layers and CI hooks
- Add unit tests for repositories and use cases; bloc/cubit tests for presentation; widget tests for key screens; end-to-end happy-path flows
- Start by covering auth and subscriptions (critical paths), then gyms and classes; expand from there (scaffold exists at [widget_test.dart](test/widget_test.dart))

## 7. Release Readiness Verdict

No. The architecture is not production-ready in its current state due to:
- Missing token refresh and subscription guard enforcement
- Incomplete separation of concerns (no use cases, repos performing HTTP and parsing)
- Inconsistent error handling and duplicate HTTP client pathways
- Insufficient testing and missing flavor entrypoints

Conditional readiness can be achieved by delivering items 1 through 5 in Recommendations as a minimum increment, followed by flavors and test coverage to stabilize the codebase for scaling.

## Evidence Index (files reviewed)

- Documentation
  - [architectureReport.md](docs/architectureReport.md)

- Routing and Guards
  - [app_router.dart](lib/src/core/router/app_router.dart)
  - [route_paths.dart](lib/src/core/router/route_paths.dart)
  - [auth_guard.dart](lib/src/core/router/guards/auth_guard.dart)
  - [role_guard.dart](lib/src/core/router/guards/role_guard.dart)
  - [subscription_guard.dart](lib/src/core/router/guards/subscription_guard.dart)

- Network and Error Handling
  - [network_module.dart](lib/src/core/di/modules/network_module.dart)
  - [auth_interceptor.dart](lib/src/core/network/interceptors/auth_interceptor.dart)
  - [error_interceptor.dart](lib/src/core/network/interceptors/error_interceptor.dart)
  - [dio_client.dart](lib/src/core/network/dio_client.dart)
  - [error_handler.dart](lib/src/core/error/error_handler.dart)
  - [exceptions.dart](lib/src/core/error/exceptions.dart)
  - [failures.dart](lib/src/core/error/failures.dart)
  - [network_info.dart](lib/src/core/network/network_info.dart)

- Configuration and DI
  - [main.dart](lib/main.dart)
  - [app.dart](lib/src/app.dart)
  - [app_config.dart](lib/src/core/config/app_config.dart)
  - [environment.dart](lib/src/core/config/environment.dart)
  - [injection.dart](lib/src/core/di/injection.dart)
  - [storage_module.dart](lib/src/core/di/modules/storage_module.dart)
  - [secure_storage.dart](lib/src/core/storage/secure_storage.dart)

- Feature samples (Data layer and sources)
  - [gym_repository_impl.dart](lib/src/features/gyms/data/repositories/gym_repository_impl.dart)
  - [subscription_repository_impl.dart](lib/src/features/subscriptions/data/repositories/subscription_repository_impl.dart)
  - [classes_local_data_source.dart](lib/src/features/classes/data/datasources/classes_local_data_source.dart)