import 'package:flutter/material.dart';

class QuickLogsSection extends StatelessWidget {
  const QuickLogsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Quick Logs',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Quick Logs Horizontal Scroll
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap:
                true, // This is key to centering in a constrained space.
            padding: EdgeInsets.symmetric(
                horizontal: (MediaQuery.of(context).size.width -
                        (4 * 60 + 3 * 20 + 32)) /
                    2),
            itemCount: 4,
            itemBuilder: (context, index) {
              const quickLogs = [
                {
                  'icon': Icons.pets,
                  'label': 'Potty',
                  'color': Color(0xFFFFF2CC)
                },
                {
                  'icon': Icons.directions_walk,
                  'label': 'Walk',
                  'color': Color(0xFFD4EDDA)
                },
                {
                  'icon': Icons.restaurant,
                  'label': 'Meal',
                  'color': Color(0xFFCCE5FF)
                },
                {
                  'icon': Icons.medication,
                  'label': 'Meds',
                  'color': Color(0xFFFFE6E6)
                },
              ];

              return Padding(
                padding: EdgeInsets.only(right: index < 3 ? 20 : 0),
                child: _CategoryButton(
                  icon: quickLogs[index]['icon'] as IconData,
                  label: quickLogs[index]['label'] as String,
                  color: quickLogs[index]['color'] as Color,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _CategoryButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF2D2D2D),
            size: 30,
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
