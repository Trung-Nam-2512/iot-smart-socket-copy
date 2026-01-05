import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';

class AddRoomsStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const AddRoomsStep({super.key, required this.onNext, required this.onSkip});

  @override
  State<AddRoomsStep> createState() => _AddRoomsStepState();
}

class _AddRoomsStepState extends State<AddRoomsStep> {
  final List<Map<String, dynamic>> _rooms = [
    {'name': 'Living Room', 'icon': Icons.weekend_outlined},
    {'name': 'Bedroom', 'icon': Icons.bed_outlined},
    {'name': 'Bathroom', 'icon': Icons.bathtub_outlined},
    {'name': 'Kitchen', 'icon': Icons.kitchen_outlined},
    {'name': 'Study Room', 'icon': Icons.school_outlined},
    {'name': 'Dining Room', 'icon': Icons.restaurant_outlined},
    {'name': 'Backyard', 'icon': Icons.deck_outlined},
    {'name': 'Add Room', 'icon': Icons.add_circle_outline},
  ];

  final Set<int> _selectedRooms = {};

  @override
  Widget build(BuildContext context) {
    return Column(
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
                text: 'Rooms',
                style: TextStyle(color: AppColors.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Select the rooms in your house. Don't worry, you can always add more later.",
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),

        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
            ),
            itemCount: _rooms.length,
            itemBuilder: (context, index) {
              final room = _rooms[index];
              final isSelected = _selectedRooms.contains(index);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedRooms.remove(index);
                    } else {
                      _selectedRooms.add(index);
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Or a slightly off-white if needed
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey[200]!, // Subtle border
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              room['icon'],
                              size: 32,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              room['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Positioned(
                          top: 8,
                          right: 8,
                          child: Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Bottom Actions
        Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onSkip,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
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
                  onPressed: widget
                      .onNext, // Always enabled as user can select 0 rooms
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
    );
  }
}
