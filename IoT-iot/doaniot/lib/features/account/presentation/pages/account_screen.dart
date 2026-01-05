import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doaniot/core/theme/app_colors.dart';
import 'package:doaniot/features/account/presentation/pages/home_management_screen.dart';
import 'package:doaniot/features/account/presentation/pages/profile_screen.dart';
import 'package:doaniot/features/account/presentation/pages/notifications_screen.dart';
import 'package:doaniot/features/account/presentation/pages/account_security_screen.dart';
import 'package:doaniot/features/account/presentation/pages/linked_accounts_screen.dart';
import 'package:doaniot/features/account/presentation/pages/app_appearance_screen.dart';
import 'package:doaniot/features/account/presentation/pages/additional_settings_screen.dart';
import 'package:doaniot/features/account/presentation/pages/data_analytics_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _selectedHome = "My Home";

  final List<String> _homes = [
    "My Home",
    "My Apartment",
    "My Office",
    "My Parents' House",
    "My Garden",
  ];

  void _showHomeOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Home',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              ..._homes.map(
                (home) => ListTile(
                  title: Text(home),
                  onTap: () {
                    setState(() {
                      _selectedHome = home;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => _showHomeOptions(context),
                      child: Row(
                        children: [
                          Text(
                            _selectedHome,
                            style:
                                Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textPrimary,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(30),
                          child: SvgPicture.asset(
                            'assets/qrscanner.svg',
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              AppColors.textPrimary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(30),
                          child: const Icon(
                            Icons.more_vert,
                            size: 24,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // User Profile Section (tappable -> ProfileScreen)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/user.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // User Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Andrew Ainsley',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'andrew.ainsley@yourdomain.com',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        // Arrow
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // General Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'General',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    // Home Management
                    _buildMenuItem(
                      context,
                      icon: 'assets/home.svg',
                      title: 'Home Management',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeManagementScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    // Voice Assistants
                    _buildMenuItem(
                      context,
                      icon: 'assets/micico.svg',
                      title: 'Voice Assistants',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    // Notifications
                    _buildMenuItem(
                      context,
                      icon: 'assets/bellico.svg',
                      title: 'Notifications',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    // Account & Security
                    _buildMenuItem(
                      context,
                      icon: 'assets/shield.svg',
                      title: 'Account & Security',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccountSecurityScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    // Linked Accounts
                    _buildMenuItem(
                      context,
                      icon: 'assets/link.svg',
                      title: 'Linked Accounts',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LinkedAccountsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    // App Appearance
                    _buildMenuItem(
                      context,
                      icon: 'assets/eye.svg',
                      title: 'App Appearance',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppAppearanceScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    // Additional Settings
                    _buildMenuItem(
                      context,
                      icon: 'assets/setting.svg',
                      title: 'Additional Settings',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdditionalSettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

        // Support Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Support',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Data & Analytics - ĐÃ SỬA ONTAP
                    _buildMenuItem(
                      context,
                      icon: 'assets/chart.svg',
                      title: 'Data & Analytics',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DataAnalyticsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    // Help & Support - CÓ THỂ THÊM ĐIỀU HƯỚNG SAU NÀY
                    _buildMenuItem(
                      context,
                      icon: 'assets/help.svg',
                      title: 'Help & Support',
                      onTap: () {
                        // Bạn có thể thêm Navigator tương tự cho trang Help tại đây
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: InkWell(
                  onTap: () {
                    // Handle logout
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Logout'),
                          content: const Text(
                              'Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                // Perform logout
                              },
                              child: const Text(
                                'Logout',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/logout.svg',
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Colors.red,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Logout',
                        style:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for menu items
  Widget _buildMenuItem(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for divider
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        color: Colors.grey.shade200,
        height: 1,
        thickness: 1,
      ),
    );
  }
}
