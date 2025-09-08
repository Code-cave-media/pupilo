import 'package:flutter/material.dart';

class PromotionalBanner extends StatelessWidget {
  const PromotionalBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      constraints: const BoxConstraints(
        minHeight: 160,
        maxHeight: 200,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF2D2D2D),
            Color(0xFF4A4A4A),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Paw Print Background Icons
              if (constraints.maxWidth > 300) ...[
                Positioned(
                  top: 20,
                  right: 80,
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(
                      Icons.pets,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right: 120,
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(
                      Icons.pets,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 40,
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(
                      Icons.pets,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              
              // Content
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    // Left side - Text and Button
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Dog Training Made Easy',
                            style: TextStyle(
                              fontSize: constraints.maxWidth > 300 ? 22 : 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6B35),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('Start Training'),
                                SizedBox(width: 8),
                                Icon(Icons.pets, size: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Right side - Image
                    if (constraints.maxWidth > 250)
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            "assets/images/onboarding2.png",
                            height: constraints.maxHeight * 0.7,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
