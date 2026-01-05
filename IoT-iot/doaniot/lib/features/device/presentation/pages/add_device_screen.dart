import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doaniot/features/device/domain/entities/device.dart';
import 'package:doaniot/features/device/presentation/pages/connect_device_screen.dart';
import 'package:doaniot/features/device/presentation/pages/scan_device_screen.dart';

class AddDeviceScreen extends StatefulWidget {
  final bool isNearbySelected;
  const AddDeviceScreen({super.key, this.isNearbySelected = true});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Device> _foundDevices = [];

  late bool _isNearbySelected;
  String _selectedCategory = 'Popular';
  final List<String> _categories = [
    'Popular',
    'Lightning',
    'Camera',
    'Electrical',
  ];

  final List<Map<String, dynamic>> _manualDevices = [
    {"name": "Smart V1 CCTV", "img": "assets/cam.png", "category": "Camera"},
    {"name": "Smart Webcam", "img": "assets/wcam.png", "category": "Camera"},
    {"name": "Smart V2 CCTV", "img": "assets/camx.png", "category": "Camera"},
    {"name": "Smart Lamp", "img": "assets/den.png", "category": "Lightning"},
    {"name": "Speaker", "img": "assets/loa.png", "category": "Popular"},
    {
      "name": "Wi-Fi Router",
      "img": "assets/wifi.png",
      "category": "Electrical",
    },
  ];

  @override
  void initState() {
    super.initState();
    _isNearbySelected = widget.isNearbySelected;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Simulate finding devices
    _startScanning();
  }

  void _startScanning() async {
    // 1. Smart Light (Top Left - 11h)
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() {
        _foundDevices.add(
          Device(
            id: 'scan_1',
            imageUrl: "assets/den.png",
            name: "Smart Light",
            type: 'light',
          ),
        );
      });
    }

    // 2. Camera (Top Right - 2h)
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      setState(() {
        _foundDevices.add(
          Device(
            id: 'scan_2',
            imageUrl: "assets/cam.png",
            name: "Smart Camera",
            type: 'camera',
          ),
        );
      });
    }

    // 3. Wi-Fi Router (Bottom Right - 4h)
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        _foundDevices.add(
          Device(
            id: 'scan_3',
            imageUrl: "assets/wifi.png",
            name: "Wi-Fi Router",
            type: 'wifi',
          ),
        );
      });
    }

    // 4. AC (Bottom - 6h)
    await Future.delayed(const Duration(milliseconds: 3000));
    if (mounted) {
      setState(() {
        _foundDevices.add(
          Device(
            id: 'scan_4',
            imageUrl: "assets/dhoa.png",
            name: "Air Conditioner",
            type: 'ac',
          ),
        );
      });
    }

    // 5. Speaker (Bottom Left - 8h)
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      setState(() {
        _foundDevices.add(
          Device(
            id: 'scan_5',
            imageUrl: "assets/loa.png",
            name: "Speaker",
            type: 'speaker',
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Device',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/qrscanner.svg",
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScanDeviceScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          // Toggle Switch
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isNearbySelected = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _isNearbySelected
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Nearby Devices',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _isNearbySelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isNearbySelected = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_isNearbySelected
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Add Manual',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !_isNearbySelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Content
          Expanded(
            child: _isNearbySelected ? _buildNearbyView() : _buildManualView(),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyView() {
    return Column(
      children: [
        Text(
          'Looking for nearby devices...',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildInstructionChip(
              Icons.wifi,
              "Turn on your Wifi & Bluetooth to connect",
            ),
          ],
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                painter: RipplePainter(_controller),
                size: const Size(250, 250),
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1))],
                ),
                child: ClipOval(
                  child: Image.asset("assets/mandevice.png", fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                width: 320,
                height: 320,
                child: Stack(
                  children: _foundDevices
                      .map(
                        (device) => Center(
                          child: _buildDeviceItem(device),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Connect to All Devices',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Can't find your devices? \nLearn more",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildManualView() {
    // Filter devices based on category
    // If 'Popular' is selected, we show all (or a curated list), matching the screenshot where all are visible.
    // Otherwise filter by strict category match.
    final filteredDevices = _selectedCategory == 'Popular'
        ? _manualDevices
        : _manualDevices
              .where((d) => d['category'] == _selectedCategory)
              .toList();

    return Column(
      children: [
        // Categories
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: _categories.map((category) {
              final isSelected = category == _selectedCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.inputBorder,
                      ),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),

        // Device Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24, // Increased spacing for text
              childAspectRatio: 0.75, // Adjusted for text below image
            ),
            itemCount: filteredDevices.length,
            itemBuilder: (context, index) {
              final device = filteredDevices[index];
              return GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConnectDeviceScreen(
                        device: Device(
                          id: 'manual_${index}',
                          imageUrl: device['img'],
                          name: device['name'],
                          type: device['category'].toString().toLowerCase(),
                        ),
                      ),
                    ),
                  );
                  if (result != null && context.mounted) {
                    Navigator.pop(context, result);
                  }
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Image.asset(device['img'], fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      device['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 12),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bluetooth, color: Colors.white, size: 12),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceItem(Device device) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConnectDeviceScreen(device: device),
          ),
        );
        if (result != null && context.mounted) {
          Navigator.pop(context, result);
        }
      },
      child: SizedBox(
        width: 60, 
        height: 60, 
        child: Image.asset(device.imageUrl, fit: BoxFit.contain)
      ),
    );
  }
}

class RipplePainter extends CustomPainter {
  final Animation<double> animation;
  // ... (keep RipplePainter logic, just removing DeviceItem class from here)


  RipplePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
          .withOpacity(0.3) // Light blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw 3 expanding circles
    for (int i = 0; i < 3; i++) {
      final progress = (animation.value + i / 3) % 1.0;
      final radius = progress * size.width * 0.4 + 50;
      final opacity = 1.0 - progress;

      paint.color = AppColors.primary.withOpacity(opacity * 0.5); // Fade out
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
