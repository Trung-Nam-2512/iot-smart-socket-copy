import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final Map<String, bool> _options = {
    'Device Status Alerts': true,
    'Energy Consumption Alerts': true,
    'Bill Reminders': true,
    'Automation Updates': false,
    'Device Maintenance Reminders': false,
    'Security Alerts': true,
    'Weather-Based Suggestions': true,
    'Community Updates': false,
    'Home Invitations': true,
    'User Access Alerts': false,
    'Customer Support Updates': false,
    'Feedback & Updates': false,
  };

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
          'Notifications',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          itemCount: _options.length,
          separatorBuilder: (_, __) => const SizedBox(height: 18),
          itemBuilder: (context, index) {
            final key = _options.keys.elementAt(index);
            final value = _options[key]!;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    key,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                  ),
                ),
                Switch.adaptive(
                  value: value,
                  activeColor: Colors.blueAccent,
                  onChanged: (v) {
                    setState(() {
                      _options[key] = v;
                    });
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
