import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class LoadingDialog extends StatefulWidget {
  final String message;
  const LoadingDialog({super.key, this.message = 'Sign up...'});

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();

  // Hàm static để gọi từ bên ngoài
  static void show(BuildContext context, {String message = 'Sign up...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6), // Làm nền tối mờ
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: LoadingDialog(message: message),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}

class _LoadingDialogState extends State<LoadingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Tốc độ xoay
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 150, // Điều chỉnh kích thước khung dialog
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Phần vòng xoay
            RotationTransition(
              turns: _controller,
              child: CustomPaint(
                size: const Size(50, 50),
                painter: GradientProgressPainter(
                  color: const Color(0xFF3D61FF), // Màu xanh theo hình mẫu
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Phần chữ bên dưới
            Text(
              widget.message,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Lớp vẽ vòng tròn Gradient và dấu chấm đầu
class GradientProgressPainter extends CustomPainter {
  final Color color;
  GradientProgressPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Độ dày của vòng tròn (tăng lên để giống hình mẫu)
    double strokeWidth = 8.0;
    Rect rect = Offset.zero & size;

    Paint paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round; // Bo tròn đầu vòng tròn

    // SweepGradient tạo hiệu ứng mờ dần từ 0% đến 80% vòng đời
    paint.shader = SweepGradient(
      colors: [
        color.withOpacity(0.0), // Đuôi mờ hẳn
        color, // Đầu đậm
      ],
      stops: const [0.0, 0.8], // 0.85 corresponds to 1.7 * pi / 2 * pi
      transform: const GradientRotation(0), // Reset rotation
    ).createShader(rect);

    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      0,
      math.pi * 1.7, // Chiều dài vòng cung (khoảng 3/4 vòng tròn)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
