import 'package:flutter/material.dart';
import 'package:doaniot/core/theme/app_colors.dart';

class CountryStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const CountryStep({super.key, required this.onNext, required this.onSkip});

  @override
  State<CountryStep> createState() => _CountryStepState();
}

class _CountryStepState extends State<CountryStep> {
  int? _selectedCountryIndex;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _countries = [
    {'name': 'Afghanistan', 'flag': '🇦🇫'},
    {'name': 'Albania', 'flag': '🇦🇱'},
    {'name': 'Algeria', 'flag': '🇩🇿'},
    {'name': 'Andorra', 'flag': '🇦🇩'},
    {'name': 'Angola', 'flag': '🇦🇴'},
    {'name': 'Argentina', 'flag': '🇦🇷'},
    {'name': 'Armenia', 'flag': '🇦🇲'},
    {'name': 'Australia', 'flag': '🇦🇺'},
    {'name': 'United States', 'flag': '🇺🇸'},
    {'name': 'Vietnam', 'flag': '🇻🇳'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        // Title
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Select ',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            children: const [
              TextSpan(
                text: 'Country',
                style: TextStyle(color: AppColors.primary),
              ),
              TextSpan(text: ' of Origin'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Let's start by selecting the country where your smart haven resides.",
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),

        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search Country...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _countries.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final country = _countries[index];
              final isSelected = _selectedCountryIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCountryIndex = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.grey[50],
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        country['flag']!,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          country['name']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check, color: AppColors.primary),
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
                  onPressed: _selectedCountryIndex != null
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
    );
  }
}
