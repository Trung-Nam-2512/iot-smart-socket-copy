import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:doaniot/features/device/presentation/pages/enter_setup_code_screen.dart';
import 'package:doaniot/features/device/domain/entities/device.dart';
import 'package:doaniot/features/device/presentation/pages/connect_device_screen.dart';

class ScanDeviceScreen extends StatefulWidget {
  const ScanDeviceScreen({super.key});

  @override
  State<ScanDeviceScreen> createState() => _ScanDeviceScreenState();
}

class _ScanDeviceScreenState extends State<ScanDeviceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Real Camera Preview
          MobileScanner(
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.noDuplicates,
              returnImage: true,
            ),
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                debugPrint('Barcode found! $code');

                if (code != null && code.startsWith("WIFI:")) {
                  // Parse Wifi QR: WIFI:S:MySSID;T:WPA;P:MyPass;;
                  final String ssid = RegExp(r'S:(.*?);').firstMatch(code)?.group(1) ?? "Unknown";
                  final String password = RegExp(r'P:(.*?);').firstMatch(code)?.group(1) ?? "";

                  // Navigate to ConnectDeviceScreen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConnectDeviceScreen(
                        // Create a temporary Device object
                        device: Device(
                          id: 'new_device',
                          name: ssid, // Use SSID as temporary name
                          type: 'wifi',
                          imageUrl: "assets/wifi.png",
                        ),
                        wifiSsid: ssid,
                        wifiPassword: password,
                      ),
                    ),
                  );
                } else {
                   // Fallback for non-wifi QR (existing logic)
                   Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConnectDeviceScreen(
                        device: Device(
                          id: 'manual_scan',
                          name: "Smart Device",
                          type: 'unknown',
                          imageUrl: "assets/wcam.png",
                        ),
                      ),
                    ),
                  );
                }
                break; 
              }
            },
          ),

          // Scanner Overlay
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: AspectRatio(
                aspectRatio: 1,
                child: CustomPaint(painter: ScannerOverlayPainter(_animation)),
              ),
            ),
          ),

          // Top Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Scan Device',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          // Bottom Controls
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 24, right: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Can't scan the QR code?",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EnterSetupCodeScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'Enter setup code manually',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.folder_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),

                      // Shutter Button
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          "assets/picture.svg",
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Animation<double> animation;

  ScannerOverlayPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double cornerLength = 50; // Increased length
    final double cornerRadius = 20; // Radius for rounding

    // Path helper for rounded corners
    Path drawCorner(double x, double y, double dx, double dy) {
      // (x,y) is the corner point
      // dx is direction for horizontal arm (-1 or 1)
      // dy is direction for vertical arm (-1 or 1)

      final path = Path();
      // Start at end of horizontal arm
      path.moveTo(x + (cornerLength * dx), y);
      // Line to start of arc
      path.lineTo(x + (cornerRadius * dx), y);
      // Arc to vertical arm
      path.quadraticBezierTo(x, y, x, y + (cornerRadius * dy));
      // Line to end of vertical arm
      path.lineTo(x, y + (cornerLength * dy));

      return path;
    }

    // Top Left
    canvas.drawPath(drawCorner(0, 0, 1, 1), paint);

    // Top Right
    canvas.drawPath(drawCorner(size.width, 0, -1, 1), paint);

    // Bottom Left
    canvas.drawPath(drawCorner(0, size.height, 1, -1), paint);

    // Bottom Right
    canvas.drawPath(drawCorner(size.width, size.height, -1, -1), paint);

    // Scan Line Animation
    final double yPos = size.height * animation.value;
    final bool movingDown = animation.status == AnimationStatus.forward;

    // Main line
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(10, yPos), Offset(size.width - 10, yPos), linePaint);

    // Trailing shadow/glow
    // If moving down, shadow is above. If moving up, shadow is below.
    // Or just a gradient tail.

    final gradientPaint = Paint()
      ..shader =
          LinearGradient(
            begin: movingDown ? Alignment.bottomCenter : Alignment.topCenter,
            end: movingDown ? Alignment.topCenter : Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.4),
              Colors.white.withOpacity(0.0),
            ],
            stops: const [0.0, 1.0],
          ).createShader(
            Rect.fromCenter(
              center: Offset(size.width / 2, yPos - (movingDown ? 25 : -25)),
              width: size.width - 20,
              height: 50,
            ),
          )
      ..style = PaintingStyle.fill;

    final shadowHeight = 60.0;
    final shadowRect = Rect.fromLTRB(
      10,
      movingDown ? yPos - shadowHeight : yPos,
      size.width - 10,
      movingDown ? yPos : yPos + shadowHeight,
    );

    canvas.drawRect(shadowRect, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) => true;
}
