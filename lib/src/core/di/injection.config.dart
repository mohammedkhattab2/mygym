// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive_flutter/hive_flutter.dart' as _i986;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/admin/data/repositories/admin_repository_impl.dart'
    as _i335;
import '../../features/admin/domain/repositories/admin_repository.dart'
    as _i583;
import '../../features/admin/presentation/bloc/admin_dashboard_cubit.dart'
    as _i273;
import '../../features/auth/data/datasources/auth_local_data_source.dart'
    as _i852;
import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/presentation/bloc/auth_cubit.dart' as _i52;
import '../../features/gyms/data/repositories/gym_repository_impl.dart'
    as _i541;
import '../../features/gyms/domain/repositories/gym_repository.dart' as _i786;
import '../../features/gyms/presentation/bloc/gyms_bloc.dart' as _i587;
import '../../features/onboarding/presentation/bloc/onboarding_cubit.dart'
    as _i153;
import '../../features/qr_checkin/data/repositories/qr_repository_impl.dart'
    as _i971;
import '../../features/qr_checkin/domain/repositories/qr_repository.dart'
    as _i631;
import '../../features/qr_checkin/presentation/bloc/qr_checkin_cubit.dart'
    as _i846;
import '../../features/settings/data/datasources/settings_local_data_source.dart'
    as _i599;
import '../../features/settings/data/repositories/settings_repository_impl.dart'
    as _i955;
import '../../features/settings/domain/repositories/settings_repository.dart'
    as _i674;
import '../../features/settings/presentation/cubit/settings_cubit.dart'
    as _i792;
import '../../features/support/data/datasources/support_local_data_source.dart'
    as _i855;
import '../../features/support/data/repositories/support_repository_impl.dart'
    as _i387;
import '../../features/support/domain/repositories/support_repository.dart'
    as _i275;
import '../../features/support/presentation/cubit/support_cubit.dart' as _i196;
import '../network/dio_client.dart' as _i667;
import '../network/network_info.dart' as _i932;
import '../router/app_router.dart' as _i81;
import '../router/guards/auth_guard.dart' as _i530;
import '../router/guards/role_guard.dart' as _i746;
import '../router/guards/subscription_guard.dart' as _i204;
import '../storage/secure_storage.dart' as _i619;
import 'modules/network_module.dart' as _i851;
import 'modules/storage_module.dart' as _i148;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final storageModule = _$StorageModule();
    final networkModule = _$NetworkModule();
    final connectivityModule = _$ConnectivityModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => storageModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => storageModule.secureStorage);
    gh.lazySingleton<_i667.DioClient>(() => _i667.DioClient());
    gh.lazySingleton<_i895.Connectivity>(() => connectivityModule.connectivity);
    gh.lazySingleton<_i204.SubscriptionGuard>(() => _i204.SubscriptionGuard());
    gh.lazySingleton<_i107.FirebaseAuthHelper>(
        () => _i107.FirebaseAuthHelper());
    gh.lazySingleton<_i599.SettingsLocalDataSource>(
        () => _i599.SettingsLocalDataSource());
    gh.lazySingleton<_i855.SupportLocalDataSource>(
        () => _i855.SupportLocalDataSource());
    await gh.factoryAsync<_i986.Box<String>>(
      () => storageModule.userBox,
      instanceName: 'userBox',
      preResolve: true,
    );
    await gh.factoryAsync<_i986.Box<dynamic>>(
      () => storageModule.settingsBox,
      instanceName: 'settingsBox',
      preResolve: true,
    );
    await gh.factoryAsync<_i986.Box<dynamic>>(
      () => storageModule.cacheBox,
      instanceName: 'cacheBox',
      preResolve: true,
    );
    gh.lazySingleton<_i674.SettingsRepository>(() =>
        _i955.SettingsRepositoryImpl(gh<_i599.SettingsLocalDataSource>()));
    gh.lazySingleton<_i107.AuthRemoteDataSource>(
        () => _i107.AuthRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i275.SupportRepository>(
        () => _i387.SupportRepositoryImpl(gh<_i855.SupportLocalDataSource>()));
    gh.factory<_i792.SettingsCubit>(
        () => _i792.SettingsCubit(gh<_i674.SettingsRepository>()));
    gh.lazySingleton<_i619.SecureStorageService>(
        () => _i619.SecureStorageService(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingleton<_i530.AuthGuard>(
        () => _i530.AuthGuard(gh<_i619.SecureStorageService>()));
    gh.lazySingleton<_i746.RoleGuard>(
        () => _i746.RoleGuard(gh<_i619.SecureStorageService>()));
    gh.lazySingleton<_i932.NetworkInfo>(
        () => _i932.NetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i852.AuthLocalDataSource>(() => _i852.AuthLocalDataSource(
          gh<_i619.SecureStorageService>(),
          gh<_i986.Box<String>>(instanceName: 'userBox'),
        ));
    gh.lazySingleton<_i583.AdminRepository>(() => _i335.AdminRepositoryImpl(
          gh<_i667.DioClient>(),
          gh<_i932.NetworkInfo>(),
        ));
    gh.factory<_i196.SupportCubit>(
        () => _i196.SupportCubit(gh<_i275.SupportRepository>()));
    gh.lazySingleton<_i631.QrRepository>(() => _i971.QrRepositoryImpl(
          gh<_i667.DioClient>(),
          gh<_i932.NetworkInfo>(),
        ));
    gh.lazySingleton<_i786.GymRepository>(() => _i541.GymRepositoryImpl(
          gh<_i667.DioClient>(),
          gh<_i932.NetworkInfo>(),
        ));
    gh.factory<_i273.AdminDashboardCubit>(
        () => _i273.AdminDashboardCubit(gh<_i583.AdminRepository>()));
    gh.lazySingleton<_i81.AppRouter>(() => _i81.AppRouter(
          authGuard: gh<_i530.AuthGuard>(),
          roleGuard: gh<_i746.RoleGuard>(),
          subscriptionGuard: gh<_i204.SubscriptionGuard>(),
        ));
    gh.lazySingleton<_i787.AuthRepository>(() => _i153.AuthRepositoryImpl(
          gh<_i107.AuthRemoteDataSource>(),
          gh<_i852.AuthLocalDataSource>(),
          gh<_i107.FirebaseAuthHelper>(),
          gh<_i932.NetworkInfo>(),
        ));
    gh.factory<_i587.GymsBloc>(() => _i587.GymsBloc(gh<_i786.GymRepository>()));
    gh.factory<_i846.QrCheckinCubit>(
        () => _i846.QrCheckinCubit(gh<_i631.QrRepository>()));
    gh.factory<_i846.QrScannerCubit>(
        () => _i846.QrScannerCubit(gh<_i631.QrRepository>()));
    gh.factory<_i52.AuthCubit>(
        () => _i52.AuthCubit(gh<_i787.AuthRepository>()));
    gh.factory<_i153.OnboardingCubit>(
        () => _i153.OnboardingCubit(gh<_i787.AuthRepository>()));
    return this;
  }
}

class _$StorageModule extends _i148.StorageModule {}

class _$NetworkModule extends _i851.NetworkModule {}

class _$ConnectivityModule extends _i932.ConnectivityModule {}
