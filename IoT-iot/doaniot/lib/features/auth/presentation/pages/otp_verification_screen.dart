import 'dart:async';
import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';
import 'package:doaniot/features/auth/presentation/pages/create_new_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  // controller cho ô nhập otp
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  Timer? _timer;
  int _secondsRemaining = 59;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _secondsRemaining = 59;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleVerify() async {
    String otp = _controllers.map((c) => c.text).join();

    if (otp.length == 4) {
      // kiểm tra otp
      if (otp == "1111") {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateNewPasswordScreen(),
            ),
          );
        }
      } else {
        // option - nếu sai, xóa trắng các ô và báo lỗi
        if (mounted) {
          for (var controller in _controllers) {
            controller.clear();
          }
          _focusNodes[0].requestFocus();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'The code you entered is incorrect. Please try again.',
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      // di chuyển đến ô tiếp theo
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // cuối cùng, unfocus
        // thực hiện kiểm tra otp
        _focusNodes[index].unfocus();
        _handleVerify();
      }
    } else {
      // di chuyển đến ô trước
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
    setState(() {});
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Enter OTP Code 🔐',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  text:
                      'Please check your email inbox for a message from Smartify. Enter the one-time verification code below.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 4-digit row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 60,
                    height: 60,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.inputBorder,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.inputBorder,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      onChanged: (value) => _onChanged(value, index),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 32),

              // resend timer
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'You can resend the code in ',
                    style: const TextStyle(color: AppColors.textSecondary),
                    children: [
                      TextSpan(
                        text: '$_secondsRemaining seconds',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: _secondsRemaining == 0
                      ? () {
                          startTimer();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('OTP code resent!')),
                          );
                        }
                      : null,
                  child: Text(
                    'Resend code',
                    style: TextStyle(
                      color: _secondsRemaining == 0
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // verify button
              ElevatedButton(
                onPressed: _handleVerify,
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
                  'Verify',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
