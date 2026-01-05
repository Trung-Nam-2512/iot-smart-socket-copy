import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:doaniot/features/device/presentation/pages/add_device_screen.dart';
import 'package:doaniot/features/device/presentation/pages/scan_device_screen.dart';
import 'package:doaniot/features/chat/presentation/pages/chat_ai_screen.dart';
import 'package:doaniot/features/notification/presentation/pages/notification_screen.dart';
import 'package:doaniot/features/home/presentation/pages/voice_command_screen.dart';
import 'package:doaniot/features/device/presentation/pages/device_control_screen.dart';
import 'package:doaniot/features/device/domain/entities/device.dart';
import 'package:doaniot/features/home/domain/entities/room.dart';
import 'package:doaniot/features/device/data/repositories/mock_device_repository.dart';
import 'package:doaniot/features/device/data/repositories/device_repository_impl.dart';
import 'package:doaniot/features/device/domain/repositories/device_repository.dart';
import 'dart:ui';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Room _selectedRoom = const Room(id: 'all', name: 'All Rooms');
  String _selectedHome = "My Home";

  // Mock Rooms
  final List<Room> _rooms = [
    const Room(id: 'all', name: 'All Rooms'),
    const Room(id: 'living_room', name: 'Living Room'),
    const Room(id: 'bedroom', name: 'Bedroom'),
    const Room(id: 'kitchen', name: 'Kitchen'),
  ];

  final List<String> _homes = [
    "My Home",
    "My Apartment",
    "My Office",
    "My Parents' House",
    "My Garden",
  ];

  bool _isMenuOpen = false;
  List<Device> _devices = [];
  final DeviceRepository _deviceRepository = DeviceRepositoryImpl();

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  void _loadDevices() async {
    try {
      final devices = await _deviceRepository.getDevices();
      if (mounted) {
        setState(() {
          _devices = devices;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load devices: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  List<Device> get _filteredDevices {
    if (_selectedRoom.id == 'all') {
      return _devices;
    }
    return _devices.where((d) => d.roomId == _selectedRoom.id).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => _showHomeOptions(context),
                          child: Row(
                            children: [
                              // giá trị phụ thuộc vào giá trị được chọn
                              Text(
                                _selectedHome,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.textPrimary,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            // robot
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ChatAIScreen(),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.transparent,
                                child: Image.asset("assets/robot.png"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // notification icon
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    const NotificationScreen(),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.transparent,
                                child: Stack(
                                  children: [
                                    SvgPicture.asset("assets/bellico.svg"),
                                    Positioned(
                                      right: 2,
                                      top: 2,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Colors.redAccent,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Weather Card (Reduced padding/height)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ), // Reduced vertical padding
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF3D5AFE),
                            Color(0xFF536DFE),
                          ], // Blue gradient
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3D5AFE).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '20',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      '°C',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // const SizedBox(height: 8),
                              Text(
                                'New York City, USA',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Today Cloudy',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _weatherDetail(Icons.air, "AQI 92"),
                                  const SizedBox(width: 16),
                                  _weatherDetail(
                                    Icons.water_drop_outlined,
                                    "78.2%",
                                  ),
                                  const SizedBox(width: 16),
                                  _weatherDetail(Icons.speed, "2.0 m/s"),
                                ],
                              ),
                            ],
                          ),
                          // Cloud/Sun Icon
                          Image.asset(
                            "assets/cloudsun.png",
                            width: 60,
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // All Devices Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Devices',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Icon(
                          Icons.more_vert,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _rooms
                            .map(
                              (room) => Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: _buildFilterChip(
                              room.name,
                              _selectedRoom.id == room.id,
                              onTap: () {
                                setState(() {
                                  _selectedRoom = room;
                                });
                              },
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Empty State
                    if (_filteredDevices.isEmpty)
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 200,
                              height: 200,
                              child: Image.asset("assets/task.png"),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Devices',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "You haven't added a device yet.",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 24),
                            // Resized Add Device Button
                            SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const AddDeviceScreen(),
                                    ),
                                  );
                                  if (result != null && result is Device) {
                                     // The device is already added to repo in ConnectDeviceScreen? 
                                     // Actually ConnectDeviceScreen adds it. 
                                     // We just need to refresh.
                                     _loadDevices();
                                  }
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Add Device'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                            // Add enough space for FABs at the bottom
                            const SizedBox(height: 80),
                          ],
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: _filteredDevices.length,
                        itemBuilder: (context, index) {
                          final device = _filteredDevices[index];
                          return InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DeviceControlScreen(
                                    deviceName: device.name,
                                    room: _selectedRoom.name,
                                    deviceImage: Image.asset(device.imageUrl),
                                    device: device,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 48,
                                        width: 48,
                                        child: Image.asset(device.imageUrl, fit: BoxFit.contain),
                                      ),
                                      SizedBox(
                                        height: 24,
                                        child: Switch(
                                          value: device.isOn,
                                          onChanged: (val) async {
                                            setState(() {
                                              final index = _devices.indexWhere((d) => d.id == device.id);
                                              if (index != -1) {
                                                _devices[index] = device.copyWith(isOn: val);
                                              }
                                            });
                                            
                                            try {
                                              await _deviceRepository.updateDeviceStatus(device.id, val);
                                              
                                              if (mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Device ${val ? "turned on" : "turned off"}'),
                                                    backgroundColor: Colors.green,
                                                    duration: const Duration(seconds: 1),
                                                  ),
                                                );
                                              }
                                              
                                              await Future.delayed(const Duration(seconds: 5));
                                              if (mounted) {
                                                _loadDevices();
                                              }
                                            } catch (e) {
                                              setState(() {
                                                final index = _devices.indexWhere((d) => d.id == device.id);
                                                if (index != -1) {
                                                  _devices[index] = device.copyWith(isOn: !val);
                                                }
                                              });
                                              if (mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Failed to control: $e'),
                                                    backgroundColor: Colors.red,
                                                    duration: const Duration(seconds: 3),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          activeColor: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    device.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  // Power usage display
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGrey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.electric_bolt, // Changed icon to electric
                                          size: 12,
                                          color: AppColors.secondary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${device.currentPower} W",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    // Add enough space for FABs at the bottom if grid is shown
                    if (_devices.isNotEmpty) const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            // Floating Action Buttons
            Positioned(
              bottom: 24,
              right: 90,
              child: FloatingActionButton(
                heroTag: "mic_fab",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VoiceCommandScreen(),
                    ),
                  );
                },
                backgroundColor: AppColors.secondary,
                shape: const CircleBorder(),
                elevation: 0,
                child: SvgPicture.asset(
                  "assets/micico.svg",
                  color: AppColors.primary,
                ),
              ),
            ),

            // Add Menu Overlay (Now effectively above mic, blurring it)
            _buildAddMenu(),

            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton(
                heroTag: "add_fab",
                onPressed: () {
                  setState(() {
                    _isMenuOpen = !_isMenuOpen;
                  });
                },
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
                elevation: 0,
                child: Icon(_isMenuOpen ? Icons.close : Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddMenu() {
    if (!_isMenuOpen) return const SizedBox.shrink();

    return Stack(
      children: [
        // 1. Visual Blur Layer & Interaction Layer (Dismiss on tap)
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isMenuOpen = false;
              });
            },
            behavior: HitTestBehavior.translucent, // Catch taps
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
            ),
          ),
        ),

        // 2. Menu Content
        Positioned(
          bottom: 90, // Position above the FAB
          right: 24,
          child: CustomPaint(
            painter: BubbleMenuPainter(color: Colors.white),
            child: Container(
              width: 180,
              padding: const EdgeInsets.only(bottom: 10), // Space for tail
              child: Material(
                type: MaterialType.transparency,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    _buildMenuItem(
                      context,
                      icon: SvgPicture.asset(
                        "assets/suitcase.svg",
                        colorFilter: const ColorFilter.mode(
                          AppColors.textPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                      text: 'Add Device',
                      onTap: () async {
                        setState(() {
                          _isMenuOpen = false;
                        });
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const AddDeviceScreen(isNearbySelected: false),
                          ),
                        );
                        if (result != null && result is Device) {
                          setState(() {
                            _devices.add(result);
                          });
                        }
                      },
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _buildMenuItem(
                      context,
                      icon: SvgPicture.asset(
                        "assets/qrscanner.svg",
                        colorFilter: const ColorFilter.mode(
                          AppColors.textPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                      text: 'Scan',
                      onTap: () {
                        setState(() {
                          _isMenuOpen = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScanDeviceScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showHomeOptions(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (context, animation, secondaryAnimation) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // 1. Blur Background
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
              ),

              // 2. Dismiss
              GestureDetector(
                onTap: () => Navigator.pop(context),
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.transparent),
              ),

              // 3. Floating Menu
              Positioned(
                top: 80, // Approximate header height + offset
                left: 24,
                child: ScaleTransition(
                  scale: animation,
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    child: Container(
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ..._homes.map((home) {
                            final isSelected = _selectedHome == home;
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedHome = home;
                                    });
                                    Navigator.pop(context);
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        if (isSelected)
                                          const Icon(
                                            Icons.check,
                                            color: AppColors.primary,
                                            size: 20,
                                          )
                                        else
                                          const SizedBox(width: 20),
                                        const SizedBox(width: 12),
                                        Text(
                                          home,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                              ],
                            );
                          }).toList(),

                          // Home Management
                          InkWell(
                            onTap: () {
                              // Navigate to Home Management
                              Navigator.pop(context);
                            },
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.settings_outlined,
                                    color: Colors.black87,
                                    size: 20,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Home Management',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required Widget icon,
        required String text,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 16),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _weatherDetail(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.inputBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class BubbleMenuPainter extends CustomPainter {
  final Color color;
  BubbleMenuPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const double cornerRadius = 24.0;
    const double tailHeight = 12.0;

    final path = Path();
    final double contentHeight = size.height - tailHeight;

    // Main body
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, contentHeight),
        const Radius.circular(cornerRadius),
      ),
    );

    // Tail Geometry
    // FAB is 56px wide, aligned with right edge. Center is 28px from right.
    final double tailTipX = size.width - 28.0;
    final double tailBaseWidthHalf = 10.0;

    path.moveTo(tailTipX - tailBaseWidthHalf, contentHeight);

    // Draw smooth tail
    path.lineTo(tailTipX - 2, size.height - 2); // Left side
    path.quadraticBezierTo(
      tailTipX,
      size.height, // Control tip
      tailTipX + 2,
      size.height - 2, // Right side
    );
    path.lineTo(tailTipX + tailBaseWidthHalf, contentHeight);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}