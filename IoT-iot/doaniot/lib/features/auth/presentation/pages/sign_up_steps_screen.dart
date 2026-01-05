import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';
// Imports for steps will be added as they are created
import 'package:doaniot/features/auth/presentation/widgets/steps/country_step.dart';
import 'package:doaniot/features/auth/presentation/widgets/steps/home_name_step.dart';
import 'package:doaniot/features/auth/presentation/widgets/steps/add_rooms_step.dart';
import 'package:doaniot/features/auth/presentation/widgets/steps/location_step.dart';
import 'package:doaniot/features/auth/presentation/pages/sign_up_success_screen.dart';

class SignUpStepsScreen extends StatefulWidget {
  const SignUpStepsScreen({super.key});

  @override
  State<SignUpStepsScreen> createState() => _SignUpStepsScreenState();
}

class _SignUpStepsScreenState extends State<SignUpStepsScreen> {
  int _currentStep = 0;
  final int _totalSteps = 4;
  late PageController _pageController;

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

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep++;
      });
    } else {
      // Finish
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpSuccessScreen()),
      );
    }
  }

  void _skipStep() {
    // Similar to next step for now, but maybe with empty data
    _nextStep();
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: _prevStep,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: SizedBox(
          width: 200,
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_currentStep + 1) / _totalSteps,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${_currentStep + 1} / $_totalSteps',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable swipe
                children: [
                  CountryStep(onNext: _nextStep, onSkip: _skipStep),
                  HomeNameStep(onNext: _nextStep, onSkip: _skipStep),
                  AddRoomsStep(onNext: _nextStep, onSkip: _skipStep),
                  LocationStep(onNext: _nextStep, onSkip: _skipStep),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
