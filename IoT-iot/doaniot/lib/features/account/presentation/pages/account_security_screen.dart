import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  final Map<String, bool> _toggles = {
    'Biometric ID': false,
    'Face ID': false,
    'SMS Authenticator': false,
    'Google Authenticator': false,
  };

  Widget _buildToggle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
          ),
        ),
        Switch.adaptive(
          value: _toggles[title]!,
          onChanged: (v) => setState(() => _toggles[title] = v),
        ),
      ],
    );
  }

  Widget _buildNavItem({required String title, String? subtitle, bool destructive = false}) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: destructive ? Colors.red : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
            ]
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
        title: Text('Account & Security', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildToggle('Biometric ID'),
              const SizedBox(height: 12),
              _buildToggle('Face ID'),
              const SizedBox(height: 12),
              _buildToggle('SMS Authenticator'),
              const SizedBox(height: 12),
              _buildToggle('Google Authenticator'),
              const SizedBox(height: 24),
              _buildNavItem(title: 'Change Password'),
              const SizedBox(height: 12),
              _buildNavItem(title: 'Device Management', subtitle: 'Manage your account on the various devices you own.'),
              const SizedBox(height: 12),
              _buildNavItem(title: 'Deactivate Account', subtitle: "Temporarily deactivate your account. Easily reactivate when you're ready."),
              const SizedBox(height: 12),
              _buildNavItem(title: 'Delete Account', subtitle: 'Permanently remove your account and data. Proceed with caution.', destructive: true),
            ],
          ),
        ),
      ),
    );
  }
}
