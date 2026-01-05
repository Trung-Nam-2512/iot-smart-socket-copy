import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';
import 'package:doaniot/features/home/presentation/pages/home_screen.dart';
import 'package:doaniot/features/home/presentation/pages/smart_home_screen.dart';
import 'package:doaniot/features/home/presentation/pages/report_screen.dart';
import 'package:doaniot/features/account/presentation/pages/account_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SmartHomeScreen(),
    const ReportScreen(),
    const AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/home.svg",
              colorFilter: const ColorFilter.mode(
                AppColors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/home.svg",
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/check.svg",
              colorFilter: const ColorFilter.mode(
                AppColors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/check.svg",
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
            label: 'Smart',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/chart.svg",
              colorFilter: const ColorFilter.mode(
                AppColors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/chart.svg",
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/user.svg",
              colorFilter: const ColorFilter.mode(
                AppColors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/user.svg",
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 10,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}
