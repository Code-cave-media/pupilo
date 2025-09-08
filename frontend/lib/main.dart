import 'package:flutter/material.dart';
import 'features/screens/dashboard_screen.dart';

void main() {
  runApp(const Pupilo());
}

class Pupilo extends StatelessWidget {
  const Pupilo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );
  }
}
