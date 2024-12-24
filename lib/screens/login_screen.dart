import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_button.dart';
import '../utils/app_styles.dart';
import '../utils/app_colors.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.08),
              Text(
                'Login',
                style: AppStyles.headingStyle.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              Divider(
                color: Colors.grey.shade300,
                thickness: 1.5,
                endIndent: size.width * 0.7,
              ),
              // App Icon or Image
              Center(
                child: Icon(
                  Icons.task_alt,
                  color: AppColors.primaryColor,
                  size: 80,
                ),
              ),
              SizedBox(height: size.height * 0.03),

              // App Introduction
              Center(
                child: Text(
                  'Welcome to Smart Task Manager',
                  style: AppStyles.headingStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Center(
                child: Text(
                  'Manage your tasks efficiently and boost your productivity.',
                  style: AppStyles.bodyTextStyle.copyWith(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: size.height * 0.05),

              // Email Text Field
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'abc@gmail.com',
                  prefixIcon: Icon(Icons.email_outlined, color: AppColors.primaryColor),
                  labelStyle: TextStyle(color: AppColors.primaryColor),
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),

              // Password Text Field
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: '******',
                  prefixIcon: Icon(Icons.lock_outline, color: AppColors.primaryColor),
                  labelStyle: TextStyle(color: AppColors.primaryColor),
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _resetPassword(context),
                  child: Text(
                    'Forgot Password?',
                    style: AppStyles.bodyTextStyle.copyWith(
                      color: AppColors.primaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),

              // Login Button
              CustomButton(
                text: 'Login',
                onPressed: () => _login(context),
              ),
              SizedBox(height: size.height * 0.03),

              // Sign Up Redirect
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text(
                    'Don’t have an account? Sign up',
                    style: AppStyles.bodyTextStyle.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to handle login functionality
  void _login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError(context, 'Please fill all fields');
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      _showError(context, 'Login failed. Please check your credentials.');
      print(e);
    }
  }

  // Method to handle password reset
  void _resetPassword(BuildContext context) async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _showError(context, 'Please enter your email address');
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showSuccess(context, 'Password reset email sent. Check your inbox.');
    } catch (e) {
      _showError(context, 'Failed to send password reset email');
      print(e);
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
