import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';
import 'package:doaniot/features/home/presentation/pages/main_screen.dart';

class SignUpSuccessScreen extends StatelessWidget {
  const SignUpSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  // Blue circle
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3D61FF), // Blue color
                      shape: BoxShape.circle,
                      // Add simple shadow or glow if needed
                    ),
                  ),
                  // Check icon
                  const Icon(Icons.check, color: Colors.white, size: 48),

                  // Simple Decorative dots (simulating the confetti/particles in design)
                  // Top Left
                  const Positioned(
                    top: 0,
                    left: 10,
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: Color(0xFF3D61FF),
                    ),
                  ),
                  const Positioned(
                    top: 30,
                    left: -10,
                    child: CircleAvatar(
                      radius: 3,
                      backgroundColor: Color(0xFF3D61FF),
                    ),
                  ),
                  // Top Right
                  const Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: Color(0xFF3D61FF),
                    ),
                  ),
                  // Bottom
                  const Positioned(
                    bottom: 10,
                    left: 20,
                    child: CircleAvatar(
                      radius: 3,
                      backgroundColor: Color(0xFF3D61FF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Text(
                'Well Done!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Congratulations! Your home is now a Smartify haven. Start exploring and managing your smart space with ease.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Dashboard or Home
                  // Navigator.pushAndRemoveUntil...
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
