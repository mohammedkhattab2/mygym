// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:mygym/src/features/auth/presentation/views/login_view.dart';
import 'package:mygym/src/features/auth/presentation/views/otp_view.dart';
import 'package:mygym/src/features/home/presentation/views/home_view.dart';
import 'package:mygym/src/features/onboarding/presentation/presentation/views/onboarding_view.dart';
import 'package:mygym/src/features/profile/presentation/edit_profile_view.dart';
import 'package:mygym/src/features/profile/presentation/views/profile_view.dart';
import 'package:mygym/src/features/qr_checkin/presentation/bloc/qr_checkin_cubit.dart';
import 'package:mygym/src/features/qr_checkin/presentation/views/qr_check_in_view.dart';
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
          return _MemberShellScaffold(child: child);
        },
        routes: [
          // Home
          GoRoute(
            path: RoutePaths.memberHome,
            name: 'member-home',
            builder: (context, state) => const HomeView(),
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
                  return BlocProvider(
                    create: (ctx) => getIt<GymsBloc>()
                      // Presentation logic بس: بنبعت event للـ ViewModel
                      // مؤقتاً Location ثابتة (القاهرة) لحد ما نوصل geolocator
                      ..add(
                        const GymsEvent.updateLocation(
                          latitude: 30.0444,
                          longitude: 31.2357,
                        ),
                      ),
                    child: const GymsMapView(),
                  );
                },
              ),
              GoRoute(
                path: 'list',
                name: 'gyms-list',
                builder: (context, state) {
                  return BlocProvider(
                    create: (ctx) => getIt<GymsBloc>()
                      ..add(
                        const GymsEvent.updateLocation(
                          latitude: 30.0444, // Cairo lat
                          longitude: 31.2357, // Cairo lng
                        ),
                      ),
                    child: const GymsListView(),
                  );
                },
              ),
              GoRoute(
                path: ':gymId',
                name: 'gym-detail',
                builder: (context, state) {
                  final gymId = state.pathParameters['gymId']!;
                  return BlocProvider(
                    create: (ctx) => getIt<GymsBloc>()
                      ..add(GymsEvent.loadGymDetails(gymId))
                      ..add(GymsEvent.loadReviews(gymId)),
                    child: GymDetailsView(gymId: gymId),
                  );
                },
              ),
              GoRoute(
                path: 'filter',
                name: 'gym-filter',
                builder: (context, state) =>
                    const _PlaceholderPage(title: 'Gym Filter'),
              ),
            ],
          ),

          // Subscriptions
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
                builder: (context, state) =>
                    const _PlaceholderPage(title: 'Subscription Bundles'),
              ),
              GoRoute(
                path: 'checkout/:bundleId',
                name: 'checkout',
                builder: (context, state) {
                  final bundleId = state.pathParameters['bundleId']!;
                  return _PlaceholderPage(title: 'Checkout: $bundleId');
                },
              ),
              GoRoute(
                path: 'payment',
                name: 'payment',
                builder: (context, state) =>
                    const _PlaceholderPage(title: 'Payment'),
              ),
              GoRoute(
                path: 'invoices',
                name: 'invoices',
                builder: (context, state) =>
                    const _PlaceholderPage(title: 'Invoices'),
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

          // Classes
          GoRoute(
            path: RoutePaths.classes,
            name: 'classes',
            redirect: (context, state) {
              if (state.matchedLocation == RoutePaths.classes) {
                return RoutePaths.classesCalendar;
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'calendar',
                name: 'classes-calendar',
                builder: (context, state) =>
                    const _PlaceholderPage(title: 'Classes Calendar'),
              ),
              GoRoute(
                path: ':classId',
                name: 'class-detail',
                builder: (context, state) {
                  final classId = state.pathParameters['classId']!;
                  return _PlaceholderPage(title: 'Class Detail: $classId');
                },
              ),
              GoRoute(
                path: 'bookings',
                name: 'my-bookings',
                builder: (context, state) =>
                    const _PlaceholderPage(title: 'My Bookings'),
              ),
            ],
          ),

          // Rewards
          GoRoute(
            path: RoutePaths.rewards,
            name: 'rewards',
            redirect: (context, state) {
              if (state.uri.path == RoutePaths.rewards) {
                return RoutePaths.rewardsList;
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'list',
                name: 'rewards-list',
                builder: (context, state) =>
                    const _PlaceholderPage(title: 'Rewards'),
              ),
              GoRoute(
                path: 'referrals',
                name: 'referrals',
                builder: (context, state) =>
                    const _PlaceholderPage(title: 'Referrals'),
              ),
              GoRoute(
                path: 'history',
                name: 'points-history',
                builder: (context, state) =>
                    const _PlaceholderPage(title: 'Points History'),
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

      // Partner shell with navigation rail
      ShellRoute(
        navigatorKey: _partnerShellKey,
        builder: (context, state, child) {
          return _PartnerShellScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: RoutePaths.partnerDashboard,
            name: 'partner-dashboard',
            builder: (context, state) =>
                const _PlaceholderPage(title: 'Partner Dashboard'),
          ),
          GoRoute(
            path: RoutePaths.partnerScanner,
            name: 'partner-scanner',
            builder: (context, state) =>
                const _PlaceholderPage(title: 'QR Scanner'),
          ),
          GoRoute(
            path: RoutePaths.partnerReports,
            name: 'partner-reports',
            builder: (context, state) =>
                const _PlaceholderPage(title: 'Reports'),
          ),
          GoRoute(
            path: RoutePaths.partnerSettings,
            name: 'partner-settings',
            builder: (context, state) =>
                const _PlaceholderPage(title: 'Partner Settings'),
          ),
        ],
      ),

      // Admin shell with navigation rail
      ShellRoute(
        navigatorKey: _adminShellKey,
        builder: (context, state, child) {
          return _AdminShellScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: RoutePaths.adminDashboard,
            name: 'admin-dashboard',
            builder: (context, state) =>
                const _PlaceholderPage(title: 'Admin Dashboard'),
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
                builder: (context, state) =>
                    const _PlaceholderPage(title: 'Manage Gyms'),
              ),
              GoRoute(
                path: 'add',
                name: 'admin-add-gym',
                builder: (context, state) =>
                    const _PlaceholderPage(title: 'Add New Gym'),
              ),
              GoRoute(
                path: 'edit/:gymId',
                name: 'admin-edit-gym',
                builder: (context, state) {
                  final gymId = state.pathParameters['gymId']!;
                  return _PlaceholderPage(title: 'Edit Gym: $gymId');
                },
              ),
            ],
          ),
          GoRoute(
            path: RoutePaths.adminSettings,
            name: 'admin-settings',
            builder: (context, state) =>
                const _PlaceholderPage(title: 'Admin Settings'),
          ),
        ],
      ),
    ],
  );

  /// Handle global redirects
  Future<String?> _handleRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final location = state.matchedLocation;

    // Skip redirect for auth, onboarding routes
    if (location.startsWith(RoutePaths.auth) ||
        location.startsWith(RoutePaths.onboarding) ||
        location == RoutePaths.splash) {
      return null;
    }

    // Check authentication
    final authRedirect = await authGuard.canActivate(context, location);
    if (authRedirect != null) {
      return authRedirect;
    }

    // Check role-based access
    if (location.startsWith(RoutePaths.admin)) {
      final roleRedirect = await roleGuard.canActivate(context, location, [
        UserRole.admin,
      ]);
      if (roleRedirect != null) {
        return roleRedirect;
      }
    } else if (location.startsWith(RoutePaths.partner)) {
      final roleRedirect = await roleGuard.canActivate(context, location, [
        UserRole.admin,
        UserRole.partner,
      ]);
      if (roleRedirect != null) {
        return roleRedirect;
      }
    }

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
    } else if (location.startsWith(RoutePaths.profile)) {
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
        context.go(RoutePaths.classesCalendar);
        break;
      case 4:
        context.go(RoutePaths.profileView);
        break;
    }
  }
}

/// Partner shell scaffold with navigation rail
class _PartnerShellScaffold extends StatelessWidget {
  const _PartnerShellScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.qr_code_scanner),
                label: Text('Scanner'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.analytics),
                label: Text('Reports'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
            selectedIndex: 0,
            onDestinationSelected: (index) {
              // TODO: Implement navigation
            },
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// Admin shell scaffold with navigation rail
class _AdminShellScaffold extends StatelessWidget {
  const _AdminShellScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: true,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.fitness_center),
                label: Text('Gyms'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text('Users'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.payments),
                label: Text('Revenue'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
            selectedIndex: 0,
            onDestinationSelected: (index) {
              // TODO: Implement navigation
            },
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
