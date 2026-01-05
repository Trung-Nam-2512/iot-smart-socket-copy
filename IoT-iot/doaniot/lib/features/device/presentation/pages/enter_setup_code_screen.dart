import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';
import 'package:doaniot/features/device/domain/entities/device.dart';
import 'package:doaniot/features/device/presentation/pages/connect_device_screen.dart';
import 'package:doaniot/core/presentation/widgets/loading_dialog.dart';

class EnterSetupCodeScreen extends StatefulWidget {
  const EnterSetupCodeScreen({super.key});

  @override
  State<EnterSetupCodeScreen> createState() => _EnterSetupCodeScreenState();
}

class _EnterSetupCodeScreenState extends State<EnterSetupCodeScreen> {
  final TextEditingController _codeController = TextEditingController();

  Future<void> _handleNext() async {
    // Show Processing Dialog using shared widget
    LoadingDialog.show(context, message: 'Processing...');

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Close dialog
    LoadingDialog.hide(context);

    // Navigate to ConnectDeviceScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConnectDeviceScreen(
          device: Device(
            id: 'setup_device',
            name: "Smart Device",
            type: 'wifi',
            imageUrl: "assets/wifi.png",
          ),
        ),
      ),
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
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Enter setup code',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter the 8-digit code found on the device or in the manual.",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextField(
              maxLength: 8,
              decoration: InputDecoration(
                hintText: "Enter code",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _handleNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
