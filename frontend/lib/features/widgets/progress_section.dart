import 'package:flutter/material.dart';

class ProgressSection extends StatelessWidget {
  const ProgressSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress Section Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Progress Card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dog Training Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your pup is learning well! 🐕',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8B8B8B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Circular Progress Indicator
              SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  alignment: Alignment
                      .center, // This ensures both children are centered
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: 0.7,
                        strokeWidth: 6,
                        backgroundColor: const Color(0xFFE5E5E5),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFFF6B35)),
                      ),
                    ),
                    const Text(
                      '70%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
