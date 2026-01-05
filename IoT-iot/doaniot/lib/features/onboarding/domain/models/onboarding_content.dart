import 'package:doaniot/core/constants/app_constants.dart';

class OnboardingContent {
  final String title;
  final String description;
  final String imagePath;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  static List<OnboardingContent> get slides => [
    OnboardingContent(
      title: AppConstants.onboardingTitle1,
      description: AppConstants.onboardingDesc1,
      imagePath: 'assets/ob1.png',
    ),
    OnboardingContent(
      title: AppConstants.onboardingTitle2,
      description: AppConstants.onboardingDesc2,
      imagePath: 'assets/ob2.png',
    ),
    OnboardingContent(
      title: AppConstants.onboardingTitle3,
      description: AppConstants.onboardingDesc3,
      imagePath: 'assets/ob3.png',
    ),
  ];
}
