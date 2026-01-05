import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';

class AppAppearanceScreen extends StatefulWidget {
  const AppAppearanceScreen({super.key});

  @override
  State<AppAppearanceScreen> createState() => _AppAppearanceScreenState();
}

class _AppAppearanceScreenState extends State<AppAppearanceScreen> {
  String _theme = 'Light';
  String _language = 'English (US)';

  Widget _row(String title, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary)),
            Row(
              children: [
                Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary)),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectTheme() async {
    final sel = await showModalBottomSheet<String>(
      context: context,
      builder: (c) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: const Text('Light'), onTap: () => Navigator.pop(c, 'Light')),
          ListTile(title: const Text('Dark'), onTap: () => Navigator.pop(c, 'Dark')),
          ListTile(title: const Text('System'), onTap: () => Navigator.pop(c, 'System')),
        ],
      ),
    );
    if (sel != null) setState(() => _theme = sel);
  }

  Future<void> _selectLanguage() async {
    final sel = await showModalBottomSheet<String>(
      context: context,
      builder: (c) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: const Text('English (US)'), onTap: () => Navigator.pop(c, 'English (US)')),
          ListTile(title: const Text('Vietnamese'), onTap: () => Navigator.pop(c, 'Vietnamese')),
        ],
      ),
    );
    if (sel != null) setState(() => _language = sel);
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
        title: Text('App Appearance', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              _row('Theme', _theme, _selectTheme),
              const SizedBox(height: 8),
              _row('App Language', _language, _selectLanguage),
            ],
          ),
        ),
      ),
    );
  }
}
