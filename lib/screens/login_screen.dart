import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../utils/app_styles.dart';
import '../utils/app_colors.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                  onPressed: () {
                    Navigator.pushNamed(context, '/reset-password');
                  },
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
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
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
}
