import 'package:flutter/material.dart';

class DogMoodSection extends StatelessWidget {
  const DogMoodSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dog's Mood Section Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'What\'s the Dog\'s Mood?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Mood Selection
        SizedBox(
          height:
              100, // Increased height to accommodate button + text + spacing
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // This centers the children
            children: [
              _MoodButton(emoji: '😊', label: 'Happy'),
              const SizedBox(width: 20),
              _MoodButton(emoji: '😔', label: 'Tired'),
              const SizedBox(width: 20),
              _MoodButton(emoji: '😠', label: 'Excited'),
              const SizedBox(width: 20),
              _MoodButton(emoji: '😭', label: 'Anxious'),
            ],
          ),
        ),
      ],
    );
  }
}

class _MoodButton extends StatelessWidget {
  final String emoji;
  final String label;

  const _MoodButton({
    required this.emoji,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF2D2D2D),
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
