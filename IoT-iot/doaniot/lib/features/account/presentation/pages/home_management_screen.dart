import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';

class HomeManagementScreen extends StatefulWidget {
  const HomeManagementScreen({super.key});

  @override
  State<HomeManagementScreen> createState() => _HomeManagementScreenState();
}

class _HomeManagementScreenState extends State<HomeManagementScreen> {
  String _selectedHome = "My Home";

  final List<String> _homes = [
    "My Home",
    "My Apartment",
    "My Office",
    "My Parents' House",
    "My Garden",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          'Home Management',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(30),
            child: const Icon(
              Icons.more_vert,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Homes List
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: List.generate(
                    _homes.length,
                    (index) => Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedHome = _homes[index];
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _homes[index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
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
                        ),
                        // Divider
                        if (index < _homes.length - 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Divider(
                              color: Colors.grey.shade200,
                              height: 1,
                              thickness: 1,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Create a Home Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Handle create home
                  },
                  child: Text(
                    'Create a Home',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Join a Home Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  onPressed: () {
                    // Handle join home
                  },
                  child: Text(
                    'Join a Home',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
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
}
