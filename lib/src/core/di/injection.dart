import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// Global service locator instance
final getIt = GetIt.instance;

/// Environment constants for dependency injection
abstract class Env {
  static const dev = 'dev';
  static const prod = 'prod';
}

/// Configure dependencies using injectable
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies({String environment = Env.dev}) async =>
    getIt.init(environment: environment);