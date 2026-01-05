import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';

class HomeNameStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const HomeNameStep({super.key, required this.onNext, required this.onSkip});

  @override
  State<HomeNameStep> createState() => _HomeNameStepState();
}

class _HomeNameStepState extends State<HomeNameStep> {
  final TextEditingController _homeNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Add ',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              children: const [
                TextSpan(
                  text: 'Home',
                  style: TextStyle(color: AppColors.primary),
                ),
                TextSpan(text: ' Name'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Every smart home needs a name. What would you like to call yours?",
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),

          TextField(
            controller: _homeNameController,
            decoration: InputDecoration(
              hintText: 'My Home',
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
            ),
            onChanged: (value) => setState(() {}),
          ),

          const Spacer(),
          // Bottom Actions
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onSkip,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF3F5F7),
                      foregroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _homeNameController.text.isNotEmpty
                        ? widget.onNext
                        : null,
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
                      'Continue',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
