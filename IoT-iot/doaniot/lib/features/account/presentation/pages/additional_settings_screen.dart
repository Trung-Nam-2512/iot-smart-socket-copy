import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';

class AdditionalSettingsScreen extends StatefulWidget {
  const AdditionalSettingsScreen({super.key});

  @override
  State<AdditionalSettingsScreen> createState() => _AdditionalSettingsScreenState();
}

class _AdditionalSettingsScreenState extends State<AdditionalSettingsScreen> {
  String _tempUnit = 'Celsius';
  String _cacheSize = '15.6 MB';

  Widget _navRow(String title, {String? subtitle, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary))),
            if (subtitle != null) Text(subtitle, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary)),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _selectTempUnit() async {
    final sel = await showModalBottomSheet<String>(
      context: context,
      builder: (c) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: const Text('Celsius'), onTap: () => Navigator.pop(c, 'Celsius')),
          ListTile(title: const Text('Fahrenheit'), onTap: () => Navigator.pop(c, 'Fahrenheit')),
        ],
      ),
    );
    if (sel != null) setState(() => _tempUnit = sel);
  }

  void _clearCache() {
    // Simulate clearing cache
    setState(() => _cacheSize = '0.0 MB');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache cleared')));
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
        title: Text('Additional Settings', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              _navRow('Temperature Units', subtitle: _tempUnit, onTap: _selectTempUnit),
              const SizedBox(height: 8),
              _navRow('Clear Cache', subtitle: _cacheSize, onTap: _clearCache),
              const SizedBox(height: 8),
              _navRow('Experimental Features'),
              const SizedBox(height: 8),
              _navRow('System Permissions'),
              const SizedBox(height: 8),
              _navRow('Legal Information'),
              const SizedBox(height: 8),
              _navRow('Check for Updates'),
            ],
          ),
        ),
      ),
    );
  }
}
