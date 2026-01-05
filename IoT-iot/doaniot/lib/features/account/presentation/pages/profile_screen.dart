import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String gender = 'Male';

  Widget _infoField({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
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
        title: Text(
          'My Profile',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: AssetImage('assets/user.png'),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () {
                          // TODO: open image picker
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Full Name
              Text('Full Name', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _infoField(
                child: Text('Andrew Ainsley', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary)),
              ),
              const SizedBox(height: 20),

              // Email
              Text('Email', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _infoField(
                child: Row(
                  children: [
                    const Icon(Icons.email_outlined, color: Colors.black54),
                    const SizedBox(width: 12),
                    Expanded(child: Text('andrew.ainsley@yourdomain.com', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary))),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Phone Number
              Text('Phone Number', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _infoField(
                child: Row(
                  children: [
                    // placeholder flag
                    Container(
                      width: 28,
                      height: 18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.grey.shade300,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                    const SizedBox(width: 12),
                    Expanded(child: Text('+1 111 467 378 399', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary))),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Gender
              Text('Gender', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final selected = await showModalBottomSheet<String>(
                    context: context,
                    builder: (c) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(title: const Text('Male'), onTap: () => Navigator.pop(c, 'Male')),
                        ListTile(title: const Text('Female'), onTap: () => Navigator.pop(c, 'Female')),
                        ListTile(title: const Text('Other'), onTap: () => Navigator.pop(c, 'Other')),
                      ],
                    ),
                  );
                  if (selected != null) setState(() => gender = selected);
                },
                child: _infoField(
                  child: Row(
                    children: [
                      Expanded(child: Text(gender, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary))),
                      const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Birthdate
              Text('Birthdate', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime(1995, 12, 25),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  // TODO: save selected date
                },
                child: _infoField(
                  child: Row(
                    children: [
                      Expanded(child: Text('12/25/1995', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary))),
                      const Icon(Icons.calendar_today_outlined, color: Colors.black54),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
