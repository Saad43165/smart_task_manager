import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../utils/app_styles.dart';
import '../utils/app_colors.dart';
import 'user_provider.dart';
import 'themeprovider.dart';
import 'font_provider.dart';

class UserInfoScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontProvider = Provider.of<FontProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : AppColors.primaryColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.08),
              _buildHeader(size, textColor, fontProvider.fontSize, isDarkMode),
              Divider(
                color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
                thickness: 1.5,
                endIndent: size.width * 0.7,
              ),
              SizedBox(height: size.height * 0.03),

              // Name Text Field
              _buildTextField(
                controller: nameController,
                labelText: 'Name',
                hintText: 'Enter your name',
                icon: Icons.person_outline,
                inputType: TextInputType.text,
                textColor: textColor,
                fontSize: fontProvider.fontSize,
              ),
              SizedBox(height: size.height * 0.02),

              // DOB Text Field
              _buildDateField(context, dobController, textColor, fontProvider.fontSize),
              SizedBox(height: size.height * 0.02),

              // Phone Number Text Field
              _buildTextField(
                controller: phoneController,
                labelText: 'Phone Number',
                hintText: '+1234567890',
                icon: Icons.phone_outlined,
                inputType: TextInputType.phone,
                textColor: textColor,
                fontSize: fontProvider.fontSize,
              ),
              SizedBox(height: size.height * 0.04),

              // Save Button with Animated Effect
              _buildAnimatedSaveButton(context, textColor, fontProvider.fontSize),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Size size, Color textColor, double fontSize, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Complete Your Profile',
          style: AppStyles.headingStyle.copyWith(
            fontSize: fontSize + 12,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: size.height * 0.02),
        Text(
          'We need a few more details to set up your account',
          style: AppStyles.bodyTextStyle.copyWith(
            fontSize: fontSize,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required Color textColor,
    required double fontSize,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      style: TextStyle(color: textColor, fontSize: fontSize),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: textColor),
        labelStyle: TextStyle(color: textColor, fontSize: fontSize),
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: fontSize - 2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context, TextEditingController controller, Color textColor, double fontSize) {
    return TextField(
      controller: controller,
      readOnly: true,
      style: TextStyle(color: textColor, fontSize: fontSize),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (pickedDate != null) {
          controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        }
      },
      decoration: InputDecoration(
        labelText: 'Date of Birth',
        hintText: 'Select your date of birth',
        prefixIcon: Icon(Icons.cake_outlined, color: textColor),
        labelStyle: TextStyle(color: textColor, fontSize: fontSize),
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: fontSize - 2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor),
        ),
      ),
    );
  }

  Widget _buildAnimatedSaveButton(BuildContext context, Color textColor, double fontSize) {
    return GestureDetector(
      onTap: () {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateName(nameController.text);
        userProvider.updatePhone(phoneController.text);
        userProvider.updateDob(dobController.text);

        Navigator.pushReplacementNamed(context, '/dashboard');
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: 50,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: textColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Save',
          style: AppStyles.bodyTextStyle.copyWith(
            fontSize: fontSize,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
