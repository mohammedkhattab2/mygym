import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/gyms/domain/entities/gym.dart';
import 'package:mygym/src/features/gyms/presentation/bloc/gyms_bloc.dart';

class GymsMapView extends StatefulWidget {
  const GymsMapView({super.key});

  @override
  State<GymsMapView> createState() => _GymsMapViewState();
}

class _GymsMapViewState extends State<GymsMapView> {
  GoogleMapController? _mapController;
  static const LatLng _defultCairo = LatLng(30.0444, 31.2357);
  final Map<String, BitmapDescriptor> _markerIcons = {};
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    context.read<GymsBloc>().add(
      const GymsEvent.updateLocation(latitude: 30.0444, longitude: 31.2357),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _movCameraToGyms();
  }

  Future<void> _buildMarkersAsync(List<Gym> gyms) async {
    final Set<Marker> newMarkers = {};
    
    for (final gym in gyms) {
      BitmapDescriptor icon;
      
      if (_markerIcons.containsKey(gym.id)) {
        icon = _markerIcons[gym.id]!;
      } else {
        icon = await _createCustomMarker(gym.name);
        _markerIcons[gym.id] = icon;
      }
      
      newMarkers.add(
        Marker(
          markerId: MarkerId(gym.id),
          position: LatLng(gym.latitude, gym.longitude),
          icon: icon,
          onTap: () {
            // TODO: Open GymDetails or BottomSheet
          },
        ),
      );
    }
    
    if (mounted) {
      setState(() {
        _markers = newMarkers;
      });
    }
  }

  Future<BitmapDescriptor> _createCustomMarker(String gymName) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    
    const double markerWidth = 160;
    const double labelHeight = 40;
    const double pinHeight = 50;
    const double totalHeight = labelHeight + pinHeight;
    const double iconSize = 28;
    const double padding = 8;
    const double borderRadius = 10;
    
    // === Draw Label Box (above pin) ===
    // Shadow for label
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    
    final RRect shadowRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(2, 2, markerWidth - 4, labelHeight),
      const Radius.circular(borderRadius),
    );
    canvas.drawRRect(shadowRRect, shadowPaint);
    
    // Label background
    final backgroundPaint = Paint()..color = Colors.white;
    final RRect backgroundRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, markerWidth, labelHeight),
      const Radius.circular(borderRadius),
    );
    canvas.drawRRect(backgroundRRect, backgroundPaint);
    
    // Label border
    final borderPaint = Paint()
      ..color = const Color(0xFFE91E63)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(backgroundRRect, borderPaint);
    
    // Gym icon circle
    final iconPaint = Paint()..color = const Color(0xFFE91E63);
    canvas.drawCircle(
      Offset(padding + iconSize / 2, labelHeight / 2),
      iconSize / 2,
      iconPaint,
    );
    
    // Dumbbell icon inside circle
    final iconInnerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    final centerX = padding + iconSize / 2;
    final centerY = labelHeight / 2;
    
    canvas.drawLine(
      Offset(centerX - 7, centerY),
      Offset(centerX + 7, centerY),
      iconInnerPaint,
    );
    canvas.drawLine(
      Offset(centerX - 7, centerY - 4),
      Offset(centerX - 7, centerY + 4),
      iconInnerPaint,
    );
    canvas.drawLine(
      Offset(centerX + 7, centerY - 4),
      Offset(centerX + 7, centerY + 4),
      iconInnerPaint,
    );
    
    // Gym name text
    final textPainter = TextPainter(
      text: TextSpan(
        text: gymName.length > 14 ? '${gymName.substring(0, 14)}...' : gymName,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    textPainter.layout(maxWidth: markerWidth - iconSize - padding * 3);
    textPainter.paint(
      canvas,
      Offset(padding * 2 + iconSize, (labelHeight - textPainter.height) / 2),
    );
    
    // === Draw Standard Pin Marker (below label) ===
    final pinCenterX = markerWidth / 2;
    final pinTop = labelHeight + 4;
    const pinWidth = 30.0;
    const pinTotalHeight = 42.0;
    
    // Pin head (circle)
    final pinHeadPaint = Paint()..color = const Color(0xFFE91E63);
    canvas.drawCircle(
      Offset(pinCenterX, pinTop + pinWidth / 2),
      pinWidth / 2,
      pinHeadPaint,
    );
    
    // Pin inner circle (white)
    final pinInnerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(pinCenterX, pinTop + pinWidth / 2),
      pinWidth / 4,
      pinInnerPaint,
    );
    
    // Pin point (triangle)
    final pinPath = Path()
      ..moveTo(pinCenterX - pinWidth / 3, pinTop + pinWidth / 2 + 4)
      ..lineTo(pinCenterX, pinTop + pinTotalHeight)
      ..lineTo(pinCenterX + pinWidth / 3, pinTop + pinWidth / 2 + 4)
      ..close();
    
    canvas.drawPath(pinPath, pinHeadPaint);
    
    // Pin shadow
    final pinShadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(pinCenterX, pinTop + pinTotalHeight + 2),
        width: 16,
        height: 6,
      ),
      pinShadowPaint,
    );
    
    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(markerWidth.toInt(), totalHeight.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List bytes = byteData!.buffer.asUint8List();
    
    return BitmapDescriptor.bytes(bytes);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Gyms Map",
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
      ),
      body: BlocConsumer<GymsBloc, GymsState>(
        listener: (context, state) {
          if (state.status == GymsStatus.success) {
            _movCameraToGyms();
            _buildMarkersAsync(state.gyms);
          }
        },
        builder: (context, state) {
          final gyms = state.gyms;
          final isInitialLoading =
              state.status == GymsStatus.loading && gyms.isEmpty;
          final hasError = state.status == GymsStatus.failure && gyms.isEmpty;

          if (isInitialLoading) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }
          if (hasError) {
            return Center(
              child: Text(
                state.errorMessage ?? "Failed to load gyms",
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
          return Stack(
            children: [
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: const CameraPosition(
                  target: _defultCairo,
                  zoom: 11,
                ),
                markers: _markers,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: true,
              ),
              Positioned(
                left: 16.w,
                right: 16.w,
                bottom: 16.w,
                child: _BottomInfoBar(gymsCount: gyms.length),
              ),
            ],
          );
        },
      ),
    );
  }

  void _movCameraToGyms() {
    final stats = context.read<GymsBloc>().state;
    if (stats.gyms.isEmpty || _mapController == null) return;

    final firstGym = stats.gyms.first;
    _mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(firstGym.latitude, firstGym.longitude),
        12,
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

class _BottomInfoBar extends StatelessWidget {
  final int gymsCount;

  const _BottomInfoBar({required this.gymsCount});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on_rounded,
            color: colorScheme.primary,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              gymsCount == 0
                  ? "No gyms found"
                  : '$gymsCount gyms loaded on the map',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
