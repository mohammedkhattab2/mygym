// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/admin/presentation/bloc/admin_dashboard_cubit.dart';
import 'package:mygym/src/features/admin/presentation/views/admin_dashboard_view.dart';
import 'package:mygym/src/features/admin/presentation/views/admin_gym_form_view.dart';
import 'package:mygym/src/features/admin/presentation/views/admin_gyms_table_view.dart';
import 'package:mygym/src/features/admin/presentation/views/admin_settings_view.dart';
import 'package:mygym/src/features/auth/presentation/views/login_view.dart';
import 'package:mygym/src/features/auth/presentation/views/otp_view.dart';
import 'package:mygym/src/features/classes/presentation/cubit/classes_cubit.dart';
import 'package:mygym/src/features/classes/presentation/views/class_detail_view.dart';
import 'package:mygym/src/features/classes/presentation/views/class_schedule_view.dart';
import 'package:mygym/src/features/classes/presentation/views/classes_calendar_view.dart';
import 'package:mygym/src/features/classes/presentation/views/my_bookings_view.dart';
import 'package:mygym/src/features/gyms/presentation/bloc/gym_filter_cubit.dart';
import 'package:mygym/src/features/gyms/presentation/views/gym_filter_view.dart';
import 'package:mygym/src/features/home/presentation/views/home_view.dart';
import 'package:mygym/src/features/partner/presentation/cubit/partner_settings_cubit.dart';
import 'package:mygym/src/features/partner/presentation/cubit/blocked_users_cubit.dart';
import 'package:mygym/src/features/partner/presentation/views/partner_settings_view.dart';
import 'package:mygym/src/features/partner/presentation/views/blocked_users_view.dart';
import 'package:mygym/src/features/rewards/presentation/cubit/rewards_cubit.dart';
import 'package:mygym/src/features/rewards/presentation/views/my_vouchers_view.dart';
import 'package:mygym/src/features/rewards/presentation/views/points_history_view.dart';
import 'package:mygym/src/features/rewards/presentation/views/referrals_view.dart';
import 'package:mygym/src/features/rewards/presentation/views/rewards_list_view.dart';
import 'package:mygym/src/features/search/presentation/views/search_view.dart';
import 'package:mygym/src/features/onboarding/presentation/presentation/views/onboarding_view.dart';
import 'package:mygym/src/features/partner/presentation/cubit/partner_dashboard_cubit.dart';
import 'package:mygym/src/features/partner/presentation/views/partner_dashboard_view.dart';
import 'package:mygym/src/features/partner/presentation/views/partner_reports_view.dart';
import 'package:mygym/src/features/profile/presentation/views/edit_profile_view.dart';
import 'package:mygym/src/features/profile/presentation/views/profile_view.dart';
import 'package:mygym/src/features/qr_checkin/presentation/bloc/qr_checkin_cubit.dart';
import 'package:mygym/src/features/qr_checkin/presentation/views/qr_check_in_view.dart';
import 'package:mygym/src/features/qr_checkin/presentation/views/qr_scanner_view.dart';
import 'package:mygym/src/features/qr_checkin/presentation/views/visit_history_view.dart';
import 'package:mygym/src/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mygym/src/features/settings/presentation/views/language_settings_view.dart';
import 'package:mygym/src/features/settings/presentation/views/notification_settings_view.dart';
import 'package:mygym/src/features/settings/presentation/views/settings_view.dart';
import 'package:mygym/src/features/splash/presentation/views/splash_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygym/src/features/gyms/presentation/views/gym_details_view.dart';
import 'package:mygym/src/features/gyms/presentation/bloc/gyms_bloc.dart';
import 'package:mygym/src/core/di/injection.dart';
import 'package:mygym/src/features/gyms/presentation/views/gyms_map_view.dart';

import 'package:mygym/src/features/gyms/presentation/views/gyms_list_view.dart';
import 'package:mygym/src/features/subscriptions/presentation/cubit/subscriptions_cubit.dart';
import 'package:mygym/src/features/subscriptions/presentation/views/bundles_view.dart';
import 'package:mygym/src/features/subscriptions/presentation/views/checkout_view.dart';
import 'package:mygym/src/features/subscriptions/presentation/views/invoices_view.dart';
import 'package:mygym/src/features/subscriptions/presentation/views/payment_webview.dart';
import 'package:mygym/src/features/support/presentation/cubit/support_cubit.dart';
import 'package:mygym/src/features/support/presentation/views/about_view.dart';
import 'package:mygym/src/features/support/presentation/views/faq_view.dart';
import 'package:mygym/src/features/support/presentation/views/support_hub_view.dart';
import 'package:mygym/src/features/support/presentation/views/tickets_view.dart';
import 'guards/auth_guard.dart';
import 'guards/role_guard.dart';
import 'guards/subscription_guard.dart';
import 'route_paths.dart';

/// Application router configuration using go_router
@lazySingleton
class AppRouter {
  AppRouter({
    required this.authGuard,
    required this.roleGuard,
    required this.subscriptionGuard,
  });

  final AuthGuard authGuard;
  final RoleGuard roleGuard;
  final SubscriptionGuard subscriptionGuard;

  /// Navigator key for root navigator
  final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );

  /// Navigator key for shell navigator (bottom nav)
  final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  /// Navigator key for partner shell
  final GlobalKey<NavigatorState> _partnerShellKey = GlobalKey<NavigatorState>(
    debugLabel: 'partner',
  );

  /// Navigator key for admin shell
  final GlobalKey<NavigatorState> _adminShellKey = GlobalKey<NavigatorState>(
    debugLabel: 'admin',
  );

  /// Create the router configuration
  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    redirect: _handleRedirect,
    routes: [
      // Splash route
      GoRoute(
        path: RoutePaths.splash,
        name: 'splash',
        builder: (context, state) => const SplashView(),
      ),

      // Auth routes
      GoRoute(
        path: RoutePaths.auth,
        name: 'auth',
        builder: (context, state) =>
            const LoginView(), // Shows login for /auth directly
        routes: [
          GoRoute(
            path: 'login',
            name: 'login',
            builder: (context, state) => const LoginView(),
          ),
          GoRoute(
            path: 'otp',
            name: 'otp-verification',
            builder: (context, state) {
              final phoneNumber = state.extra as String? ?? '+20 XXX XXX XXXX';
              return OtpView(phoneNumber: phoneNumber);
            },
          ),
        ],
      ),

      // Onboarding routes
      GoRoute(
        path: RoutePaths.onboarding,
        name: 'onboarding',
        redirect: (context, state) {
          if (state.uri.path == RoutePaths.onboarding) {
            return RoutePaths.onboardingSlides;
          }
          return null;
        },
        routes: [
          GoRoute(
            path: 'slides',
            name: 'onboarding-slides',
            builder: (context, state) => const OnboardingView(),
          ),
          GoRoute(
            path: 'city',
            name: 'city-selection',
            builder: (context, state) =>
                const _PlaceholderPage(title: 'City Selection'),
          ),
          GoRoute(
            path: 'interests',
            name: 'interests-selection',
            builder: (context, state) =>
                const _PlaceholderPage(title: 'Interests Selection'),
          ),
        ],
      ),

      // Member shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return BlocProvider(
            create: (ctx) => getIt<GymsBloc>(),
            child: _MemberShellScaffold(child: child),
          );
        },
        routes: [
          // Home
          GoRoute(
            path: RoutePaths.memberHome,
            name: 'member-home',
            builder: (context, state) => const HomeView(),
          ),

          // Search
          GoRoute(
            path: RoutePaths.search,
            name: 'search',
            builder: (context, state) => const SearchView(),
          ),

          // Gyms
          GoRoute(
            path: RoutePaths.gyms,
            name: 'gyms',
            redirect: (context, state) {
              if (state.uri.path == RoutePaths.gyms) {
                return RoutePaths.gymsMap;
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'map',
                name: 'gyms-map',
                builder: (context, state) {
                  // Trigger location update if not already loaded
                  final bloc = context.read<GymsBloc>();
                  if (bloc.state.userLatitude == null) {
                    bloc.add(
                      const GymsEvent.updateLocation(
                        latitude: 30.0444,
                        longitude: 31.2357,
                      ),
                    );
                  }
                  return const GymsMapView();
                },
              ),
              GoRoute(
                path: 'list',
                name: 'gyms-list',
                builder: (context, state) {
                  // Trigger location update if not already loaded
                  final bloc = context.read<GymsBloc>();
                  if (bloc.state.userLatitude == null) {
                    bloc.add(
                      const GymsEvent.updateLocation(
                        latitude: 30.0444, // Cairo lat
                        longitude: 31.2357, // Cairo lng
                      ),
                    );
                  }
                  return const GymsListView();
                },
              ),
              // IMPORTANT: 'filter' must come BEFORE ':gymId' because :gymId is a wildcard
              // that matches any string including "filter"
              GoRoute(
                path: 'filter',
                name: 'gym-filter',
                builder: (context, state) {
                  final gymsBloc = context.read<GymsBloc>();
                  return BlocProvider(
                    create: (ctx) => GymFilterCubit(gymsBloc),
                    child: const GymFilterView(),
                  );
                },
              ),
              GoRoute(
                path: ':gymId',
                name: 'gym-detail',
                builder: (context, state) {
                  final gymId = state.pathParameters['gymId']!;
                  final bloc = context.read<GymsBloc>();
                  bloc.add(GymsEvent.loadGymDetails(gymId));
                  bloc.add(GymsEvent.loadReviews(gymId));
                  return GymDetailsView(gymId: gymId);
                },
              ),
            ],
          ),

          // Subscriptions
          // Subscriptions routes - Update placeholders
          GoRoute(
            path: RoutePaths.subscriptions,
            name: 'subscriptions',
            redirect: (context, state) {
              if (state.uri.path == RoutePaths.subscriptions) {
                return RoutePaths.bundles;
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'bundles',
                name: 'bundles',
                builder: (context, state) {
                  return BlocProvider(
                    create: (ctx) => getIt<SubscriptionsCubit>()..loadInitial(),
                    child: const BundlesView(),
                  );
                },
              ),
              GoRoute(
                path: 'checkout/:bundleId',
                name: 'checkout',
                builder: (context, state) {
                  final bundleId = state.pathParameters['bundleId']!;
                  // SubscriptionsCubit should already be in the tree from BundlesView
                  // If not, we need to provide it
                  return BlocProvider(
                    create: (ctx) => getIt<SubscriptionsCubit>()..loadInitial(),
                    child: CheckoutView(bundleId: bundleId),
                  );
                },
              ),
              GoRoute(
                path: 'payment',
                name: 'payment',
                builder: (context, state) {
                  return BlocProvider(
                    create: (ctx) => getIt<SubscriptionsCubit>(),
                    child: const PaymentWebView(),
                  );
                },
              ),
              GoRoute(
                path: 'invoices',
                name: 'invoices',
                builder: (context, state) {
                  return BlocProvider(
                    create: (ctx) =>
                        getIt<SubscriptionsCubit>()..loadInvoices(),
                    child: const InvoicesView(),
                  );
                },
              ),
            ],
          ),

          // QR
          GoRoute(
            path: RoutePaths.qr,
            name: 'qr',
            builder: (context, state) {
              return BlocProvider(
                create: (ctx) => getIt<QrCheckinCubit>(),
                child: const QrCheckInView(),
              );
            },
          ),

          // ═══════════════════════════════════════════════════════════════════════════════
          // CLASSES ROUTES
          // ═══════════════════════════════════════════════════════════════════════════════
          GoRoute(
            path: RoutePaths.classes,
            name: 'classes',
            // Main entry - ClassScheduleView (Weekly view)
            builder: (context, state) {
              return BlocProvider(
                create: (ctx) => getIt<ClassesCubit>()
                  ..loadThisWeekSchedule()
                  ..loadMyBookings(),
                child: const ClassScheduleView(),
              );
            },
            routes: [
              // Calendar View - Full month calendar
              GoRoute(
                path: 'calendar',
                name: 'classes-calendar',
                builder: (context, state) {
                  return BlocProvider(
                    create: (ctx) => getIt<ClassesCubit>()
                      ..loadInitial()
                      ..loadMyBookings(),
                    child: const ClassesCalendarView(),
                  );
                },
              ),

              // Class Detail View
              GoRoute(
                path: 'detail/:scheduleId',
                name: 'class-detail',
                builder: (context, state) {
                  final scheduleId = state.pathParameters['scheduleId']!;
                  return BlocProvider(
                    create: (ctx) => getIt<ClassesCubit>()
                      ..loadAndSelectSchedule(scheduleId)
                      ..loadMyBookings(),
                    child: ClassDetailView(scheduleId: scheduleId),
                  );
                },
              ),

              // My Bookings View
              GoRoute(
                path: 'bookings',
                name: 'my-bookings',
                builder: (context, state) {
                  return BlocProvider(
                    create: (ctx) => getIt<ClassesCubit>()..loadMyBookings(),
                    child: const MyBookingsView(),
                  );
                },
              ),
            ],
          ),

          // Rewards
          GoRoute(
            path: RoutePaths.rewards,
            name: 'rewards',
            builder: (context, state) {
              return BlocProvider(
                create: (ctx) => getIt<RewardsCubit>()..loadOverview(),
                child: const RewardsListView(),
              );
            },
            routes: [
              GoRoute(
                path: 'referrals',
                name: 'referrals',
                builder: (context, state) {
                  return BlocProvider(
                    create: (ctx) => getIt<RewardsCubit>()..loadReferrals(),
                    child: const ReferralsView(),
                  );
                },
              ),
              GoRoute(
                path: 'history',
                name: 'points-history',
                builder: (context, state) {
                  return BlocProvider(
                    create: (ctx) => getIt<RewardsCubit>()
                      ..loadPointsHistory()
                      ..loadEarningRules(),
                    child: const PointsHistoryView(),
                  );
                },
              ),
              GoRoute(
                path: 'vouchers',
                name: 'my-vouchers',
                builder: (context, state) {
                  return BlocProvider(
                    create: (ctx) => getIt<RewardsCubit>()..loadRedemptions(),
                    child: const MyVouchersView(),
                  );
                },
              ),
            ],
          ),

          // History
          GoRoute(
            path: RoutePaths.history,
            name: 'history',
            builder: (context, state) {
              return BlocProvider(
                create: (ctx) => getIt<QrCheckinCubit>(),
                child: const VisitHistoryView(),
              );
            },
          ),

          // Profile
          GoRoute(
            path: RoutePaths.profile,
            name: 'profile',
            redirect: (context, state) {
              if (state.uri.path == RoutePaths.profile) {
                return RoutePaths.profileView;
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'view',
                name: 'profile-view',
                builder: (context, state) => const ProfileView(),
              ),
              GoRoute(
                path: 'edit',
                name: 'profile-edit',
                builder: (context, state) => const EditProfileView(),
              ),
            ],
          ),

          // Settings
          GoRoute(
            path: RoutePaths.settings, // '/member/settings'
            name: 'settings',
            builder: (context, state) {
              return BlocProvider(
                create: (ctx) => getIt<SettingsCubit>(),
                child: const SettingsView(),
              );
            },
            routes: [
              GoRoute(
                path: 'language', // '/member/settings/language'
                name: 'language-settings',
                builder: (context, state) {
                  return BlocProvider(
                    create: (ctx) => getIt<SettingsCubit>(),
                    child: const LanguageSettingsView(),
                  );
                },
              ),
              GoRoute(
                path: 'notifications', // '/member/settings/notifications'
                name: 'notification-settings',
                builder: (context, state) {
                  return BlocProvider(
                    create: (ctx) => getIt<SettingsCubit>(),
                    child: const NotificationSettingsView(),
                  );
                },
              ),
            ],
          ),
          // Help & Support تحت settings
          GoRoute(
            path:
                '${RoutePaths.settings}/support', // '/member/settings/support'
            name: 'support-hub',
            builder: (context, state) {
              return BlocProvider(
                create: (ctx) => getIt<SupportCubit>(),
                child: const SupportHubView(),
              );
            },
            routes: [
              GoRoute(
                path: 'faq',
                name: 'support-faq',
                builder: (context, state) {
                  return BlocProvider(
                    create: (ctx) => getIt<SupportCubit>(),
                    child: const FaqView(),
                  );
                },
              ),
              GoRoute(
                path: 'tickets',
                name: 'support-tickets',
                builder: (context, state) {
                  return BlocProvider(
                    create: (ctx) => getIt<SupportCubit>(),
                    child: const TicketsView(),
                  );
                },
              ),
              GoRoute(
                path: 'about',
                name: 'support-about',
                builder: (context, state) {
                  return BlocProvider(
                    create: (ctx) => getIt<SupportCubit>(),
                    child: const AboutView(),
                  );
                },
              ),
            ],
          ),
        ],
      ),

      // ═══════════════════════════════════════════════════════════════════════════════
      // PARTNER SHELL ROUTE
      // ═══════════════════════════════════════════════════════════════════════════════
      ShellRoute(
        navigatorKey: _partnerShellKey,
        builder: (context, state, child) {
          return _PartnerShellScaffold(child: child);
        },
        routes: [
          // ─────────────────────────────────────────────────────────────────────────
          // Dashboard - يستخدم PartnerDashboardView الجديد
          // ─────────────────────────────────────────────────────────────────────────
          GoRoute(
            path: RoutePaths.partnerDashboard,
            name: 'partner-dashboard',
            builder: (context, state) {
              return BlocProvider(
                create: (ctx) => getIt<PartnerDashboardCubit>()..loadInitial(),
                child: const PartnerDashboardView(),
              );
            },
          ),

          // ─────────────────────────────────────────────────────────────────────────
          // QR Scanner - نفس القديم
          // ─────────────────────────────────────────────────────────────────────────
          GoRoute(
            path: RoutePaths.partnerScanner,
            name: 'partner-scanner',
            builder: (context, state) {
              final gymId = state.uri.queryParameters['gymId'] ?? 'gym_1';
              return BlocProvider(
                create: (ctx) => getIt<QrScannerCubit>(),
                child: QrScannerView(gymId: gymId),
              );
            },
          ),

          // ─────────────────────────────────────────────────────────────────────────
          // Reports - يستخدم PartnerReportsView الجديد
          // ─────────────────────────────────────────────────────────────────────────
          GoRoute(
            path: RoutePaths.partnerReports,
            name: 'partner-reports',
            builder: (context, state) {
              return BlocProvider(
                create: (ctx) => getIt<PartnerDashboardCubit>()..loadInitial(),
                child: const PartnerReportsView(), // 🆕 الـ View الجديد
              );
            },
          ),

          // ─────────────────────────────────────────────────────────────────────────
          // Settings - يستخدم PartnerSettingsCubit و PartnerSettingsView الجداد
          // ─────────────────────────────────────────────────────────────────────────
          GoRoute(
            path: RoutePaths.partnerSettings,
            name: 'partner-settings',
            builder: (context, state) {
              return BlocProvider(
                create: (ctx) =>
                    getIt<PartnerSettingsCubit>()
                      ..loadSettings(), // 🆕 الـ Cubit الجديد
                child: const PartnerSettingsView(), // 🆕 الـ View الجديد
              );
            },
          ),

          // ─────────────────────────────────────────────────────────────────────────
          // Blocked Users - صفحة المستخدمين المحظورين
          // ─────────────────────────────────────────────────────────────────────────
          GoRoute(
            path: RoutePaths.partnerBlockedUsers,
            name: 'partner-blocked-users',
            builder: (context, state) {
              return BlocProvider(
                create: (ctx) => getIt<BlockedUsersCubit>()..loadBlockedUsers(),
                child: const BlockedUsersView(),
              );
            },
          ),
        ],
      ),

      // Admin shell with navigation rail
      ShellRoute(
        navigatorKey: _adminShellKey,
        builder: (context, state, child) {
          return BlocProvider(
            create: (ctx) => getIt<AdminCubit>(),
            child: _AdminShellScaffold(child: child),
          );
        },
        routes: [
          GoRoute(
            path: RoutePaths.adminDashboard,
            name: 'admin-dashboard',
            builder: (context, state) => const AdminDashboardView(),
          ),
          GoRoute(
            path: RoutePaths.adminGyms,
            name: 'admin-gyms',
            redirect: (context, state) {
              if (state.matchedLocation == RoutePaths.adminGyms) {
                return RoutePaths.adminGymsList;
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'list',
                name: 'admin-gyms-list',
                builder: (context, state) => const AdminGymsTableView(),
              ),
              GoRoute(
                path: 'add',
                name: 'admin-add-gym',
                builder: (context, state) => const AdminGymFormView(),
              ),
              GoRoute(
                path: 'edit/:gymId',
                name: 'admin-edit-gym',
                builder: (context, state) {
                  final gymId = state.pathParameters['gymId']!;
                  return AdminGymFormView(gymId: gymId);
                },
              ),
            ],
          ),
          GoRoute(
            path: RoutePaths.adminSettings,
            name: 'admin-settings',
            builder: (context, state) => const AdminSettingsView(),
          ),
        ],
      ),
    ],
  );
  String _defaultRouteForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return RoutePaths.adminDashboard;
      case UserRole.partner:
        return RoutePaths.partnerDashboard;
      case UserRole.member:
        return RoutePaths.memberHome;
      case UserRole.guest:
        return RoutePaths.login;
    }
  }

  /// Handle global redirects
  ///
  /// Natural flow for new users: splash → onboarding → login → home
  /// Returning users (authenticated): splash → home (skip onboarding/login)
  Future<String?> _handleRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final location = state.uri.path;

    // Debug logging
    debugPrint('🔀 GoRouter redirect called: $location');

    // Check authentication state once
    await authGuard.checkAuthState();
    final isAuthenticated = authGuard.isAuthenticated;
    debugPrint('   - isAuthenticated: $isAuthenticated');

    // ═══════════════════════════════════════════════════════════════════════
    // 1. OTP routes - ALWAYS allow (prevent redirect loops)
    // ═══════════════════════════════════════════════════════════════════════
    if (location.contains('/otp')) {
      debugPrint('✅ OTP route - allowing');
      return null;
    }

    // ═══════════════════════════════════════════════════════════════════════
    // 2. Splash - ALWAYS show (let splash screen decide next destination)
    // ═══════════════════════════════════════════════════════════════════════
    if (location == RoutePaths.splash) {
      debugPrint('✅ Splash route - allowing');
      return null;
    }

    // ═══════════════════════════════════════════════════════════════════════
    // 3. Onboarding routes - allow unauthenticated, redirect authenticated to home
    // ═══════════════════════════════════════════════════════════════════════
    if (location.startsWith(RoutePaths.onboarding)) {
      if (isAuthenticated) {
        await roleGuard.refreshRole();
        final homeRoute = _defaultRouteForRole(roleGuard.currentRole);
        debugPrint(
          '🔄 Authenticated user on onboarding - redirecting to: $homeRoute',
        );
        return homeRoute;
      }
      debugPrint('✅ Onboarding route - allowing unauthenticated user');
      return null;
    }

    // ═══════════════════════════════════════════════════════════════════════
    // 4. Auth routes - allow unauthenticated, redirect authenticated to home
    // ═══════════════════════════════════════════════════════════════════════
    if (location.startsWith(RoutePaths.auth)) {
      if (isAuthenticated) {
        await roleGuard.refreshRole();
        final homeRoute = _defaultRouteForRole(roleGuard.currentRole);
        debugPrint(
          '🔄 Authenticated user on auth - redirecting to: $homeRoute',
        );
        return homeRoute;
      }
      debugPrint('✅ Auth route - allowing unauthenticated user');
      return null;
    }

    // ═══════════════════════════════════════════════════════════════════════
    // 5. Protected routes - require authentication
    // ═══════════════════════════════════════════════════════════════════════
    if (!isAuthenticated) {
      debugPrint('🔒 Protected route - redirecting to login');
      return RoutePaths.login;
    }

    // ═══════════════════════════════════════════════════════════════════════
    // 6. Role-based access for admin/partner areas
    // ═══════════════════════════════════════════════════════════════════════
    if (location.startsWith(RoutePaths.admin)) {
      final roleRedirect = await roleGuard.canActivate(context, location, [
        UserRole.admin,
      ]);
      if (roleRedirect != null) {
        debugPrint('🚫 Admin area - role redirect to: $roleRedirect');
        return roleRedirect;
      }
    } else if (location.startsWith(RoutePaths.partner)) {
      final roleRedirect = await roleGuard.canActivate(context, location, [
        UserRole.admin,
        UserRole.partner,
      ]);
      if (roleRedirect != null) {
        debugPrint('🚫 Partner area - role redirect to: $roleRedirect');
        return roleRedirect;
      }
    }

    // ═══════════════════════════════════════════════════════════════════════
    // 7. All checks passed - allow navigation
    // ═══════════════════════════════════════════════════════════════════════
    debugPrint('✅ All checks passed - allowing');
    return null;
  }
}

/// Placeholder page for development
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}

/// Member shell scaffold with bottom navigation
class _MemberShellScaffold extends StatefulWidget {
  const _MemberShellScaffold({required this.child});

  final Widget child;

  @override
  State<_MemberShellScaffold> createState() => _MemberShellScaffoldState();
}

class _MemberShellScaffoldState extends State<_MemberShellScaffold> {
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentIndex = _getIndexForLocation(
      GoRouterState.of(context).matchedLocation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.map), label: 'Gyms'),
          NavigationDestination(icon: Icon(Icons.qr_code), label: 'Check-in'),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Classes',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  int _getIndexForLocation(String location) {
    if (location.startsWith(RoutePaths.home)) {
      return 0;
    } else if (location.startsWith(RoutePaths.gyms)) {
      return 1;
    } else if (location.startsWith(RoutePaths.qr)) {
      return 2;
    } else if (location.startsWith(RoutePaths.classes)) {
      return 3;
    } else if (location.startsWith(RoutePaths.profile) ||
        location.startsWith(RoutePaths.settings) ||
        location.startsWith(RoutePaths.history) ||
        location.startsWith(RoutePaths.rewards)) {
      // Settings, History, and Rewards are accessed from Profile tab
      return 4;
    }
    return 0;
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        context.go(RoutePaths.home);
        break;
      case 1:
        context.go(RoutePaths.gymsMap);
        break;
      case 2:
        context.go(RoutePaths.qr);
        break;
      case 3:
        context.go(RoutePaths.classes);
        break;
      case 4:
        context.go(RoutePaths.profileView);
        break;
    }
  }
}

/// Partner shell scaffold with navigation rail
// ═══════════════════════════════════════════════════════════════════════════════
// PARTNER SHELL SCAFFOLD - ضعه في نهاية الملف
// ═══════════════════════════════════════════════════════════════════════════════

class _PartnerShellScaffold extends StatelessWidget {
  final Widget child;

  const _PartnerShellScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? luxury.surfaceElevated : colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: luxury.gold.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _PartnerNavItem(
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  isSelected: location == RoutePaths.partnerDashboard,
                  onTap: () => context.go(RoutePaths.partnerDashboard),
                ),
                _PartnerNavItem(
                  icon: Icons.qr_code_scanner_outlined,
                  activeIcon: Icons.qr_code_scanner_rounded,
                  label: 'Scanner',
                  isSelected:
                      location == RoutePaths.partnerScanner ||
                      location.startsWith(RoutePaths.partnerScanner),
                  onTap: () => context.go(RoutePaths.partnerScanner),
                ),
                _PartnerNavItem(
                  icon: Icons.analytics_outlined,
                  activeIcon: Icons.analytics_rounded,
                  label: 'Reports',
                  isSelected: location == RoutePaths.partnerReports,
                  onTap: () => context.go(RoutePaths.partnerReports),
                ),
                _PartnerNavItem(
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings_rounded,
                  label: 'Settings',
                  isSelected: location == RoutePaths.partnerSettings,
                  onTap: () => context.go(RoutePaths.partnerSettings),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// PARTNER NAV ITEM
// ═══════════════════════════════════════════════════════════════════════════════

class _PartnerNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PartnerNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16.w : 12.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    luxury.gold.withValues(alpha: 0.2),
                    luxury.gold.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
          borderRadius: BorderRadius.circular(14.r),
          border: isSelected
              ? Border.all(
                  color: luxury.gold.withValues(alpha: 0.3),
                  width: 1.5,
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                isSelected ? activeIcon : icon,
                key: ValueKey(isSelected),
                color: isSelected ? luxury.gold : colorScheme.onSurfaceVariant,
                size: isSelected ? 26.sp : 24.sp,
              ),
            ),
            SizedBox(height: 4.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: isSelected ? 11.sp : 10.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? luxury.gold : colorScheme.onSurfaceVariant,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════════
// ADMIN SHELL SCAFFOLD - Responsive Drawer (Web + Mobile)
// ═══════════════════════════════════════════════════════════════════════════════

class _AdminShellScaffold extends StatefulWidget {
  const _AdminShellScaffold({required this.child});

  final Widget child;

  @override
  State<_AdminShellScaffold> createState() => _AdminShellScaffoldState();
}

class _AdminShellScaffoldState extends State<_AdminShellScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth >= 1024;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      appBar: isWideScreen
          ? null
          : _buildAppBar(context, location, luxury, isDark, colorScheme),
      drawer: isWideScreen
          ? null
          : _buildDrawer(context, location, isDrawer: true),
      body: isWideScreen
          ? Row(
              children: [
                _buildPermanentDrawer(context, location, isTablet),
                Container(
                  width: 1,
                  color: luxury.borderLight.withValues(alpha: 0.5),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _buildWebTopBar(
                        context,
                        location,
                        luxury,
                        isDark,
                        colorScheme,
                      ),
                      Expanded(child: widget.child),
                    ],
                  ),
                ),
              ],
            )
          : widget.child,
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    String location,
    LuxuryThemeExtension luxury,
    bool isDark,
    ColorScheme colorScheme,
  ) {
    return AppBar(
      backgroundColor: isDark ? luxury.surfaceElevated : colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu_rounded, color: luxury.gold, size: 26.sp),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              gradient: luxury.goldGradient,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.admin_panel_settings_rounded,
              color: Colors.white,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            _getTitleForLocation(location),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Badge(
            smallSize: 8,
            backgroundColor: luxury.gold,
            child: Icon(
              Icons.notifications_outlined,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          onPressed: () {},
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildWebTopBar(
    BuildContext context,
    String location,
    LuxuryThemeExtension luxury,
    bool isDark,
    ColorScheme colorScheme,
  ) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: isDark ? luxury.surfaceElevated : colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: luxury.borderLight.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Page title
          Text(
            _getTitleForLocation(location),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          // Search (optional)
          if (location.contains('gyms'))
            Container(
              width: 280.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: luxury.borderLight.withValues(alpha: 0.5),
                ),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search gyms...',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: colorScheme.onSurfaceVariant,
                    size: 20.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                ),
                onChanged: (value) {
                  context.read<AdminCubit>().searchGyms(value);
                },
              ),
            ),
          SizedBox(width: 16.w),
          // Notifications
          IconButton(
            icon: Badge(
              label: const Text('3'),
              backgroundColor: luxury.gold,
              child: Icon(
                Icons.notifications_outlined,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            onPressed: () {},
          ),
          SizedBox(width: 8.w),
          // User menu
          PopupMenuButton<String>(
            offset: Offset(0, 45.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    gradient: luxury.goldGradient,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      'A',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin User',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'admin@mygym.com',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, size: 20.sp),
                    SizedBox(width: 12.w),
                    const Text('Profile'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, size: 20.sp),
                    SizedBox(width: 12.w),
                    const Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 20.sp,
                      color: AppColors.error,
                    ),
                    SizedBox(width: 12.w),
                    const Text(
                      'Logout',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                // Handle logout
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    String location, {
    required bool isDrawer,
  }) {
    return Drawer(
      backgroundColor: context.isDarkMode
          ? context.luxury.surfaceElevated
          : Theme.of(context).colorScheme.surface,
      child: _buildDrawerContent(context, location, isDrawer: isDrawer),
    );
  }

  Widget _buildPermanentDrawer(
    BuildContext context,
    String location,
    bool isCompact,
  ) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isCompact ? 80.w : 260.w,
      decoration: BoxDecoration(
        color: isDark
            ? luxury.surfaceElevated
            : Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: _buildDrawerContent(
        context,
        location,
        isDrawer: false,
        isCompact: isCompact,
      ),
    );
  }

  Widget _buildDrawerContent(
    BuildContext context,
    String location, {
    required bool isDrawer,
    bool isCompact = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Column(
      children: [
        // ═══════════════════════════════════════════════════════════════════
        // HEADER
        // ═══════════════════════════════════════════════════════════════════
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            isCompact ? 12.w : 20.w,
            50.h,
            isCompact ? 12.w : 20.w,
            20.h,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                luxury.gold.withValues(alpha: 0.15),
                luxury.gold.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: isCompact
              ? Center(
                  child: Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      gradient: luxury.goldGradient,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(
                      Icons.admin_panel_settings_rounded,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        gradient: luxury.goldGradient,
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [
                          BoxShadow(
                            color: luxury.gold.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.admin_panel_settings_rounded,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'MyGym Admin',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: luxury.gold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Management Console',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        ),

        // ═══════════════════════════════════════════════════════════════════
        // NAVIGATION ITEMS
        // ═══════════════════════════════════════════════════════════════════
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: isCompact ? 8.w : 12.w,
            ),
            children: [
              _AdminNavItem(
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard_rounded,
                label: 'Dashboard',
                isSelected: location == RoutePaths.adminDashboard,
                isCompact: isCompact,
                onTap: () {
                  if (isDrawer) Navigator.pop(context);
                  context.go(RoutePaths.adminDashboard);
                },
              ),
              SizedBox(height: 4.h),
              _AdminNavItem(
                icon: Icons.fitness_center_outlined,
                activeIcon: Icons.fitness_center_rounded,
                label: 'Gyms',
                isSelected: location.contains('/admin/gyms'),
                isCompact: isCompact,
                badge: '24',
                onTap: () {
                  if (isDrawer) Navigator.pop(context);
                  context.go(RoutePaths.adminGymsList);
                },
              ),
              SizedBox(height: 4.h),
              _AdminNavItem(
                icon: Icons.people_outline_rounded,
                activeIcon: Icons.people_rounded,
                label: 'Users',
                isSelected: location.contains('/admin/users'),
                isCompact: isCompact,
                onTap: () {
                  if (isDrawer) Navigator.pop(context);
                  // context.go(RoutePaths.adminUsers);
                },
              ),
              SizedBox(height: 4.h),
              _AdminNavItem(
                icon: Icons.card_membership_outlined,
                activeIcon: Icons.card_membership_rounded,
                label: 'Subscriptions',
                isSelected: location.contains('/admin/subscriptions'),
                isCompact: isCompact,
                onTap: () {
                  if (isDrawer) Navigator.pop(context);
                },
              ),
              SizedBox(height: 4.h),
              _AdminNavItem(
                icon: Icons.payments_outlined,
                activeIcon: Icons.payments_rounded,
                label: 'Revenue',
                isSelected: location.contains('/admin/revenue'),
                isCompact: isCompact,
                onTap: () {
                  if (isDrawer) Navigator.pop(context);
                },
              ),

              // Divider
              if (!isCompact) ...[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Divider(
                    color: luxury.borderLight.withValues(alpha: 0.3),
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
                  child: Text(
                    'SYSTEM',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.5,
                      ),
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ] else
                SizedBox(height: 16.h),

              _AdminNavItem(
                icon: Icons.analytics_outlined,
                activeIcon: Icons.analytics_rounded,
                label: 'Analytics',
                isSelected: location.contains('/admin/analytics'),
                isCompact: isCompact,
                onTap: () {
                  if (isDrawer) Navigator.pop(context);
                },
              ),
              SizedBox(height: 4.h),
              _AdminNavItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings_rounded,
                label: 'Settings',
                isSelected: location == RoutePaths.adminSettings,
                isCompact: isCompact,
                onTap: () {
                  if (isDrawer) Navigator.pop(context);
                  context.go(RoutePaths.adminSettings);
                },
              ),
            ],
          ),
        ),

        // ═══════════════════════════════════════════════════════════════════
        // FOOTER
        // ═══════════════════════════════════════════════════════════════════
        if (!isCompact)
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              border: Border(
                top: BorderSide(
                  color: luxury.borderLight.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    gradient: luxury.goldGradient,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      'A',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin User',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'admin@mygym.com',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.logout_rounded,
                    color: AppColors.error,
                    size: 20.sp,
                  ),
                  onPressed: () {
                    // Handle logout
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _getTitleForLocation(String location) {
    if (location.contains('dashboard')) return 'Dashboard';
    if (location.contains('gyms/add')) return 'Add New Gym';
    if (location.contains('gyms/edit')) return 'Edit Gym';
    if (location.contains('gyms')) return 'Gym Management';
    if (location.contains('users')) return 'User Management';
    if (location.contains('revenue')) return 'Revenue';
    if (location.contains('subscriptions')) return 'Subscriptions';
    if (location.contains('analytics')) return 'Analytics';
    if (location.contains('settings')) return 'Settings';
    return 'Admin Panel';
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ADMIN NAV ITEM WIDGET
// ═══════════════════════════════════════════════════════════════════════════════

class _AdminNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final bool isCompact;
  final String? badge;
  final VoidCallback onTap;

  const _AdminNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    this.isCompact = false,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    if (isCompact) {
      return Tooltip(
        message: label,
        preferBelow: false,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          luxury.gold.withValues(alpha: 0.2),
                          luxury.gold.withValues(alpha: 0.1),
                        ],
                      )
                    : null,
                borderRadius: BorderRadius.circular(12.r),
                border: isSelected
                    ? Border.all(
                        color: luxury.gold.withValues(alpha: 0.3),
                        width: 1.5,
                      )
                    : null,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    isSelected ? activeIcon : icon,
                    color: isSelected
                        ? luxury.gold
                        : colorScheme.onSurfaceVariant,
                    size: 24.sp,
                  ),
                  if (badge != null)
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: luxury.gold,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          badge!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      luxury.gold.withValues(alpha: 0.2),
                      luxury.gold.withValues(alpha: 0.08),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(12.r),
            border: isSelected
                ? Border.all(
                    color: luxury.gold.withValues(alpha: 0.3),
                    width: 1.5,
                  )
                : null,
          ),
          child: Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  key: ValueKey(isSelected),
                  color: isSelected
                      ? luxury.gold
                      : colorScheme.onSurfaceVariant,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? luxury.gold : colorScheme.onSurface,
                  ),
                ),
              ),
              if (badge != null) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? luxury.gold
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ] else if (isSelected) ...[
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: BoxDecoration(
                    color: luxury.gold,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: luxury.gold.withValues(alpha: 0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
