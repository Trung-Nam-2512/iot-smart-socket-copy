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
    // Giả sử OnboardingContent.slides có trường 'image' là đường dẫn ảnh (vd: assets/ob1.png)
    final slides = OnboardingContent.slides;

    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: Scaffold(
        // Nền xanh chủ đạo bao trùm toàn màn hình
        backgroundColor: AppColors.primary,
        body: BlocBuilder<OnboardingCubit, int>(
          builder: (context, state) {
            return Stack(
              children: [
                // 1. PAGE VIEW: Chứa toàn bộ nội dung (Ảnh + Nền trắng + Chữ)
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) =>
                      context.read<OnboardingCubit>().pageChanged(index),
                  itemCount: slides.length,
                  itemBuilder: (context, index) {
                    return _buildOnboardingItem(slides[index]);
                  },
                ),

                // 2. BOTTOM CONTROL: Dấu chấm và Nút bấm (Nằm cố định phía dưới)
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
                                shadowColor: AppColors.primary.withOpacity(0.4),
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
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _pageController.jumpToPage(
                                    slides.length - 1,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondary,
                                    foregroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    shadowColor: AppColors.primary.withOpacity(
                                      0.4,
                                    ),
                                  ),
                                  child: Text(
                                    'Skip',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
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
                                    shadowColor: AppColors.primary.withOpacity(
                                      0.4,
                                    ),
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

  // Widget xây dựng từng slide
  Widget _buildOnboardingItem(OnboardingContent content) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            // Lớp 1: Hình ảnh điện thoại (Nằm phía trên, lùi xuống một chút để hở nền xanh)
            Positioned(
              top: MediaQuery.of(context).padding.top + 20, // Cách top an toàn
              left: 20,
              right: 20,
              bottom:
                  constraints.maxHeight *
                  0.2, // Chiếm nhiều diện tích hơn để che phần dưới
              child: Image.asset(
                content
                    .imagePath, // Đảm bảo assets có hình này (vd: assets/ob1.png)
                fit: BoxFit.contain,
              ),
            ),

            // Lớp 2: Phần nền trắng cong cắt vào hình (Nằm phía dưới)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: constraints.maxHeight * 0.5, // Tăng chiều cao nền trắng
              child: ClipPath(
                clipper: CurveClipper(), // Clipper tạo hình cong
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(
                    top: 100, // Tăng padding để text không bị che
                    left: 32,
                    right: 32,
                    bottom: 80,
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

// Class tạo đường cong lõm xuống (như cái bát) ở cạnh trên
class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Bắt đầu từ đỉnh trái (0,0)
    path.moveTo(0, 0);

    // Tạo đường cong Bezier lõm xuống (Valley)
    // Điểm kết thúc ở đỉnh phải (size.width, 0)
    // Điểm điều khiển ở giữa và hạ thấp xuống (ví dụ 80px)
    path.quadraticBezierTo(size.width / 2, 80, size.width, 0);

    // Vẽ tiếp xuống đáy phải
    path.lineTo(size.width, size.height);
    // Vẽ sang đáy trái
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
