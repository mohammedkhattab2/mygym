# MyGym Flutter Project - Implementation Guide

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [What Was Created](#what-was-created)
3. [Project Architecture](#project-architecture)
4. [Folder Structure](#folder-structure)
5. [Files Created](#files-created)
6. [Dependencies Used](#dependencies-used)
7. [How to Run the Project](#how-to-run-the-project)
8. [What You Need to Do](#what-you-need-to-do)
9. [Feature Implementation Status](#feature-implementation-status)
10. [Code Patterns Used](#code-patterns-used)
11. [Troubleshooting](#troubleshooting)

---

## 🎯 Project Overview

**MyGym** is a comprehensive gym management platform built with Flutter supporting:
- **Mobile** (iOS & Android)
- **Web** (Admin Dashboard, Partner Portal)

### Key Features Planned:
- Onboarding & Authentication (Google/Apple/OTP/Guest)
- Gym Exploration with Maps & Filters
- Subscription Management & Payments
- QR Code Check-in System
- Class Booking & Calendar
- Rewards & Referral System
- Partner Dashboard (Tablet/Web)
- Admin Dashboard (Web)

---

## ✅ What Was Created

### Phase 1: Architecture & Planning
- Comprehensive architecture design using **MVVM + Clean Architecture**
- Feature-driven folder structure
- Documentation files ([`architectureReport.md`](./architectureReport.md), [`progressReport.md`](./progressReport.md))

### Phase 2: Core Infrastructure
- **Dependency Injection** setup with `get_it` + `injectable`
- **Network Layer** with Dio client and interceptors
- **Router Configuration** with `go_router` and guards
- **Theme System** with light/dark mode support
- **Error Handling** with custom Failures and Exceptions
- **Localization** setup with English and Arabic

### Phase 3: Feature Modules (Skeleton)
Created skeleton files for all features including:
- Domain entities
- Repository interfaces
- Repository implementations
- Bloc/Cubit state management
- Views and widgets

### Phase 4: Bug Fixes & DI Resolution
- Removed `retrofit` (generator bugs with Dart 3.10)
- Fixed all compilation errors
- Resolved all DI warnings
- Successfully ran `build_runner` with 672+ outputs

---

## 🏗️ Project Architecture

### Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Views     │  │   Widgets   │  │  Bloc/Cubit (State) │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│                      DOMAIN LAYER                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Entities   │  │  Use Cases  │  │  Repository Interface│  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│                       DATA LAYER                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Models    │  │ Data Sources│  │  Repository Impl    │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### State Management Pattern

Using `flutter_bloc` with:
- **Cubit** for simple state (loading, error, success)
- **Bloc** for complex features (events, states with freezed)
- **Either<Failure, T>** pattern from `dartz` for error handling

---

## 📁 Folder Structure

```
lib/
├── main.dart                          # App entry point
└── src/
    ├── app.dart                       # App widget with MaterialApp.router
    ├── core/                          # Shared core functionality
    │   ├── config/                    # Environment & app configuration
    │   │   ├── app_config.dart
    │   │   └── environment.dart
    │   ├── constants/                 # App-wide constants
    │   │   ├── api_endpoints.dart
    │   │   ├── app_constants.dart
    │   │   ├── asset_paths.dart
    │   │   └── storage_keys.dart
    │   ├── di/                        # Dependency injection
    │   │   ├── injection.dart         # Main DI setup
    │   │   ├── injection.config.dart  # Generated
    │   │   └── modules/
    │   │       ├── network_module.dart
    │   │       └── storage_module.dart
    │   ├── error/                     # Error handling
    │   │   ├── exceptions.dart
    │   │   ├── failures.dart
    │   │   └── error_handler.dart
    │   ├── network/                   # Network layer
    │   │   ├── dio_client.dart
    │   │   ├── network_info.dart
    │   │   └── interceptors/
    │   │       ├── auth_interceptor.dart
    │   │       └── error_interceptor.dart
    │   ├── router/                    # Routing
    │   │   ├── app_router.dart
    │   │   ├── route_names.dart
    │   │   └── guards/
    │   │       ├── auth_guard.dart
    │   │       ├── role_guard.dart
    │   │       └── subscription_guard.dart
    │   ├── storage/                   # Local storage
    │   │   └── secure_storage.dart
    │   ├── theme/                     # App theming
    │   │   ├── app_colors.dart
    │   │   └── app_theme.dart
    │   ├── utils/                     # Utilities
    │   │   ├── logger.dart
    │   │   ├── extensions/
    │   │   │   ├── context_extensions.dart
    │   │   │   ├── date_extensions.dart
    │   │   │   ├── num_extensions.dart
    │   │   │   └── string_extensions.dart
    │   │   └── helpers/
    │   │       └── validation_helper.dart
    │   └── widgets/                   # Shared widgets
    │       ├── app_button.dart
    │       ├── app_text_field.dart
    │       └── loading_overlay.dart
    └── features/                      # Feature modules
        ├── auth/
        │   ├── data/
        │   │   ├── datasources/
        │   │   │   ├── auth_local_data_source.dart
        │   │   │   └── auth_remote_data_source.dart
        │   │   ├── models/
        │   │   │   └── user_model.dart
        │   │   └── repositories/
        │   │       └── auth_repository_impl.dart
        │   ├── domain/
        │   │   ├── entities/
        │   │   │   └── user.dart
        │   │   ├── repositories/
        │   │   │   └── auth_repository.dart
        │   │   └── usecases/
        │   │       ├── login_usecase.dart
        │   │       └── ...
        │   └── presentation/
        │       ├── bloc/
        │       │   ├── auth_cubit.dart
        │       │   └── auth_state.dart
        │       ├── views/
        │       │   └── login_view.dart
        │       └── widgets/
        │           └── ...
        ├── gyms/                       # Similar structure
        ├── subscriptions/
        ├── qr_checkin/
        ├── classes/
        ├── rewards/
        ├── history/
        ├── profile/
        ├── settings/
        ├── partner/
        ├── admin/
        └── onboarding/
```

---

## 📄 Files Created

### Core Files (30+)

| File | Purpose |
|------|---------|
| [`lib/main.dart`](../lib/main.dart) | App entry point with initialization |
| [`lib/src/app.dart`](../lib/src/app.dart) | MaterialApp.router setup |
| [`lib/src/core/di/injection.dart`](../lib/src/core/di/injection.dart) | Injectable DI configuration |
| [`lib/src/core/network/dio_client.dart`](../lib/src/core/network/dio_client.dart) | HTTP client setup |
| [`lib/src/core/router/app_router.dart`](../lib/src/core/router/app_router.dart) | go_router configuration |
| [`lib/src/core/error/failures.dart`](../lib/src/core/error/failures.dart) | Failure classes for Either pattern |
| [`lib/src/core/theme/app_theme.dart`](../lib/src/core/theme/app_theme.dart) | Light/Dark theme |

### Feature Files (40+)

| Feature | Files Created |
|---------|---------------|
| **Auth** | User entity, UserModel, AuthRepository, AuthRepositoryImpl, AuthCubit, LoginView |
| **Gyms** | Gym entity, GymRepository, GymRepositoryImpl, GymsBloc, GymFilter |
| **QR Check-in** | QrToken, CheckInResult, QrRepository, QrRepositoryImpl, QrCheckinCubit |
| **Admin** | AdminGym entity, AdminRepository, AdminRepositoryImpl, AdminDashboardCubit, AdminDashboardView |
| **Onboarding** | OnboardingPage entity, OnboardingCubit, OnboardingView |

### Configuration Files

| File | Purpose |
|------|---------|
| [`pubspec.yaml`](../pubspec.yaml) | Dependencies (35+ packages) |
| [`assets/translations/en.json`](../assets/translations/en.json) | English translations |
| [`assets/translations/ar.json`](../assets/translations/ar.json) | Arabic translations |

---

## 📦 Dependencies Used

### State Management & DI
```yaml
flutter_bloc: ^8.1.3        # BLoC pattern
get_it: ^7.6.4              # Service locator
injectable: ^2.3.2          # Code generation for DI
```

### Networking
```yaml
dio: ^5.3.3                 # HTTP client
connectivity_plus: ^5.0.1   # Network status
```

### Local Storage
```yaml
hive: ^2.2.3                # NoSQL database
hive_flutter: ^1.1.0        # Hive for Flutter
flutter_secure_storage: ^9.0.0  # Encrypted storage
shared_preferences: ^2.2.2  # Key-value storage
```

### Code Generation
```yaml
freezed: ^2.4.5             # Immutable classes
json_serializable: ^6.7.1   # JSON serialization
injectable_generator: ^2.4.1  # DI generation
```

### UI & UX
```yaml
flutter_screenutil: ^5.9.0  # Responsive UI
google_fonts: ^6.1.0        # Typography
lottie: ^2.6.0              # Animations
cached_network_image: ^3.3.0  # Image caching
skeleton_loader: ^2.0.0     # Loading states
```

### Maps & Location
```yaml
google_maps_flutter: ^2.5.0  # Google Maps
geolocator: ^10.1.0         # GPS location
geocoding: ^2.1.1           # Address lookup
```

### Firebase
```yaml
firebase_core: ^2.24.0      # Firebase setup
firebase_messaging: ^14.7.6  # Push notifications
firebase_analytics: ^10.7.3  # Analytics
firebase_crashlytics: ^3.4.6  # Crash reporting
```

---

## 🚀 How to Run the Project

### Prerequisites
1. Flutter SDK 3.10+ installed
2. Dart SDK 3.0+
3. Android Studio / VS Code with Flutter extensions
4. Firebase project configured (for notifications/analytics)

### Step 1: Install Dependencies
```powershell
flutter pub get
```

### Step 2: Run Code Generation
```powershell
dart run build_runner build --delete-conflicting-outputs
```

### Step 3: Configure Environment
Edit [`lib/src/core/config/environment.dart`](../lib/src/core/config/environment.dart):
```dart
static const String apiBaseUrl = 'YOUR_API_URL';
static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_KEY';
```

### Step 4: Configure Firebase
1. Create Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add Android app and download `google-services.json` to `android/app/`
3. Add iOS app and download `GoogleService-Info.plist` to `ios/Runner/`
4. Enable Authentication methods (Google, Apple, Phone)
5. Enable Cloud Messaging

### Step 5: Run the App
```powershell
# For development
flutter run

# For web
flutter run -d chrome

# For specific device
flutter run -d <device_id>
```

---

## 📝 What You Need to Do

### 1. Backend API Integration

The skeleton includes API endpoint constants in [`api_endpoints.dart`](../lib/src/core/constants/api_endpoints.dart). You need to:

1. **Create Backend Server** with these endpoints:
   - `/auth/*` - Authentication endpoints
   - `/gyms/*` - Gym CRUD operations
   - `/subscriptions/*` - Subscription management
   - `/qr/*` - QR token generation/validation
   - `/admin/*` - Admin dashboard APIs
   - `/partner/*` - Partner portal APIs

2. **Update Base URL** in [`environment.dart`](../lib/src/core/config/environment.dart)

### 2. Complete UI Implementation

The views are skeletons. You need to:

| Feature | What to Add |
|---------|------------|
| **Login View** | Add Google/Apple sign-in buttons, OTP input |
| **Gyms View** | Add Google Map widget, filter bottom sheet |
| **QR View** | Integrate `qr_flutter` for QR generation |
| **Admin Dashboard** | Complete data tables with `data_table_2` |
| **Partner Dashboard** | Add charts with `syncfusion_flutter_charts` |

### 3. Add Missing Widgets

Create these reusable widgets in [`lib/src/core/widgets/`](../lib/src/core/widgets/):
- `AppBottomSheet` - Modal bottom sheets
- `AppDialog` - Alert dialogs
- `AppSnackbar` - Toast notifications
- `AppCard` - Styled cards
- `AppAvatar` - User avatars
- `GymCard` - Gym list items
- `SubscriptionCard` - Plan cards

### 4. Implement Use Cases

Use cases are defined but need implementation:
```dart
// Example: lib/src/features/auth/domain/usecases/login_usecase.dart
@injectable
class LoginUseCase {
  final AuthRepository _repository;
  
  LoginUseCase(this._repository);
  
  Future<Either<Failure, User>> call(String email, String password) {
    return _repository.signInWithEmail(email: email, password: password);
  }
}
```

### 5. Add Platform-Specific Code

| Platform | Configuration Needed |
|----------|---------------------|
| **Android** | Google Maps API key in `AndroidManifest.xml` |
| **iOS** | Location permissions in `Info.plist`, Google Maps key |
| **Web** | Google Maps script in `index.html` |

### 6. Payment Integration

WebView payment flow:
1. Backend generates payment URL (Kashier/Paymob/PayTabs)
2. Open URL in `webview_flutter`
3. Listen for callback URL to confirm payment

### 7. Testing

Add tests in `test/` directory:
```dart
// test/features/auth/auth_cubit_test.dart
void main() {
  group('AuthCubit', () {
    test('emits authenticated state on successful login', () async {
      // Test implementation
    });
  });
}
```

---

## 📊 Feature Implementation Status

| Feature | Domain | Data | Presentation | Status |
|---------|--------|------|--------------|--------|
| **Auth** | ✅ | ✅ | 🟡 Skeleton | 70% |
| **Onboarding** | ✅ | N/A | 🟡 Skeleton | 60% |
| **Gyms** | ✅ | ✅ | 🟡 Skeleton | 70% |
| **Subscriptions** | ✅ | 🟡 | 🔴 Minimal | 40% |
| **QR Check-in** | ✅ | ✅ | 🟡 Skeleton | 60% |
| **Classes** | ✅ | 🔴 | 🔴 Minimal | 30% |
| **Rewards** | ✅ | 🔴 | 🔴 Minimal | 30% |
| **History** | ✅ | 🔴 | 🔴 Minimal | 30% |
| **Profile** | ✅ | 🔴 | 🔴 Minimal | 30% |
| **Settings** | ✅ | 🔴 | 🔴 Minimal | 30% |
| **Partner** | ✅ | 🔴 | 🔴 Minimal | 30% |
| **Admin** | ✅ | ✅ | 🟡 Skeleton | 60% |

Legend:
- ✅ Complete
- 🟡 Partial/Skeleton
- 🔴 Minimal/TODO

---

## 🔧 Code Patterns Used

### 1. Either Pattern for Error Handling
```dart
// Repository returns Either<Failure, Success>
Future<Either<Failure, User>> signIn(String email, String password);

// Cubit handles with fold()
final result = await _authRepository.signIn(email, password);
result.fold(
  (failure) => emit(AuthState.error(failure.message)),
  (user) => emit(AuthState.authenticated(user)),
);
```

### 2. Injectable Annotations
```dart
@injectable          // Regular dependency
@lazySingleton       // Single instance, created on first use
@LazySingleton(as: Repository)  // Bind implementation to interface
@module              // Group related providers
@Named('name')       // Named instances
```

### 3. Freezed for Immutable State
```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.error(String message) = _Error;
}
```

### 4. Router Guards
```dart
// Redirect unauthenticated users
redirect: (context, state) {
  final isAuthenticated = authCubit.state is Authenticated;
  if (!isAuthenticated) return '/login';
  return null;
}
```

---

## 🐛 Troubleshooting

### Build Runner Fails
```powershell
# Clean and rebuild
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### DI Not Resolving
1. Ensure class has `@injectable` or `@lazySingleton` annotation
2. Run `build_runner` after adding new injectables
3. Check [`injection.config.dart`](../lib/src/core/di/injection.config.dart) for registration

### Hive Box Not Opening
Initialize Hive before running app:
```dart
// In main.dart
await Hive.initFlutter();
```

### Google Maps Not Showing
1. Verify API key is correct
2. Enable Maps SDK for Android/iOS in Google Cloud Console
3. Add billing to Google Cloud project

---

## 📞 Support

For questions about this implementation:
1. Review [`architectureReport.md`](./architectureReport.md) for architecture details
2. Check [`progressReport.md`](./progressReport.md) for development status
3. Search existing code for patterns and examples

---

*Document created: January 18, 2026*
*Last updated: January 18, 2026*