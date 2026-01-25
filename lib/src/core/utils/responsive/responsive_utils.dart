import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ============================================
/// RESPONSIVE UTILITIES
/// ============================================
/// 
/// Provides comprehensive responsive design utilities for the MyGym app.
/// All UI elements should use these utilities for consistent responsiveness.

/// Device type enumeration for adaptive layouts
enum DeviceType { mobile, tablet, desktop }

/// Screen size breakpoints
class Breakpoints {
  Breakpoints._();
  
  static const double mobileMax = 600;
  static const double tabletMax = 1024;
  static const double desktopMin = 1025;
}

/// Responsive helper class for screen-aware sizing
class ResponsiveUtils {
  ResponsiveUtils._();
  
  /// Get current device type based on screen width
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < Breakpoints.mobileMax) {
      return DeviceType.mobile;
    } else if (width < Breakpoints.tabletMax) {
      return DeviceType.tablet;
    }
    return DeviceType.desktop;
  }
  
  /// Check if device is mobile
  static bool isMobile(BuildContext context) => 
      getDeviceType(context) == DeviceType.mobile;
  
  /// Check if device is tablet
  static bool isTablet(BuildContext context) => 
      getDeviceType(context) == DeviceType.tablet;
  
  /// Check if device is desktop
  static bool isDesktop(BuildContext context) => 
      getDeviceType(context) == DeviceType.desktop;
  
  /// Check if device is in landscape orientation
  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;
  
  /// Check if device is in portrait orientation
  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;
  
  /// Get screen width
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  
  /// Get screen height
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  
  /// Get safe area padding
  static EdgeInsets safePadding(BuildContext context) =>
      MediaQuery.of(context).padding;
  
  /// Get aspect ratio
  static double aspectRatio(BuildContext context) =>
      MediaQuery.of(context).size.aspectRatio;
}

/// ============================================
/// RESPONSIVE SPACING
/// ============================================

/// Responsive spacing values that scale with screen size
class ResponsiveSpacing {
  ResponsiveSpacing._();
  
  // Base spacing values (scaled using flutter_screenutil)
  static double get xxs => 2.w;
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 16.w;
  static double get lg => 24.w;
  static double get xl => 32.w;
  static double get xxl => 48.w;
  static double get xxxl => 64.w;
  
  // Vertical spacing (height-based scaling)
  static double get xxsV => 2.h;
  static double get xsV => 4.h;
  static double get smV => 8.h;
  static double get mdV => 16.h;
  static double get lgV => 24.h;
  static double get xlV => 32.h;
  static double get xxlV => 48.h;
  static double get xxxlV => 64.h;
  
  /// Get spacing based on screen size multiplier
  static double scaled(double baseValue) => baseValue.w;
  
  /// Get vertical spacing based on screen size multiplier
  static double scaledV(double baseValue) => baseValue.h;
}

/// ============================================
/// RESPONSIVE PADDING
/// ============================================

/// Responsive padding presets
class ResponsivePadding {
  ResponsivePadding._();
  
  /// Screen horizontal padding (adapts to device size)
  static EdgeInsets screenHorizontal(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return EdgeInsets.symmetric(horizontal: 16.w);
      case DeviceType.tablet:
        return EdgeInsets.symmetric(horizontal: 32.w);
      case DeviceType.desktop:
        return EdgeInsets.symmetric(horizontal: 64.w);
    }
  }
  
  /// Card padding
  static EdgeInsets get card => EdgeInsets.all(16.w);
  static EdgeInsets get cardSmall => EdgeInsets.all(12.w);
  static EdgeInsets get cardLarge => EdgeInsets.all(20.w);
  
  /// Button padding
  static EdgeInsets get button => EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h);
  static EdgeInsets get buttonSmall => EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);
  static EdgeInsets get buttonLarge => EdgeInsets.symmetric(horizontal: 32.w, vertical: 20.h);
  
  /// Input padding
  static EdgeInsets get input => EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h);
  
  /// List item padding
  static EdgeInsets get listItem => EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);
  
  /// Section padding
  static EdgeInsets get section => EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h);
}

/// ============================================
/// RESPONSIVE SIZES
/// ============================================

/// Responsive size values for common UI elements
class ResponsiveSizes {
  ResponsiveSizes._();
  
  // Button heights
  static double get buttonHeight => 56.h;
  static double get buttonHeightSmall => 44.h;
  static double get buttonHeightLarge => 64.h;
  
  // Input heights
  static double get inputHeight => 56.h;
  static double get inputHeightSmall => 48.h;
  
  // Icon sizes
  static double get iconXs => 16.sp;
  static double get iconSm => 20.sp;
  static double get iconMd => 24.sp;
  static double get iconLg => 32.sp;
  static double get iconXl => 48.sp;
  static double get iconXxl => 64.sp;
  
  // Avatar sizes
  static double get avatarSmall => 32.w;
  static double get avatarMedium => 48.w;
  static double get avatarLarge => 64.w;
  static double get avatarXLarge => 96.w;
  
  // Card image heights
  static double get cardImageSmall => 120.h;
  static double get cardImageMedium => 160.h;
  static double get cardImageLarge => 200.h;
  
  // Navigation bar
  static double get bottomNavHeight => 80.h;
  static double get appBarHeight => 56.h;
  
  // Border radius
  static double get radiusXs => 4.r;
  static double get radiusSm => 8.r;
  static double get radiusMd => 12.r;
  static double get radiusLg => 16.r;
  static double get radiusXl => 24.r;
  static double get radiusXxl => 32.r;
  static double get radiusRound => 100.r;
  
  /// Get adaptive size based on device type
  static double adaptive(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile * 1.2;
      case DeviceType.desktop:
        return desktop ?? mobile * 1.5;
    }
  }
}

/// ============================================
/// RESPONSIVE FONT SIZES
/// ============================================

/// Responsive typography sizes
class ResponsiveFontSizes {
  ResponsiveFontSizes._();
  
  // Display styles
  static double get displayLarge => 57.sp;
  static double get displayMedium => 45.sp;
  static double get displaySmall => 36.sp;
  
  // Headline styles
  static double get headlineLarge => 32.sp;
  static double get headlineMedium => 28.sp;
  static double get headlineSmall => 24.sp;
  
  // Title styles
  static double get titleLarge => 22.sp;
  static double get titleMedium => 18.sp;
  static double get titleSmall => 16.sp;
  
  // Body styles
  static double get bodyLarge => 16.sp;
  static double get bodyMedium => 14.sp;
  static double get bodySmall => 12.sp;
  
  // Label styles
  static double get labelLarge => 14.sp;
  static double get labelMedium => 12.sp;
  static double get labelSmall => 11.sp;
  
  // Special styles
  static double get button => 16.sp;
  static double get buttonSmall => 14.sp;
  static double get caption => 12.sp;
  static double get overline => 10.sp;
  
  // Number styles
  static double get numberLarge => 48.sp;
  static double get numberMedium => 32.sp;
  static double get numberSmall => 20.sp;
}

/// ============================================
/// RESPONSIVE LAYOUT BUILDER
/// ============================================

/// Widget that provides responsive layout based on device type
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });
  
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Breakpoints.desktopMin) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= Breakpoints.mobileMax) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}

/// ============================================
/// RESPONSIVE BUILDER
/// ============================================

/// Builder widget that provides responsive constraints
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });
  
  final Widget Function(
    BuildContext context,
    BoxConstraints constraints,
    DeviceType deviceType,
  ) builder;
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = ResponsiveUtils.getDeviceType(context);
        return builder(context, constraints, deviceType);
      },
    );
  }
}

/// ============================================
/// RESPONSIVE EXTENSIONS
/// ============================================

/// Extension on num for responsive sizing
extension ResponsiveExtension on num {
  /// Percentage of screen width
  double wp(BuildContext context) => 
      MediaQuery.of(context).size.width * (this / 100);
  
  /// Percentage of screen height
  double hp(BuildContext context) => 
      MediaQuery.of(context).size.height * (this / 100);
  
  /// Minimum of width and height percentage (useful for squares)
  double minWH(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final minDimension = size.width < size.height ? size.width : size.height;
    return minDimension * (this / 100);
  }
  
  /// Maximum of width and height percentage
  double maxWH(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxDimension = size.width > size.height ? size.width : size.height;
    return maxDimension * (this / 100);
  }
}

/// Extension on BuildContext for responsive utilities
extension ResponsiveContextExtension on BuildContext {
  /// Get device type
  DeviceType get deviceType => ResponsiveUtils.getDeviceType(this);
  
  /// Check if mobile
  bool get isMobile => ResponsiveUtils.isMobile(this);
  
  /// Check if tablet
  bool get isTablet => ResponsiveUtils.isTablet(this);
  
  /// Check if desktop
  bool get isDesktop => ResponsiveUtils.isDesktop(this);
  
  /// Check if landscape
  bool get isLandscape => ResponsiveUtils.isLandscape(this);
  
  /// Check if portrait
  bool get isPortrait => ResponsiveUtils.isPortrait(this);
  
  /// Screen width
  double get screenWidth => ResponsiveUtils.screenWidth(this);
  
  /// Screen height
  double get screenHeight => ResponsiveUtils.screenHeight(this);
  
  /// Safe area padding
  EdgeInsets get safePadding => ResponsiveUtils.safePadding(this);
  
  /// Screen horizontal padding
  EdgeInsets get screenPadding => ResponsivePadding.screenHorizontal(this);
}

/// ============================================
/// RESPONSIVE GRID
/// ============================================

/// Responsive grid configuration
class ResponsiveGrid {
  ResponsiveGrid._();
  
  /// Get grid columns based on device type
  static int columns(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return 2;
      case DeviceType.tablet:
        return 3;
      case DeviceType.desktop:
        return 4;
    }
  }
  
  /// Get grid aspect ratio based on device type
  static double aspectRatio(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return 1.0;
      case DeviceType.tablet:
        return 1.1;
      case DeviceType.desktop:
        return 1.2;
    }
  }
  
  /// Get grid spacing
  static double get spacing => 16.w;
}

/// ============================================
/// RESPONSIVE GAP (SIZED BOX)
/// ============================================

/// Pre-built responsive SizedBox widgets for consistent spacing
/// Named RGap to avoid conflict with flutter_screenutil's RSizedBox
class RGap {
  RGap._();
  
  // Horizontal spacing
  static SizedBox get w2 => SizedBox(width: 2.w);
  static SizedBox get w4 => SizedBox(width: 4.w);
  static SizedBox get w8 => SizedBox(width: 8.w);
  static SizedBox get w12 => SizedBox(width: 12.w);
  static SizedBox get w16 => SizedBox(width: 16.w);
  static SizedBox get w20 => SizedBox(width: 20.w);
  static SizedBox get w24 => SizedBox(width: 24.w);
  static SizedBox get w32 => SizedBox(width: 32.w);
  static SizedBox get w48 => SizedBox(width: 48.w);
  
  // Vertical spacing
  static SizedBox get h2 => SizedBox(height: 2.h);
  static SizedBox get h4 => SizedBox(height: 4.h);
  static SizedBox get h8 => SizedBox(height: 8.h);
  static SizedBox get h12 => SizedBox(height: 12.h);
  static SizedBox get h16 => SizedBox(height: 16.h);
  static SizedBox get h20 => SizedBox(height: 20.h);
  static SizedBox get h24 => SizedBox(height: 24.h);
  static SizedBox get h32 => SizedBox(height: 32.h);
  static SizedBox get h48 => SizedBox(height: 48.h);
  static SizedBox get h56 => SizedBox(height: 56.h);
  static SizedBox get h64 => SizedBox(height: 64.h);
}