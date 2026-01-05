import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doaniot/core/theme/app_colors.dart';

class LinkedAccountsScreen extends StatelessWidget {
  const LinkedAccountsScreen({super.key});

  Widget _buildCard({required Widget leading, required String title, required String status, bool connected = false, required BuildContext context}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary))),
          Text(status, style: TextStyle(color: connected ? Colors.grey : Colors.blue, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F5F6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text('Linked Accounts', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              // Google
              _buildCard(
                context: context,
                leading: SvgPicture.asset('assets/ggico.svg', width: 36, height: 36),
                title: 'Google',
                status: 'Connected',
                connected: true,
              ),
              const SizedBox(height: 16),
              // Apple
              _buildCard(
                context: context,
                leading: SvgPicture.asset('assets/apico.svg', width: 36, height: 36),
                title: 'Apple',
                status: 'Connected',
                connected: true,
              ),
              const SizedBox(height: 16),
              // Facebook
              _buildCard(
                context: context,
                leading: SvgPicture.asset('assets/fbico.svg', width: 36, height: 36),
                title: 'Facebook',
                status: 'Connect',
                connected: false,
              ),
              const SizedBox(height: 16),
              // Twitter
              _buildCard(
                context: context,
                leading: SvgPicture.asset('assets/twico.svg', width: 36, height: 36),
                title: 'Twitter',
                status: 'Connect',
                connected: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
