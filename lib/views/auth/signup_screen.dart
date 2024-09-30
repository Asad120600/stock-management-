import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/views/auth/login_screen.dart';
import 'package:stock_managment/widgets/button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false; // Track password visibility

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
              'assets/images/Vector 1-1.png', // Top-left vector path
              width: ScreenUtil.setWidth(150), // Adjust size as needed
            ),
          ),
          // Bottom-right vector
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Vector 2-1.png', // Bottom-right vector path
              width: ScreenUtil.setWidth(150), // Adjust size as needed
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil.setWidth(24.0)), // Scale padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ScreenUtil.setHeight(70)), // Scale height
                  Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: ScreenUtil.setSp(32), // Scale text size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(30)),
                  Text(
                    'Email:',
                    style: TextStyle(
                      fontSize: ScreenUtil.setSp(16), // Scale text size
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(5)),
                  TextField(
                    controller: _emailController, // Use email controller
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined, size: ScreenUtil.setSp(24)), // Scale icon size
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ScreenUtil.setWidth(10.0)), // Scale border radius
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(8)),
                  Text(
                    'Phone:',
                    style: TextStyle(
                      fontSize: ScreenUtil.setSp(16), // Scale text size
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(5)),
                  TextField(
                    controller: _phoneController, // Use phone controller
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone_outlined, size: ScreenUtil.setSp(24)), // Scale icon size
                      hintText: 'Enter your phone',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ScreenUtil.setWidth(10.0)), // Scale border radius
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(10)),
                  Text(
                    'Password:',
                    style: TextStyle(
                      fontSize: ScreenUtil.setSp(16), // Scale text size
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(5)),
                  TextField(
                    controller: _passwordController, // Use password controller
                    obscureText: !_isPasswordVisible, // Toggle visibility
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline, size: ScreenUtil.setSp(24)),
                      hintText: 'Enter your password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off, // Toggle icon
                          size: ScreenUtil.setSp(24),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible; // Toggle password visibility
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ScreenUtil.setWidth(10.0)),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(30)),
                  SizedBox(
                    width: double.infinity,
                    height: ScreenUtil.setHeight(50), // Scale button height
                    child: Button(
                      onPressed: () {

                        // Process sign-up with email, phone, and password
                      },
                      text: ('Continue'),
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
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 1.2,
                          color: Colors.purple,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ScreenUtil.setWidth(10)),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            fontSize: ScreenUtil.setSp(16),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          thickness: 1.2,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenUtil.setHeight(20)),
                  SizedBox(
                    width: double.infinity,
                    height: ScreenUtil.setHeight(50), // Facebook button height
                    child: OutlinedButton(
                      onPressed: () {
                        // Facebook sign-in logic
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/facebook.png', // Path to your Facebook image
                            height: ScreenUtil.setHeight(24), // Adjust size as needed
                          ),
                          SizedBox(width: ScreenUtil.setWidth(8)), // Space between image and text
                          Text(
                            'Continue with Facebook',
                            style: TextStyle(
                              fontSize: ScreenUtil.setSp(16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.setHeight(10)),
                  SizedBox(
                    width: double.infinity,
                    height: ScreenUtil.setHeight(50), // Google button height
                    child: OutlinedButton(
                      onPressed: () {
                        // Google sign-in logic
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/google.png', // Path to your Google image
                            height: ScreenUtil.setHeight(24), // Adjust size as needed
                          ),
                          SizedBox(width: ScreenUtil.setWidth(8)), // Space between image and text
                          Text(
                            'Continue with Google',
                            style: TextStyle(
                              fontSize: ScreenUtil.setSp(16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: ScreenUtil.setHeight(200)), // Add space below Google button
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
