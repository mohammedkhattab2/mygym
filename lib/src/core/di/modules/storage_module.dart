import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/storage_keys.dart';

/// Storage module for dependency injection
@module
abstract class StorageModule {
  /// Provide SharedPreferences instance
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  /// Provide FlutterSecureStorage instance
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock,
        ),
      );

  /// Provide settings Hive box
  @preResolve
  @Named('settingsBox')
  Future<Box<dynamic>> get settingsBox => Hive.openBox(StorageKeys.settingsBox);

  /// Provide cache Hive box
  @preResolve
  @Named('cacheBox')
  Future<Box<dynamic>> get cacheBox => Hive.openBox(StorageKeys.cacheBox);

  /// Provide user Hive box (String type for JSON storage)
  @preResolve
  @Named('userBox')
  Future<Box<String>> get userBox => Hive.openBox<String>(StorageKeys.userBox);
}