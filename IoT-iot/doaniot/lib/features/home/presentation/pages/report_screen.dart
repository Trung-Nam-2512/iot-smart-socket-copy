import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';
import 'package:doaniot/features/device/domain/entities/device.dart';
import 'package:doaniot/features/device/data/repositories/mock_device_repository.dart';
import 'package:doaniot/features/device/domain/repositories/device_repository.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final DeviceRepository _deviceRepository = MockDeviceRepository();
  List<Device> _devices = [];
  double _totalEnergy = 0.0;
  double _totalCost = 0.0;
  final double _costPerKwh = 0.15; // currency unit per kWh

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final devices = await _deviceRepository.getDevices();
    double sum = 0;
    for (var d in devices) {
      sum += d.totalEnergy;
    }
    if (mounted) {
      setState(() {
        _devices = devices;
        _totalEnergy = sum;
        _totalCost = sum * _costPerKwh;
      });
    }
  }

  Widget _summaryCard(BuildContext context, IconData icon, Color iconColor, String title, String value, String sub) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(sub, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _statisticsCard(BuildContext context) {
    final data = [0.65, 0.75, 0.85, 0.95, 1.0, 0.72];
    final labels = ['Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Statistics', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(24)),
                child: const Row(children: [Text('Last 6 Months'), SizedBox(width: 8), Icon(Icons.keyboard_arrow_down, size: 18)]),
              )
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F1F1)),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: CustomPaint(
              painter: BarChartPainter(
                data: data,
                labels: labels,
                selectedIndex: 3,
                primaryColor: AppColors.primary,
                textColor: AppColors.textSecondary,
              ),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _deviceCardWithImage(BuildContext context, Device device) {
     final cost = device.totalEnergy * _costPerKwh;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                child: Image.asset(device.imageUrl, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    children: [
                      Expanded(child: Text("${device.totalEnergy.toStringAsFixed(2)} kWh", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      const SizedBox(width: 8),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text("\$${cost.toStringAsFixed(2)}", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                ]),
              )
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFEFEFEF), height: 1, thickness: 1),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Text(device.name, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary)
          ]),
          const SizedBox(height: 6),
          // Showing Power as subtitle
          Text("${device.currentPower} W", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    // ignore: deprecated_member_use
    final clampedScale = mq.textScaleFactor > 1.15 ? 1.15 : mq.textScaleFactor;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: MediaQuery(
          // ignore: deprecated_member_use
          data: mq.copyWith(textScaleFactor: clampedScale),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(children: [Text('My Home', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)), const SizedBox(width: 8), const Icon(Icons.keyboard_arrow_down_rounded)]),
                  Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)), child: const Icon(Icons.calendar_today)), const SizedBox(width: 8), Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)), child: const Icon(Icons.more_vert))])
                ]),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: _summaryCard(context, Icons.flash_on, const Color(0xFFFFA500), 'This month', '${_totalEnergy.toStringAsFixed(2)} kWh', '\$${_totalCost.toStringAsFixed(2)}')), 
                  const SizedBox(width: 12), 
                  // Placeholder for previous month
                  Expanded(child: _summaryCard(context, Icons.power_settings_new, AppColors.primary, 'Previous month', '958.75 kWh', '\$143.81'))
                ]),
                const SizedBox(height: 16),
                _statisticsCard(context),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Devices', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)), const Icon(Icons.more_vert, color: AppColors.textSecondary)]),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, mainAxisExtent: 170),
                  itemCount: _devices.length,
                  itemBuilder: (context, index) {
                    final device = _devices[index];
                    return _deviceCardWithImage(context, device);
                  },
                ),
                const SizedBox(height: 40)
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final int selectedIndex;
  final Color primaryColor;
  final Color textColor;

  BarChartPainter({
    required this.data,
    required this.labels,
    required this.selectedIndex,
    required this.primaryColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = 28.0;
    final maxBarHeight = 140.0;
    // Tăng baseY lên để có không gian vẽ nhãn tháng
    final baseY = size.height - 40;
    final spacing = (size.width - (barWidth * data.length)) / (data.length + 1);

    for (int i = 0; i < data.length; i++) {
      final barHeight = data[i] * maxBarHeight;
      final x = spacing + (i * (barWidth + spacing));
      final y = baseY - barHeight;

      final isSelected = i == selectedIndex;
      final color = isSelected ? primaryColor : primaryColor.withOpacity(0.3);

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        const Radius.circular(6),
      );

      canvas.drawRRect(rect, Paint()..color = color);

      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w500),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x + (barWidth - textPainter.width) / 2, baseY + 15));

      if (isSelected) {
        final circleCenterX = x + barWidth / 2;
        const circleRadius = 24.0;
        // SỬA TẠI ĐÂY: Vị trí Y của vòng tròn tính từ đỉnh cột y đi lên 25 đơn vị
        final circleCenterY = y - 30;

        // Vẽ vòng tròn
        canvas.drawCircle(
          Offset(circleCenterX, circleCenterY),
          circleRadius,
          Paint()..color = primaryColor..strokeWidth = 2..style = PaintingStyle.stroke,
        );

        // Vẽ con số bên trong vòng tròn
        final circlePainter = TextPainter(
          text: TextSpan(
            text: '785.48',
            style: TextStyle(color: primaryColor, fontSize: 9, fontWeight: FontWeight.bold),
          ),
          textDirection: TextDirection.ltr,
        );
        circlePainter.layout();
        circlePainter.paint(
          canvas,
          Offset(circleCenterX - circlePainter.width / 2, circleCenterY - circlePainter.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(BarChartPainter oldDelegate) => true;
}