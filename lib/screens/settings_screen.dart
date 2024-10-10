import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_styles.dart';
import '../utils/app_colors.dart';
import 'themeprovider.dart';
import 'font_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontProvider = Provider.of<FontProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : AppColors.primaryColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Settings',
                  style: AppStyles.headingStyle.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Divider(
                  color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
                  thickness: 1.5,
                  endIndent: MediaQuery.of(context).size.width * 0.7,
                ),
                SizedBox(height: 20),

                // Display user email (replace with actual data if available)
                Text(
                  'user@example.com', // Replace with dynamic email if possible
                  style: AppStyles.bodyTextStyle.copyWith(fontSize: 16, color: textColor),
                ),
                Divider(color: Colors.grey),

                // Dark Mode Switch
                _buildDarkModeSwitch(themeProvider, textColor),

                // Font Size Adjuster
                _buildFontSizeSlider(fontProvider, textColor),

                // Logout Button
                _buildLogoutButton(textColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDarkModeSwitch(ThemeProvider themeProvider, Color textColor) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Dark Mode',
        style: AppStyles.bodyTextStyle.copyWith(color: textColor),
      ),
      trailing: Switch(
        value: themeProvider.themeMode == ThemeMode.dark,
        onChanged: (value) {
          themeProvider.toggleTheme();
        },
        activeColor: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildFontSizeSlider(FontProvider fontProvider, Color textColor) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Font Size',
        style: AppStyles.bodyTextStyle.copyWith(color: textColor),
      ),
      trailing: SizedBox(
        width: 150,
        child: Slider(
          value: fontProvider.fontSize,
          min: 12.0,
          max: 24.0,
          divisions: 6,
          label: fontProvider.fontSize.toStringAsFixed(0),
          onChanged: (value) {
            fontProvider.setFontSize(value);
          },
          activeColor: AppColors.primaryColor,
          inactiveColor: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildLogoutButton(Color textColor) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Logout',
        style: AppStyles.bodyTextStyle.copyWith(color: textColor),
      ),
      onTap: () => _showLogoutDialog(context, textColor),
    );
  }

  void _showLogoutDialog(BuildContext context, Color textColor) {
    showDialog(
      context: context,
      builder: (context) {
        final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).themeMode == ThemeMode.dark;
        final dialogBgColor = isDarkMode ? Colors.grey[850] : Colors.white;

        return AlertDialog(
          backgroundColor: dialogBgColor,
          title: Text('Logout', style: AppStyles.headingStyle.copyWith(color: textColor)),
          content: Text('Are you sure you want to log out?', style: AppStyles.bodyTextStyle.copyWith(color: textColor)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No', style: TextStyle(color: textColor)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Yes', style: TextStyle(color: textColor)),
            ),
          ],
        );
      },
    );
  }
}
