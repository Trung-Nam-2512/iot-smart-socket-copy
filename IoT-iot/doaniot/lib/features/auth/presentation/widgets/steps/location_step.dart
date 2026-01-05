import 'dart:async';
import 'dart:ui'; // Cần cho ImageFilter
import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;

class LocationStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const LocationStep({super.key, required this.onNext, required this.onSkip});

  @override
  State<LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends State<LocationStep> {
  bool _isLocationEnabled = false;
  final TextEditingController _addressController = TextEditingController();
  final MapController _mapController = MapController();
  StreamSubscription? _mapEventSubscription;

  // Default location (e.g., Manhattan, NY)
  LatLng _currentCenter = const LatLng(40.7580, -73.9855);
  bool _isMoving = false;

  @override
  void initState() {
    super.initState();
    _mapEventSubscription = _mapController.mapEventStream.listen((event) {
      if (event is MapEventMoveStart) {
        setState(() {
          _isMoving = true;
          if (_isLocationEnabled) {
            _addressController.text = "Locating...";
          }
        });
      } else if (event is MapEventMoveEnd) {
        setState(() {
          _isMoving = false;
          _currentCenter = event.camera.center;
        });
        if (_isLocationEnabled) {
          _updateAddressFromCoordinates(_currentCenter);
        }
      }
    });
  }

  @override
  void dispose() {
    _mapEventSubscription?.cancel();
    _mapController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _enableLocation() async {
    setState(() {
      _addressController.text = "Locating...";
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLocationEnabled = true;
      _mapController.move(_currentCenter, 15);
      _updateAddressFromCoordinates(_currentCenter);
    });
  }

  void _updateAddressFromCoordinates(LatLng point) {
    final lat = point.latitude.toStringAsFixed(4);
    final lng = point.longitude.toStringAsFixed(4);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _addressController.text = "701 7th Ave, New York ($lat, $lng)";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Content Layer
        Column(
          children: [
            const SizedBox(height: 24),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Set Home ',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                children: const [
                  TextSpan(
                    text: 'Location',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Pin your home's location to enhance location-based features. Privacy is our priority.",
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),

            // Map Area
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // Interactive Map
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _currentCenter,
                          initialZoom: 15.0,
                          interactionOptions: InteractionOptions(
                            flags: _isLocationEnabled
                                ? InteractiveFlag.all
                                : InteractiveFlag.none,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                            subdomains: const ['a', 'b', 'c'],
                            userAgentPackageName: 'com.doaniot.app',
                          ),
                        ],
                      ),

                      // Center Pin (Ghim vị trí)
                      if (_isLocationEnabled)
                        const Center(
                          // Padding bottom để mũi nhọn của ghim chạm đúng tâm map
                          // Marker cao khoảng 76px (60 body + 16 tail), nên đẩy lên 1 nửa + tail
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 76 / 2),
                            child: CustomLocationMarker(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Address Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Address Details",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  // ĐÃ SỬA: Bỏ icon ở đây
                  TextField(
                    controller: _addressController,
                    readOnly: true,
                    decoration: InputDecoration(
                      // prefixIcon: null, // Đã xóa theo yêu cầu
                      hintText: 'Address will appear here...',
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Actions
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onSkip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF3F5F7),
                        foregroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (_isLocationEnabled && !_isMoving)
                          ? widget.onNext
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Blur & Dialog Overlay (Giữ nguyên)
        if (!_isLocationEnabled)
          Positioned.fill(
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Enable Location',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Please activate the location feature, so we can find your home address.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: _enableLocation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Enable Location',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: widget.onSkip,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            minimumSize: const Size(double.infinity, 52),
                            backgroundColor: const Color(0xFFEFF1F8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: const Text(
                            'Not Now',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// --- WIDGET MARKER MỚI GIỐNG HÌNH MẪU ---
class CustomLocationMarker extends StatelessWidget {
  const CustomLocationMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Phần đầu tròn
        Container(
          width: 45,
          height: 45,
          padding: const EdgeInsets.all(8), // Viền xanh bên ngoài
          decoration: BoxDecoration(
            color: AppColors.primary, // Màu nền xanh
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
            // Thêm viền trắng mỏng nếu muốn giống hệt hình (option)
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Container(
            // Vòng tròn nhạt hơn bên trong
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Image.asset('assets/user.png', width: 30),
          ),
        ),

        // 2. Phần đuôi nhọn (Tam giác)
        Transform.translate(
          offset: const Offset(0, -5), // Đẩy lên để dính vào hình tròn
          child: ClipPath(
            clipper: _TriangleClipper(),
            child: Container(width: 20, height: 16, color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

// Clipper để vẽ hình tam giác cho đuôi marker
class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0); // Góc trái trên
    path.lineTo(size.width, 0); // Góc phải trên
    path.lineTo(size.width / 2, size.height); // Mũi nhọn ở giữa dưới
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
