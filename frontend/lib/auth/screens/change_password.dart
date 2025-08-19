import 'package:flutter/material.dart';
import '../../../auth/screens/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ChangePassword extends StatefulWidget {
  final String email;
  const ChangePassword({super.key, required this.email});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _isResendEnabled = true;
  bool _isLoading = false;
  int _countdown = 60;
  Timer? _timer;
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final String _baseUrl =
      'https://gem-know-server.onrender.com'; // Replace with your actual base URL

  @override
  void initState() {
    super.initState();
    _sendOtp(); // Send OTP when the screen loads
  }

  String maskEmail(String email) {
    if (email.length < 5) return email;
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final localPart = parts[0];
    final domain = parts[1];
    if (localPart.length <= 3) return email;
    return '${localPart.substring(0, 2)}${'*' * (localPart.length - 2)}@$domain';
  }

  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/otp/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending OTP: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isResendEnabled = false;
      _countdown = 60;
      _otpControllers.forEach((controller) => controller.clear());
    });

    await _sendOtp();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _isResendEnabled = true;
          timer.cancel();
        }
      });
    });
  }

  Future<void> _verifyOtp() async {
    final otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length == 6 && RegExp(r'^\d{6}$').hasMatch(otp)) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/api/v1/otp/verify-otp'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': widget.email, 'otp': otp}),
        );

        if (response.statusCode == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPassword(email: widget.email),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('OTP verification failed: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error verifying OTP: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpControllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 14, 14, 20),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Change Password',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: isLargeScreen ? 600 : screenWidth * 0.9),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'An OTP has been sent to ',
                      style: TextStyle(
                        fontSize: isLargeScreen ? 28 : 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                      children: [
                        TextSpan(
                          text: maskEmail(widget.email),
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                            fontSize: isLargeScreen ? 24 : 20,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isLargeScreen ? 48 : 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        6, (index) => _buildOtpField(index, screenWidth)),
                  ),
                  SizedBox(height: isLargeScreen ? 48 : 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: isLargeScreen ? 60 : 40,
                        vertical: isLargeScreen ? 20 : 16,
                      ),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ).copyWith(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.transparent),
                      overlayColor: WidgetStateProperty.all(
                          Colors.white.withOpacity(0.1)),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.blueAccent, Colors.purpleAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: isLargeScreen ? 60 : 40,
                        vertical: isLargeScreen ? 20 : 16,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              'Verify OTP',
                              style: TextStyle(
                                fontSize: isLargeScreen ? 18 : 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: isLargeScreen ? 24 : 16),
                  TextButton(
                    onPressed:
                        _isResendEnabled && !_isLoading ? _resendOtp : null,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: isLargeScreen ? 60 : 40,
                        vertical: isLargeScreen ? 20 : 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      foregroundColor: Colors.white.withOpacity(0.7),
                    ),
                    child: Text(
                      _isResendEnabled
                          ? 'Resend OTP'
                          : 'Resend OTP ($_countdown s)',
                      style: TextStyle(
                        fontSize: isLargeScreen ? 18 : 16,
                        color: _isResendEnabled
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpField(int index, double screenWidth) {
    final fontSize = screenWidth > 600 ? 28.0 : 24.0;
    final fieldWidth = screenWidth > 600 ? 40.0 : screenWidth * 0.08;

    return Container(
      width: fieldWidth,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(
          counterText: '',
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.purpleAccent),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index].unfocus();
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index].unfocus();
            _focusNodes[index - 1].requestFocus();
          }
          setState(() {});
        },
        onSubmitted: (value) {
          if (index == 5) _verifyOtp();
        },
      ),
    );
  }
}

class ResetPassword extends StatefulWidget {
  final String email;
  const ResetPassword({super.key, required this.email});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  final String _baseUrl =
      'https://gem-know-server.onrender.com'; // Replace with your actual base URL

  Future<void> _resetPassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/auth/reset/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successfully')),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LoginPage())); // Navigate back to the first screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset failed: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error resetting password: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 14, 14, 20),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Reset Password',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: isLargeScreen ? 600 : screenWidth * 0.9),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter your new password',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 28 : 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isLargeScreen ? 48 : 32),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      labelStyle: TextStyle(color: Colors.grey.shade400),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purpleAccent),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: isLargeScreen ? 24 : 16),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(color: Colors.grey.shade400),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purpleAccent),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: isLargeScreen ? 48 : 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _resetPassword,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: isLargeScreen ? 60 : 40,
                        vertical: isLargeScreen ? 20 : 16,
                      ),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ).copyWith(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.transparent),
                      overlayColor: WidgetStateProperty.all(
                          Colors.white.withOpacity(0.1)),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.blueAccent, Colors.purpleAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: isLargeScreen ? 60 : 40,
                        vertical: isLargeScreen ? 20 : 16,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              'Reset Password',
                              style: TextStyle(
                                fontSize: isLargeScreen ? 18 : 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
