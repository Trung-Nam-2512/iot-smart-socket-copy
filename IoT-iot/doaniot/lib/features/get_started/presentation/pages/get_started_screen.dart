import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';
import 'package:doaniot/core/constants/app_constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:doaniot/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:doaniot/features/auth/presentation/pages/sign_in_screen.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Logo
              Image.asset("assets/logo2.png", width: 100),

              const SizedBox(height: 24),
              Text(
                AppConstants.getStartedTitle,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                AppConstants.getStartedSubtitle,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),

              // Social Buttons
              _socialButton(
                context,
                'Continue with Google',
                SvgPicture.asset("assets/ggico.svg", width: 24, height: 24),
              ),
              const SizedBox(height: 16),
              _socialButton(
                context,
                'Continue with Apple',
                SvgPicture.asset("assets/apico.svg", width: 24, height: 24),
              ),
              const SizedBox(height: 16),
              _socialButton(
                context,
                'Continue with Facebook',
                SvgPicture.asset("assets/fbico.svg", width: 24, height: 24),
              ),
              const SizedBox(height: 16),
              _socialButton(
                context,
                'Continue with Twitter',
                SvgPicture.asset("assets/twico.svg", width: 24, height: 24),
              ),

              const SizedBox(height: 40),

              // Primary Actions
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
                child: const Text('Sign up'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: const Text('Sign in'),
              ),
              const SizedBox(height: 24),

              const Text(
                'Privacy Policy · Terms of Service',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton(BuildContext context, String text, SvgPicture icon) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(
          double.infinity,
          56,
        ), // Tăng nhẹ chiều cao cho thoáng
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        side: const BorderSide(color: AppColors.socialButtonBorder),
        // Quan trọng: Đặt padding để icon không dính sát mép viền ngoài
        padding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      // Sử dụng Stack để chồng các lớp widget lên nhau
      child: Stack(
        children: [
          // 1. Icon neo ở bên trái (Start/Leading)
          Align(alignment: Alignment.centerLeft, child: icon),

          // 2. Text nằm chính giữa nút
          Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
