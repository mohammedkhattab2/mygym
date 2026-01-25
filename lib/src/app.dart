import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/settings/domain/repositories/settings_repository.dart';

/// Root application widget
///
/// Sets up:
/// - [ScreenUtilInit] for responsive design
/// - [BlocProvider]s for global state management (including ThemeCubit)
/// - [MaterialApp.router] with go_router
/// - Dynamic theme configuration via ThemeCubit (MVVM)
/// - Localization
class MyGymApp extends StatelessWidget {
  const MyGymApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get router instance from DI
    final appRouter = getIt<AppRouter>();
    final settingsRepository = getIt<SettingsRepository>();
    
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            // Theme Cubit - Global theme state management (MVVM)
            BlocProvider<ThemeCubit>(
              create: (_) => ThemeCubit(settingsRepository),
            ),
            BlocProvider<AuthCubit>(
              create: (_) => getIt<AuthCubit>()..checkAuthStatus(),
            ),
          ],
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              // Set system UI overlay style based on theme
              _setSystemUIOverlay(themeState.flutterThemeMode, context);
              
              return MaterialApp.router(
                title: 'MyGym',
                debugShowCheckedModeBanner: false,
                
                // Localization
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                
                // Theme - Connected to ThemeCubit for dynamic switching
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.flutterThemeMode,
                
                // Routing
                routerConfig: appRouter.router,
              );
            },
          ),
        );
      },
    );
  }

  /// Set system UI overlay style based on current theme
  void _setSystemUIOverlay(ThemeMode themeMode, BuildContext context) {
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    SystemChrome.setSystemUIOverlayStyle(
      isDark
          ? AppTheme.darkSystemUiOverlayStyle
          : AppTheme.lightSystemUiOverlayStyle,
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