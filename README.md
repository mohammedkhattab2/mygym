# MyGym - Flutter Gym Management Platform

A comprehensive Flutter application for gym membership management with MVVM + Clean Architecture, supporting mobile (iOS/Android) and web platforms.

## 🏗️ Architecture Overview

This project follows **Clean Architecture** principles with **MVVM** pattern and **feature-driven** folder structure:

```
lib/
├── main.dart                    # Entry point
└── src/
    ├── app.dart                 # Root app widget
    ├── core/                    # Core functionality
    │   ├── config/              # Environment & app configuration
    │   ├── constants/           # App-wide constants
    │   ├── di/                  # Dependency injection
    │   ├── error/               # Error handling
    │   ├── network/             # Network layer
    │   ├── router/              # Navigation setup
    │   ├── storage/             # Local storage
    │   ├── theme/               # App theming
    │   ├── utils/               # Utilities & extensions
    │   └── widgets/             # Shared widgets
    └── features/                # Feature modules
        ├── admin/               # Admin dashboard (Web)
        ├── auth/                # Authentication
        ├── classes/             # Class booking
        ├── gyms/                # Gym exploration
        ├── history/             # Visit history
        ├── onboarding/          # Onboarding flow
        ├── partner/             # Partner dashboard
        ├── profile/             # User profile
        ├── qr_checkin/          # QR check-in system
        ├── rewards/             # Points & referrals
        ├── settings/            # App settings
        └── subscriptions/       # Subscription management
```

## 🚀 Features

### A. Onboarding & Auth
- Splash screen with app intro slides
- Google/Apple/OTP login + Continue as Guest
- City & interests selection

### B. Gyms Exploration
- Interactive map with gym locations
- Filters (distance, hours, rating, amenities, availability)
- Gym detail pages with images, crowd estimates, facilities

### C. Subscriptions & Payments
- Multiple bundle tiers (Basic/Plus/Premium)
- Flexible duration (monthly/yearly/per-visit)
- WebView checkout (Kashier/Instapay/Paymob/PayTabs)
- Invoice management & auto-renew toggle

### D. QR Check-in
- Dynamic QR code (30-60s expiry)
- JWT-based security with server validation
- Staff scanner app/web interface
- Real-time feedback (Allowed/Rejected + Reason)

### E. Classes & Rewards
- Class booking calendar
- Points system for visits
- Referral program with codes

### F. History & Profile
- Visit log with statistics
- Remaining visits/points tracking
- Profile customization

### G. Partner Dashboard (Tablet/Web)
- QR scanner interface
- Monthly reports (visits, peak hours)
- Revenue share settings
- Gym management tools

### H. Admin Dashboard (Web)
- Gym management tables
- Add/Edit/Delete gyms
- Status management (pending/active/blocked)
- Overview statistics

## 📦 Tech Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter 3.x |
| State Management | flutter_bloc (Cubit/Bloc) |
| Routing | go_router |
| HTTP Client | dio + retrofit |
| Local Storage | hive_flutter |
| Secure Storage | flutter_secure_storage |
| DI | get_it + injectable |
| Models | freezed + json_serializable |
| Maps | google_maps_flutter + geolocator |
| QR | qr_flutter + qr_code_scanner |
| Payments | webview_flutter |
| Images | cached_network_image |
| Animations | lottie |
| Localization | easy_localization |
| Firebase | firebase_messaging, analytics, crashlytics |
| UI | flutter_screenutil, google_fonts, flutter_svg |

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK 3.16.0 or higher
- Dart SDK 3.2.0 or higher
- Android Studio / VS Code
- Xcode (for iOS development)
- Firebase project setup

### 1. Clone & Install Dependencies

```bash
# Clone the repository
git clone https://github.com/your-org/mygym.git
cd mygym

# Install dependencies
flutter pub get
```

### 2. Generate Code

Run build_runner to generate freezed, json_serializable, retrofit, and injectable code:

```bash
# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (during development)
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 3. Configure Environment

Create environment-specific configurations in [`lib/src/core/config/environment.dart`](lib/src/core/config/environment.dart):

```dart
// Update API base URLs for each environment
static const String _devBaseUrl = 'https://dev-api.mygym.com';
static const String _stagingBaseUrl = 'https://staging-api.mygym.com';
static const String _prodBaseUrl = 'https://api.mygym.com';
```

### 4. Firebase Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Add iOS & Android apps
3. Download and place config files:
   - `google-services.json` → `android/app/`
   - `GoogleService-Info.plist` → `ios/Runner/`
4. Enable Authentication providers (Google, Apple, Phone)

### 5. Google Maps Setup

1. Enable Maps SDK in [Google Cloud Console](https://console.cloud.google.com)
2. Add API keys:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_ANDROID_API_KEY"/>
```

**iOS** (`ios/Runner/AppDelegate.swift`):
```swift
GMSServices.provideAPIKey("YOUR_IOS_API_KEY")
```

### 6. Run the App

```bash
# Development
flutter run

# Production build
flutter build apk --release
flutter build ios --release
flutter build web --release
```

## 📁 Project Structure

### Core Layer
- **config/** - Environment variables and app configuration
- **constants/** - API endpoints, storage keys, asset paths
- **di/** - GetIt + Injectable setup
- **error/** - Custom exceptions and failure handling
- **network/** - Dio client, interceptors, network info
- **router/** - GoRouter configuration with guards
- **storage/** - Secure storage service
- **theme/** - Colors, text styles, app theme
- **utils/** - Logger, extensions, validation helpers
- **widgets/** - Reusable UI components

### Feature Layer (per feature)
```
feature_name/
├── data/
│   ├── datasources/     # Remote & local data sources
│   ├── models/          # Data models (freezed)
│   └── repositories/    # Repository implementations
├── domain/
│   ├── entities/        # Business entities
│   ├── repositories/    # Repository interfaces
│   └── usecases/        # Use cases
└── presentation/
    ├── bloc/            # Cubit/Bloc + states
    ├── views/           # Screen widgets
    └── widgets/         # Feature-specific widgets
```

## 🔐 QR Security Implementation

The QR check-in system uses JWT tokens for secure validation:

```dart
// QR Token Structure
{
  "userId": "user_123",
  "gymId": "gym_456",
  "timestamp": 1737203400000,
  "nonce": "random_uuid_v4",
  "exp": 1737203460  // 60 seconds expiry
}
```

**Server-side Validation:**
1. ✅ JWT signature verification
2. ✅ Token not expired (30-60 seconds)
3. ✅ Active subscription check
4. ✅ Daily/weekly visit cap check
5. ✅ One-time use (nonce tracking)
6. ✅ Optional geofence validation

## 🌍 Localization

The app supports English and Arabic with easy_localization:

```
assets/translations/
├── en.json      # English translations
└── ar.json      # Arabic translations
```

**Usage:**
```dart
Text('common.loading'.tr())
Text('auth.welcome_back'.tr())
```

## 🎨 Theming

The app uses a consistent design system:

- **Colors:** Defined in [`app_colors.dart`](lib/src/core/theme/app_colors.dart)
- **Typography:** Defined in [`app_text_styles.dart`](lib/src/core/theme/app_text_styles.dart)
- **Theme:** Configured in [`app_theme.dart`](lib/src/core/theme/app_theme.dart)

## 📱 Responsive Design

Uses flutter_screenutil for responsive UI across devices:

```dart
// Usage
Container(
  width: 100.w,    // Responsive width
  height: 50.h,    // Responsive height
  padding: EdgeInsets.all(16.w),
)

Text(
  'Hello',
  style: TextStyle(fontSize: 16.sp),  // Responsive font
)
```

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test

# Generate coverage report
flutter test --coverage
```

## 📄 Documentation

- [Architecture Report](docs/architectureReport.md) - Detailed architecture documentation
- [Progress Report](docs/progressReport.md) - Development progress tracking
- [Project Skeleton](docs/projectSkeleton.md) - Complete project structure

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is proprietary software. All rights reserved.

## 📞 Support

For support, email support@mygym.com or join our Slack channel.

---

Built with ❤️ using Flutter
