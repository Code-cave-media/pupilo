import 'package:flutter/material.dart';

import '../../features/screens/dashboard_screen.dart';
import 'forget_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Sign In",
                  style: TextStyle(fontSize: 40),
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 240, 240, 240),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.person, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 240, 240, 240),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFF725E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Direct navigation to dashboard, auth removed
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const Dashboard()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgetPassword()));
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(color: Color(0xFFFF725E)),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(  
                width: double.infinity,
                child: Container(
                  child: ElevatedButton(
                    onPressed: () {
                      // Direct navigation to ProgressiveScreen, auth removed
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const Dashboard()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // Use a Row to align the image and text horizontally
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Wrap content tightly
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center the contents
                      children: [
                        Image.asset(
                          'assets/images/google.png', // Replace with the path to your image
                          height: 30, // Adjust size as needed
                        ),
                        const SizedBox(width: 6),
                        const Padding(
                            padding: EdgeInsets.only(
                                top: 4), // Adjust the top padding as needed
                            child: Text(
                              'Continue with Google',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
