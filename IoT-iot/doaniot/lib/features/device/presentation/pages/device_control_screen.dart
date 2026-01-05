import 'dart:math';
import 'package:flutter/material.dart';
import 'package:doaniot/features/device/data/services/device_api_service.dart';
import 'package:doaniot/features/device/data/services/telemetry_api_service.dart';
import 'package:doaniot/features/device/domain/entities/device.dart';

class DeviceControlScreen extends StatefulWidget {
  final String deviceName;
  final String room;
  final Image deviceImage;
  final Device? device;

  const DeviceControlScreen({
    super.key,
    required this.deviceName,
    required this.room,
    required this.deviceImage,
    this.device,
  });

  @override
  State<DeviceControlScreen> createState() => _DeviceControlScreenState();
}

class _DeviceControlScreenState extends State<DeviceControlScreen> {
  int tabIndex = 0;
  late bool isOn;
  final DeviceApiService _deviceApiService = DeviceApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    isOn = widget.device?.isOn ?? false;
  }

  double brightness = 0.85;
  double saturation = 0.64;

  // Góc xoay của nút kéo (từ 0.0 đến 1.0)
  double colorAngle = 0.2;
  double whiteAngle = 0.7;

  Future<void> _toggleDevice(bool newValue) async {
    setState(() {
      _isLoading = true;
      isOn = newValue;
    });

    try {
      final payload = newValue ? '1' : '0';
      String topic = '/topic/qos0';
      
      if (widget.device != null && widget.device!.topic != null && widget.device!.topic!.isNotEmpty) {
        topic = widget.device!.topic!;
      }
      
      if (widget.device != null && widget.device!.id.isNotEmpty) {
        final deviceId = int.tryParse(widget.device!.id);
        if (deviceId != null) {
          await _deviceApiService.controlDevice(deviceId, payload);
        } else {
          await _deviceApiService.controlDeviceByTopic(topic, payload);
        }
      } else {
        await _deviceApiService.controlDeviceByTopic(topic, payload);
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Device ${newValue ? "turned on" : "turned off"}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
        
        await Future.delayed(const Duration(seconds: 2));
        if (mounted && widget.device != null && widget.device!.id.isNotEmpty) {
          final deviceId = int.tryParse(widget.device!.id);
          if (deviceId != null) {
            try {
              final latestTelemetry = await TelemetryApiService().getLatestTelemetry(deviceId);
              if (latestTelemetry != null && mounted) {
                setState(() {
                  isOn = latestTelemetry.relay == 1;
                });
              }
            } catch (e) {
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to control device: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        setState(() => isOn = !newValue);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildDeviceInfo(),
            const SizedBox(height: 20),
            _buildTabs(),
            const SizedBox(height: 40),
            _buildControl(),
            const SizedBox(height: 40),
            _buildSliderSection(),
            const SizedBox(height: 40),
            _buildScheduleButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: const BackButton(color: Colors.black),
      title: const Text(
        'Control Device',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      actions: const [
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.black),
          onPressed: null,
        )
      ],
    );
  }

  Widget _buildDeviceInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          SizedBox(
            width: 45,
            height: 45,
            child: widget.deviceImage,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.deviceName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.room,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          // Switch tùy chỉnh để giống hình mẫu
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: isOn,
              activeColor: Colors.white,
              activeTrackColor: Colors.blue,
              onChanged: _isLoading ? null : (v) => _toggleDevice(v),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    const labels = ['White', 'Color', 'Scene'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: List.generate(3, (i) {
          final active = tabIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => tabIndex = i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: active ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: active
                      ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                      : [],
                ),
                child: Center(
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      color: active ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildControl() {
    if (tabIndex == 0) {
      return _RingController(
        colors: const [Color(0xFFFFE0B2), Colors.white, Color(0xFFBBDEFB)],
        angle: whiteAngle,
        onChanged: (v) => setState(() => whiteAngle = v),
        center: widget.deviceImage,
      );
    }
    if (tabIndex == 1) {
      return _RingController(
        colors: List.generate(360, (i) => HSVColor.fromAHSV(1, i.toDouble(), 1, 1).toColor()),
        angle: colorAngle,
        onChanged: (v) => setState(() => colorAngle = v),
        center: widget.deviceImage,
      );
    }
    return const SizedBox(height: 280, child: Center(child: Text('Scene Mode')));
  }

  Widget _buildSliderSection() {
    return Column(
      children: [
        _buildCustomSlider(Icons.wb_sunny_outlined, brightness, (v) => setState(() => brightness = v)),
        if (tabIndex == 1) ...[
          const SizedBox(height: 16),
          _buildCustomSlider(Icons.opacity, saturation, (v) => setState(() => saturation = v)),
        ],
      ],
    );
  }

  Widget _buildCustomSlider(IconData icon, double value, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Icon(icon, color: Colors.black45, size: 28),
          const SizedBox(width: 8),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                activeTrackColor: Colors.blue,
                inactiveTrackColor: Colors.blue.withOpacity(0.1),
                thumbColor: Colors.white,
                overlayColor: Colors.blue.withOpacity(0.1),
              ),
              child: Slider(value: value, onChanged: onChanged),
            ),
          ),
          const SizedBox(width: 8),
          Text('${(value * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildScheduleButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFFEDF3FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Text(
              'Schedule Automatic ON/OFF',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= COMPONENT VÒNG ĐIỀU KHIỂN CÓ NÚT KÉO =================

class _RingController extends StatelessWidget {
  final List<Color> colors;
  final double angle;
  final ValueChanged<double> onChanged;
  final Widget center;

  const _RingController({
    required this.colors,
    required this.angle,
    required this.onChanged,
    required this.center,
  });

  @override
  Widget build(BuildContext context) {
    const double size = 280;
    const double radius = (size / 2) - 25;

    // Tính toán vị trí nút kéo dựa trên góc xoay
    // Điều chỉnh -pi/2 để 0.0 bắt đầu từ đỉnh trên cùng (nếu muốn)
    // Ở đây dùng khớp với SweepGradient (bắt đầu từ bên phải)
    double drawAngle = angle * 2 * pi;
    double thumbX = (size / 2) + radius * cos(drawAngle);
    double thumbY = (size / 2) + radius * sin(drawAngle);

    return GestureDetector(
      onPanUpdate: (details) {
        final box = context.findRenderObject() as RenderBox;
        final centerPoint = box.size.center(Offset.zero);
        final pos = details.localPosition - centerPoint;
        // Chuyển đổi tọa độ sang giá trị 0.0 - 1.0
        double newAngle = atan2(pos.dy, pos.dx) / (2 * pi);
        if (newAngle < 0) newAngle += 1.0;
        onChanged(newAngle);
      },
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Vẽ vòng gradient
            CustomPaint(
              size: const Size(size, size),
              painter: _RingPainter(colors),
            ),
            // Ảnh bóng đèn ở giữa
            SizedBox(width: 140, height: 140, child: center),
            // Nút kéo (Thumb)
            Positioned(
              left: thumbX - 16,
              top: thumbY - 16,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black.withOpacity(0.05)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final List<Color> colors;
  _RingPainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - 25;

    final paint = Paint()
      ..shader = SweepGradient(colors: colors).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 35
      ..strokeCap = StrokeCap.round;

    // Vẽ vòng tròn chính
    canvas.drawCircle(center, radius, paint);

    // Thêm một vòng mờ nhẹ bên dưới để tạo chiều sâu (tùy chọn)
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 38;
    canvas.drawCircle(center, radius, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}