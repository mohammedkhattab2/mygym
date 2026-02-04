import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/app.dart';
import 'src/core/config/app_config.dart';
import 'src/core/config/environment.dart';
import 'src/core/di/injection.dart';

/// Application entry point
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase first (required for FirebaseAuth)
  await Firebase.initializeApp();

  /// - Environment.production
  AppConfig.initialize(Environment.development);

  await EasyLocalization.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await Hive.initFlutter();

  await configureDependencies(environment: Env.dev);

  runApp(const MyGymAppWithLocalization());
}