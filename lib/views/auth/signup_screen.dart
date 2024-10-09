import 'package:flutter/material.dart';
import 'package:stock_managment/utils/screen_util.dart';
import 'package:stock_managment/views/auth/login_screen.dart';
import 'package:stock_managment/widgets/button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  bool _isPasswordVisible = false; // Track password visibility
  bool _isLoading = false; // Track loading state

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://stock.cslancer.com/api/signup');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "name": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "password_confirmation": _passwordConfirmController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign-up successful! Please login.')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
      );
    } else {
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-up failed: ${responseData['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil with the current context to get screen dimensions
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top-left vector
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/Vector 1-1.png',
              width: ScreenUtil.setWidth(150),
            ),
          ),
          // Bottom-right vector
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Vector 2-1.png',
              width: ScreenUtil.setWidth(150),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil.setWidth(24.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ScreenUtil.setHeight(70)),
                  Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: ScreenUtil.setSp(32),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(30)),
                  Text(
                    'Name:',
                    style: TextStyle(
                      fontSize: ScreenUtil.setSp(16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(5)),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline, size: ScreenUtil.setSp(24)),
                      hintText: 'Enter your name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ScreenUtil.setWidth(10.0)),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(8)),
                  Text(
                    'Email:',
                    style: TextStyle(
                      fontSize: ScreenUtil.setSp(16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(5)),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined, size: ScreenUtil.setSp(24)),
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ScreenUtil.setWidth(10.0)),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(8)),
                  Text(
                    'Password:',
                    style: TextStyle(
                      fontSize: ScreenUtil.setSp(16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(5)),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline, size: ScreenUtil.setSp(24)),
                      hintText: 'Enter your password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          size: ScreenUtil.setSp(24),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ScreenUtil.setWidth(10.0)),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(8)),
                  Text(
                    'Confirm Password:',
                    style: TextStyle(
                      fontSize: ScreenUtil.setSp(16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(5)),
                  TextField(
                    controller: _passwordConfirmController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline, size: ScreenUtil.setSp(24)),
                      hintText: 'Confirm your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ScreenUtil.setWidth(10.0)),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(30)),
                  SizedBox(
                    width: double.infinity,
                    height: ScreenUtil.setHeight(50),
                    child: Button(
                      onPressed: _signUp,
                      text: _isLoading ? 'Loading...' : 'Continue',
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: ScreenUtil.setSp(22),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: ScreenUtil.setSp(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
