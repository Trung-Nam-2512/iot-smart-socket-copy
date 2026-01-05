import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doaniot/core/theme/app_colors.dart';
import 'package:doaniot/features/onboarding/domain/models/onboarding_content.dart';
import 'package:doaniot/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:doaniot/features/get_started/presentation/pages/get_started_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slides = OnboardingContent.slides;

    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: BlocBuilder<OnboardingCubit, int>(
          builder: (context, state) {
            return Stack(
              children: [
                // 1. PAGE VIEW
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) =>
                      context.read<OnboardingCubit>().pageChanged(index),
                  itemCount: slides.length,
                  itemBuilder: (context, index) {
                    return _buildOnboardingItem(slides[index]);
                  },
                ),

                // 2. BOTTOM CONTROL
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Dots Indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            slides.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 6,
                              width: state == index ? 24 : 6,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: state == index
                                    ? AppColors.primary
                                    : Colors.grey.withOpacity(0.3),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Buttons
                        if (state == slides.length - 1)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5,
                              ),
                              onPressed: () => _navigateToHome(context),
                              child: const Text(
                                "Let's Get Started",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        else
                          Row(
                            children: [
                              // NÚT SKIP (Đã chỉnh sửa: Có viền)
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: AppColors.primary,
                                    ), // Viền xanh
                                    backgroundColor: Colors.white, // Nền trắng
                                    foregroundColor:
                                        AppColors.primary, // Chữ xanh
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: () => _pageController.jumpToPage(
                                    slides.length - 1,
                                  ),
                                  child: const Text(
                                    'Skip',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // NÚT CONTINUE
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 5,
                                  ),
                                  onPressed: () => _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  ),
                                  child: const Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Widget xây dựng từng slide (Đã chỉnh sửa vị trí)
  Widget _buildOnboardingItem(OnboardingContent content) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            // Lớp 1: Hình ảnh điện thoại
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              left: 20,
              right: 20,
              // Đẩy bottom cao lên để hình ảnh không bị chìm quá sâu
              bottom: constraints.maxHeight * 0.45,
              child: Image.asset(content.imagePath, fit: BoxFit.contain),
            ),

            // Lớp 2: Phần nền trắng cong
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              // Giảm chiều cao xuống còn khoảng 52% màn hình (thay vì 60% như cũ)
              // Điều này làm cho đường cong bắt đầu thấp hơn
              height: constraints.maxHeight * 0.52,
              child: ClipPath(
                clipper: CurveClipper(),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(
                    top: 80, // Giữ khoảng cách text với đường cong
                    left: 32,
                    right: 32,
                    bottom: 100, // Chừa chỗ cho nút bấm
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        content.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        content.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const GetStartedScreen()),
    );
  }
}

// Class tạo đường cong lõm
class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Bắt đầu từ đỉnh trái
    path.moveTo(0, 0);

    // Vẽ đường cong lõm xuống (Valley)
    // Điểm điều khiển (control point) ở giữa chiều ngang
    // y = 60 là độ sâu của đường cong. Giảm số này nếu muốn cong ít hơn.
    path.quadraticBezierTo(size.width / 2, 60, size.width, 0);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
