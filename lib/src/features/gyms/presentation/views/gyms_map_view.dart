import 'package:flutter/material.dart';
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

  Set<Marker> _buildMarkers(List<Gym> gyms) {
    return gyms.map((gym) {
      return Marker(
        markerId: MarkerId(gym.id),
        position: LatLng(gym.latitude, gym.longitude),
        infoWindow: InfoWindow(
          title: gym.name,
          snippet:
              '${gym.rating.toStringAsFixed(1)} ★ • ${gym.formattedDistance ?? gym.city}',
        ),
        onTap: () {
          // TODO: Open GymDetails or BottomSheet
        },
      );
    }).toSet();
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
                markers: _buildMarkers(gyms),
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
