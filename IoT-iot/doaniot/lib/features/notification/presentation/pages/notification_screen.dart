import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notification',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  "assets/setting.svg",
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize:
                    TabBarIndicatorSize.tab, // Ensure indicator fills tab
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primary,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'General'),
                  Tab(text: 'Smart Home'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGeneralNotifications(),
                const Center(child: Text("No Smart Home notifications")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralNotifications() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Today",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ),
        _buildNotificationItem(
          icon: Icons.verified_user_outlined,
          title: "Account Security Alert",
          description:
              "We've noticed some unusual activity on your account. Please review your recent logins...",
          time: "09:41 AM",
          isUnread: true,
          hasLock: true,
        ),
        _buildNotificationItem(
          icon: Icons.info_outlined,
          title: "System Update Available",
          description:
              "A new system update is ready for installation. It includes performance improvements...",
          time: "08:46 AM",
          isUnread: true,
          hasUpdate: true,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Yesterday",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ),
        _buildNotificationItem(
          icon: Icons.lock_outlined,
          title: "Password Reset Successful",
          description:
              "Your password has been successfully reset. If you didn't request this change...",
          time: "20:30 PM",
          isUnread: false,
          isSuccess: true,
        ),
        _buildNotificationItem(
          icon: Icons.star_outline_rounded,
          title: "Exciting New Feature",
          description:
              "We've just launched a new feature that will enhance your user experience...",
          time: "16:29 PM",
          isUnread: false,
          isNew: true,
        ),
      ],
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String description,
    required String time,
    bool isUnread = false,
    bool hasLock = false,
    bool hasUpdate = false,
    bool isSuccess = false,
    bool isNew = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Icon(icon, color: Colors.black87, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (hasLock)
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.lock,
                              size: 16,
                              color: Colors.grey,
                            ),
                          )
                        else if (hasUpdate)
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.sync,
                              size: 16,
                              color: Colors.blue,
                            ),
                          )
                        else if (isSuccess)
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Colors.green,
                            ),
                          )
                        else if (isNew)
                          Container(
                            margin: const EdgeInsets.only(left: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "NEW",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      time,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  if (isUnread)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  const SizedBox(height: 16),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
