import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';

/// Root application widget
///
/// Sets up:
/// - [ScreenUtilInit] for responsive design
/// - [BlocProvider]s for global state management
/// - [MaterialApp.router] with go_router
/// - Theme configuration
/// - Localization
class MyGymApp extends StatelessWidget {
  const MyGymApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get router instance from DI
    final appRouter = getIt<AppRouter>();
    
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>(
              create: (_) => getIt<AuthCubit>()..checkAuthStatus(),
            ),
          ],
          child: Builder(
            builder: (context) {
              return MaterialApp.router(
                title: 'MyGym',
                debugShowCheckedModeBanner: false,
                
                // Localization
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                
                // Theme
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: ThemeMode.system,
                
                // Routing
                routerConfig: appRouter.router,
              );
            },
          ),
        );
      },
    );
  }
}

/// Widget that wraps the app with EasyLocalization
/// 
/// Call this in main.dart instead of MyGymApp directly
/// to enable localization support
class MyGymAppWithLocalization extends StatelessWidget {
  const MyGymAppWithLocalization({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyGymApp(),
    );
  }
}