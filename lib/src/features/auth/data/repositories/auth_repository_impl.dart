import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/firebase_auth_helper.dart';
import '../models/user_model.dart';

/// Implementation of [AuthRepository]
/// 
/// Coordinates between remote and local data sources,
/// handles caching, and maps errors to failures.
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final FirebaseAuthHelper _firebaseAuthHelper;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._firebaseAuthHelper,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, User>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _remoteDataSource.signInWithEmail({
        'email': email,
        'password': password,
      });

      await _localDataSource.saveAuthResponse(response);
      return Right(response.user.toEntity());
    } on UnauthorizedException {
      return Left(AuthFailure.invalidCredentials());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      // Get ID token from Firebase
      final idToken = await _firebaseAuthHelper.signInWithGoogle();
      if (idToken == null) {
        return const Left(AuthFailure('Google sign-in was cancelled'));
      }

      // Get Firebase user data directly (no backend available)
      final firebaseUser = _firebaseAuthHelper.currentUser;
      if (firebaseUser == null) {
        return const Left(AuthFailure('Failed to get user data'));
      }

      // Create UserModel from Firebase data
      final userModel = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: firebaseUser.displayName ?? 'User',
        phone: firebaseUser.phoneNumber,
        photoUrl: firebaseUser.photoURL,
        roleString: 'member',
        selectedCity: null,
        interests: [],
        createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
        subscriptionStatus: 'none',
        remainingVisits: 0,
        points: 0,
        referralCode: null,
      );

      // Save access token for AuthGuard (use Firebase ID token)
      await _localDataSource.saveAccessToken(idToken);
      
      // Cache user locally
      await _localDataSource.cacheUser(userModel);
      
      return Right(userModel.toEntity());

      // TODO: Uncomment when backend is available
      // final response = await _remoteDataSource.signInWithSocial(
      //   SocialLoginModel(
      //     idToken: idToken,
      //     provider: 'google',
      //   ),
      // );
      // await _localDataSource.saveAuthResponse(response);
      // return Right(response.user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithApple() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final idToken = await _firebaseAuthHelper.signInWithApple();
      if (idToken == null) {
        return const Left(AuthFailure('Apple sign-in was cancelled'));
      }

      final response = await _remoteDataSource.signInWithSocial(
        SocialLoginModel(
          idToken: idToken,
          provider: 'apple',
        ),
      );

      await _localDataSource.saveAuthResponse(response);
      return Right(response.user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> requestOtp({required String phone}) async {
    // DEV MODE: Bypass API call and return success immediately
    // This allows testing OTP flow without a backend
    return const Right(null);
    
    // TODO: Uncomment when backend is available
    // if (!await _networkInfo.isConnected) {
    //   return const Left(NetworkFailure());
    // }
    //
    // try {
    //   await _remoteDataSource.requestOtp(
    //     OtpRequestModel(phone: phone),
    //   );
    //   return const Right(null);
    // } on ServerException catch (e) {
    //   return Left(ServerFailure(e.message));
    // } catch (e) {
    //   return Left(UnexpectedFailure(e.toString()));
    // }
  }

  @override
  Future<Either<Failure, User>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    // DEV MODE: Accept any 6-digit OTP and return dummy user
    // This allows testing OTP flow without a backend
    if (otp.length == 6) {
      // Create a dummy user for development
      final dummyUser = UserModel(
        id: 'otp_user_${DateTime.now().millisecondsSinceEpoch}',
        email: '',
        name: 'User',
        phone: phone,
        photoUrl: null,
        roleString: 'member',
        selectedCity: null,
        interests: [],
        createdAt: DateTime.now(),
        subscriptionStatus: 'none',
        remainingVisits: 0,
        points: 0,
        referralCode: null,
      );
      
      // Cache user locally
      await _localDataSource.cacheUser(dummyUser);
      await _localDataSource.saveAccessToken('dummy_otp_token_${DateTime.now().millisecondsSinceEpoch}');
      
      return Right(dummyUser.toEntity());
    }
    
    return const Left(AuthFailure('Invalid OTP code'));
    
    // TODO: Uncomment when backend is available
    // if (!await _networkInfo.isConnected) {
    //   return const Left(NetworkFailure());
    // }
    //
    // try {
    //   final response = await _remoteDataSource.verifyOtp(
    //     OtpVerifyModel(phone: phone, otp: otp),
    //   );
    //
    //   await _localDataSource.saveAuthResponse(response);
    //   return Right(response.user.toEntity());
    // } on UnauthorizedException {
    //   return const Left(AuthFailure('Invalid OTP code'));
    // } on ServerException catch (e) {
    //   return Left(ServerFailure(e.message));
    // } catch (e) {
    //   return Left(UnexpectedFailure(e.toString()));
    // }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _remoteDataSource.register({
        'email': email,
        'password': password,
        'name': name,
      });

      await _localDataSource.saveAuthResponse(response);
      return Right(response.user.toEntity());
    } on ConflictException {
      return const Left(AuthFailure('Email already registered'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      // Sign out from Firebase
      await _firebaseAuthHelper.signOut();

      // Invalidate token on server (if online)
      if (await _networkInfo.isConnected) {
        try {
          await _remoteDataSource.signOut();
        } catch (_) {
          // Ignore server errors during logout
        }
      }

      // Clear local data
      await _localDataSource.clearAllAuthData();
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // Try to get cached user first
      final cachedUser = _localDataSource.getCachedUser();
      
      // Return cached user if available
      if (cachedUser != null) {
        return Right(cachedUser.toEntity());
      }
      
      // Return dummy user for development (no backend available)
      return Right(_getDummyUser());
      
      // TODO: Uncomment when backend is available
      // if (await _networkInfo.isConnected) {
      //   try {
      //     // Fetch fresh data from server
      //     final user = await _remoteDataSource.getCurrentUser();
      //     await _localDataSource.cacheUser(user);
      //     return Right(user.toEntity());
      //   } on UnauthorizedException {
      //     // Token expired, clear local data
      //     await _localDataSource.clearAllAuthData();
      //     return Left(AuthFailure.tokenExpired());
      //   } catch (e) {
      //     // Fall back to cached user if available
      //     if (cachedUser != null) {
      //       return Right(cachedUser.toEntity());
      //     }
      //     rethrow;
      //   }
      // } else if (cachedUser != null) {
      //   return Right(cachedUser.toEntity());
      // } else {
      //   return Left(NetworkFailure());
      // }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  /// Returns a dummy user for development when no backend is available
  User _getDummyUser() {
    return User(
      id: 'demo_user_123',
      email: 'demo@mygym.app',
      displayName: 'Demo User',
      name: 'Demo User',
      phoneNumber: '+20 123 456 7890',
      phone: '+20 123 456 7890',
      photoUrl: null,
      role: UserRole.member,
      isEmailVerified: true,
      isPhoneVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastLoginAt: DateTime.now(),
      city: 'Cairo',
      selectedCity: 'Cairo',
      interests: ['Fitness', 'Cardio', 'Strength Training'],
      subscriptionStatus: 'active',
      remainingVisits: 15,
      points: 250,
      referralCode: 'DEMO2024',
    );
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? phone,
    String? photoUrl,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (phone != null) body['phone'] = phone;
      if (photoUrl != null) body['photo_url'] = photoUrl;

      final user = await _remoteDataSource.updateProfile(body);
      await _localDataSource.cacheUser(user);
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updatePreferences({
    required String city,
    required List<String> interests,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final user = await _remoteDataSource.updatePreferences({
        'selected_city': city,
        'interests': interests,
      });

      await _localDataSource.cacheUser(user);
      await _localDataSource.setOnboardingComplete();
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> requestPasswordReset({
    required String email,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.requestPasswordReset({'email': email});
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> continueAsGuest() async {
    try {
      await _localDataSource.saveGuestSession();
      final cachedUser = _localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser.toEntity());
      }
      return const Left(UnexpectedFailure('Failed to create guest session'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    // Return true for development (no backend available)
    // This allows the app to load the dummy user
    return true;
    
    // TODO: Uncomment when backend is available
    // return _localDataSource.isLoggedIn();
  }

  @override
  Future<bool> isOnboardingComplete() async {
    return _localDataSource.isOnboardingComplete();
  }

  @override
  bool isGuestMode() {
    return _localDataSource.isGuestMode();
  }

  @override
  Future<String?> getAccessToken() async {
    return _localDataSource.getAccessToken();
  }

  @override
  Future<Either<Failure, void>> refreshToken() async {
    try {
      final refreshToken = await _localDataSource.getRefreshToken();
      if (refreshToken == null) {
        return const Left(AuthFailure('No refresh token available'));
      }

      final response = await _remoteDataSource.refreshToken({
        'refresh_token': refreshToken,
      });

      await _localDataSource.saveAuthResponse(response);
      return const Right(null);
    } on UnauthorizedException {
      await _localDataSource.clearAllAuthData();
      return Left(AuthFailure.tokenExpired());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.deleteAccount();
      await _localDataSource.clearAllAuthData();
      await _firebaseAuthHelper.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}