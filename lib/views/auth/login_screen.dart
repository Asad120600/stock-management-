import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/views/auth/signup_screen.dart';
import 'package:stock_managment/widgets/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false; // Track password visibility

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil with the current context to get screen dimensions
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body:
      Stack(
        children: [
          // Top-left vector
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Vector 1.png', // Your top-left vector path
              width: ScreenUtil.setWidth(150), // Adjust size as needed
            ),
          ),
          // Bottom-right vector
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/images/Vector 2.png', // Your bottom-right vector path
              width: ScreenUtil.setWidth(150), // Adjust size as needed
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtil.setWidth(24.0),right: ScreenUtil.setWidth(24.0) ), // Scale padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ScreenUtil.setHeight(80)), // Scale height
                Center(
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: ScreenUtil.setSp(32), // Scale text size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil.setHeight(50)),
                Center(
                  child: Image.asset(
                    'assets/images/login.png',
                    height: ScreenUtil.setHeight(150), // Scale image height
                  ),
                ),
                SizedBox(height: ScreenUtil.setHeight(40)),
                Text(
                  'Email:',
                  style: TextStyle(
                    fontSize: ScreenUtil.setSp(16), // Scale text size
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: ScreenUtil.setHeight(8)),
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
                SizedBox(height: ScreenUtil.setHeight(10)),
                Text(
                  'Password:',
                  style: TextStyle(
                    fontSize: ScreenUtil.setSp(16),
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
                SizedBox(height: ScreenUtil.setHeight(5)),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Forgot password logic
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: ScreenUtil.setSp(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil.setHeight(5)),
                SizedBox(
                  width: double.infinity,
                  height: ScreenUtil.setHeight(50), // Scale button height
                  child: Button(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                    },
                    text: ('Log In'),
                  ),
                ),
                SizedBox(height: ScreenUtil.setHeight(8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: ScreenUtil.setSp(22), // Scale text size
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Sign up logic
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: ScreenUtil.setSp(22),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil.setHeight(80)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
