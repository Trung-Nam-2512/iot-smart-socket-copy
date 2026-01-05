import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';

class SmartHomeScreen extends StatefulWidget {
  const SmartHomeScreen({super.key});

  @override
  State<SmartHomeScreen> createState() => _SmartHomeScreenState();
}

class _SmartHomeScreenState extends State<SmartHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedHome = "My Home";

  final List<String> _homes = [
    "My Home",
    "My Apartment",
    "My Office",
    "My Parents' House",
    "My Garden",
  ];

  // Automation items with toggle state
  final List<AutomationItem> automationItems = [
    AutomationItem(
      title: 'Turn ON All the Lights',
      taskCount: 1,
      isEnabled: true,
      color: Colors.blue.shade500,
      icon: Icons.light_mode,
    ),
    AutomationItem(
      title: 'Go to Office',
      taskCount: 2,
      isEnabled: true,
      color: Colors.orange.shade400,
      icon: Icons.place,
    ),
    AutomationItem(
      title: 'Energy Saver Mode',
      taskCount: 2,
      isEnabled: false,
      color: Colors.green.shade400,
      icon: Icons.battery_saver,
    ),
    AutomationItem(
      title: 'Work Mode Activate',
      taskCount: 1,
      isEnabled: true,
      color: Colors.purple.shade400,
      icon: Icons.work,
    ),
    AutomationItem(
      title: 'Night Time Bliss',
      taskCount: 3,
      isEnabled: false,
      color: Colors.indigo.shade400,
      icon: Icons.nights_stay,
    ),
  ];

  // Tap-to-Run items
  final List<TapToRunItem> tapToRunItems = [
    TapToRunItem(
      title: 'Bedtime Prep',
      taskCount: 2,
      color: Color(0xFF5B7AF6),
      icon: Icons.bedtime,
    ),
    TapToRunItem(
      title: 'Evening Chill',
      taskCount: 4,
      color: Color(0xFF6FCC7D),
      icon: Icons.cloud,
    ),
    TapToRunItem(
      title: 'Boost Productivity',
      taskCount: 1,
      color: Color(0xFFC74ADA),
      icon: Icons.trending_up,
    ),
    TapToRunItem(
      title: 'Get Energized',
      taskCount: 3,
      color: Color(0xFFFF5F5F),
      icon: Icons.local_fire_department,
    ),
    TapToRunItem(
      title: 'Home Office',
      taskCount: 2,
      color: Color(0xFF1BC4A6),
      icon: Icons.home_work,
    ),
    TapToRunItem(
      title: 'Reading Corner',
      taskCount: 4,
      color: Color(0xFF6B5345),
      icon: Icons.book,
    ),
    TapToRunItem(
      title: 'Outdoor Party',
      taskCount: 3,
      color: Color(0xFF5A7A8A),
      icon: Icons.celebration,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _showHomeOptions(context),
                    child: Row(
                      children: [
                        Text(
                          _selectedHome,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                        child: const Icon(
                          Icons.description,
                          size: 24,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(30),
                        child: const Icon(
                          Icons.dashboard_customize,
                          size: 24,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Tab Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // Make the indicator fill the whole tab and remove extra padding
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.symmetric(vertical: 12),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey.shade600,
                  tabs: const [
                    Tab(text: 'Automation'),
                    Tab(text: 'Tap-to-Run'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Automation Tab
                  _buildAutomationTab(),
                  // Tap-to-Run Tab
                  _buildTapToRunTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build Automation Tab
  Widget _buildAutomationTab() {
    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        itemCount: automationItems.length,
        itemBuilder: (context, index) {
          final item = automationItems[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Leading icon circle
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item.icon,
                      color: item.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${item.taskCount} task${item.taskCount > 1 ? 's' : ''}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.scale(
                    scale: 0.9,
                    child: Switch(
                      value: item.isEnabled,
                      onChanged: (value) {
                        setState(() {
                          automationItems[index].isEnabled = value;
                        });
                      },
                      activeColor: AppColors.primary,
                      inactiveTrackColor: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Build Tap-to-Run Tab
  Widget _buildTapToRunTab() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: tapToRunItems.length,
      itemBuilder: (context, index) {
        final item = tapToRunItems[index];
        return GestureDetector(
          onTap: () {
            // Handle tap
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${item.title} tapped!')),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.icon,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${item.taskCount} task${item.taskCount > 1 ? 's' : ''}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Models
class AutomationItem {
  final String title;
  final int taskCount;
  bool isEnabled;
  final Color color;
  final IconData icon;

  AutomationItem({
    required this.title,
    required this.taskCount,
    required this.isEnabled,
    required this.color,
    required this.icon,
  });
}

class TapToRunItem {
  final String title;
  final int taskCount;
  final Color color;
  final IconData icon;

  TapToRunItem({
    required this.title,
    required this.taskCount,
    required this.color,
    required this.icon,
  });
}
