import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';

class DataAnalyticsScreen extends StatelessWidget {
  const DataAnalyticsScreen({super.key});

  // Hàm Helper đã được nâng cấp để nhận sự kiện onTap
  Widget _navItem(BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600
                      )
                  ),
                  const SizedBox(height: 8),
                  Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                        height: 1.4,
                      )
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
            'Data & Analytics',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold
            )
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                _navItem(
                  context,
                  title: 'Data Usage',
                  subtitle: 'Control how your data is used for analytics. Customize your preferences.',
                  onTap: () => print("Mở cài đặt sử dụng dữ liệu"),
                ),
                const Divider(height: 24, color: Color(0xFFEEEEEE)),
                _navItem(
                  context,
                  title: 'Ad Preferences',
                  subtitle: 'Manage ad personalization settings. Tailor your ad experience.',
                  onTap: () => print("Mở cài đặt quảng cáo"),
                ),
                const Divider(height: 24, color: Color(0xFFEEEEEE)),
                _navItem(
                  context,
                  title: 'Download My Data',
                  subtitle: 'Request a copy of your data. Your information, your control.',
                  onTap: () => print("Bắt đầu tải dữ liệu"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}