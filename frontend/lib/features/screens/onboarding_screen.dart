import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../auth/screens/login.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => isLastPage = (index == 2));
            },
            children: [
              buildPage(
                title: "Unlock Your Dog's World",
                description:
                    "Ever wonder what your dog is trying to tell you? Pupilo AI helps you understand their unique need",
                image: "assets/images/onboarding1.png",
              ),
              buildPage(
                title: "Track Their Mood in Real-Time",
                description:
                    "With our real-time emotion detection, you'll know when your furry friend is happy, anxious, or needs attention.",
                image: "assets/images/onboarding2.png",
              ),
              buildPage(
                title: "AI Insights for Better Care",
                description:
                    "Get personalized tips from our AI to improve your dog’s lifestyle, behavior, and overall well-being.",
                image: "assets/images/onboarding3.png",
              ),
            ],
          ),
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text(
                "Skip",
                style: TextStyle(
                  color: Color.fromARGB(255, 226, 50, 50),
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotColor: const Color(0xFFFF725E),
                    dotColor: Colors.grey,
                  ),
                ),
                isLastPage
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF725E),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                        ),
                        child: const Text(
                          "Get Started",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF725E),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                        ),
                        child: const Icon(Icons.arrow_forward,
                            color: Colors.white),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage(
      {required String title,
      required String description,
      required String image}) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 250),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
