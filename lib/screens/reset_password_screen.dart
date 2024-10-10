import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../utils/app_styles.dart';
import '../utils/app_colors.dart';

class ResetPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

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
              // Reset Password Header
              Text(
                'Reset Password',
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
              SizedBox(height: size.height * 0.02),

              // App Icon for Reset Password
              const Center(
                child: Icon(
                  Icons.lock_reset_outlined,
                  color: AppColors.primaryColor,
                  size: 80,
                ),
              ),
              SizedBox(height: size.height * 0.03),

              // Instruction Text
              Center(
                child: Text(
                  'Enter your email to receive password reset instructions',
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
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primaryColor),
                  labelStyle: const TextStyle(color: AppColors.primaryColor),
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.04),

              // Reset Button
              CustomButton(
                text: 'Send Reset Link',
                onPressed: () {
                  // Implement reset logic here
                  // Show confirmation or navigate back to login screen
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: size.height * 0.03),

              // Back to Login
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Back to Login',
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
