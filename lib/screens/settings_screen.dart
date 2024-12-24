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

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  bool _notificationsEnabled = true;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(textColor, fontProvider.fontSize),
                  Divider(
                    color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
                    thickness: 1.5,
                    endIndent: MediaQuery.of(context).size.width * 0.7,
                  ),
                  const SizedBox(height: 20),
                  _buildSettingsOptions(themeProvider, fontProvider, textColor, isDarkMode),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor, double fontSize) {
    return Text(
      'Settings',
      style: AppStyles.headingStyle.copyWith(
        fontSize: fontSize + 12,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget _buildSettingsOptions(ThemeProvider themeProvider, FontProvider fontProvider, Color textColor, bool isDarkMode) {
    return Column(
      children: [
        _buildDarkModeSwitch(themeProvider, textColor, fontProvider.fontSize),
        const SizedBox(height: 20),
        _buildFontSizeSlider(fontProvider, textColor),
        const SizedBox(height: 20),
        _buildNotificationSwitch(textColor, fontProvider.fontSize),
      ],
    );
  }

  Widget _buildDarkModeSwitch(ThemeProvider themeProvider, Color textColor, double fontSize) {
    return ListTile(
      title: Text(
        'Dark Mode',
        style: AppStyles.bodyTextStyle.copyWith(color: textColor, fontSize: fontSize),
      ),
      trailing: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
        child: Switch(
          key: ValueKey<bool>(themeProvider.themeMode == ThemeMode.dark),
          value: themeProvider.themeMode == ThemeMode.dark,
          onChanged: (value) {
            themeProvider.toggleTheme();
          },
          activeColor: AppColors.primaryColor,
        ),
      ),
    );
  }

  Widget _buildFontSizeSlider(FontProvider fontProvider, Color textColor) {
    return ListTile(
      title: Text(
        'Font Size',
        style: AppStyles.bodyTextStyle.copyWith(color: textColor, fontSize: fontProvider.fontSize),
      ),
      subtitle: Slider(
        value: fontProvider.fontSize,
        min: 5.0,
        max: 22.0,
        divisions: 17,
        label: fontProvider.fontSize.toStringAsFixed(0),
        onChanged: (value) {
          setState(() {
            fontProvider.setFontSize(value);
          });
        },
        activeColor: AppColors.primaryColor,
        inactiveColor: Colors.grey,
      ),
    );
  }

  Widget _buildNotificationSwitch(Color textColor, double fontSize) {
    return ListTile(
      title: Text(
        'Notifications',
        style: AppStyles.bodyTextStyle.copyWith(color: textColor, fontSize: fontSize),
      ),
      trailing: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
        child: Switch(
          key: ValueKey<bool>(_notificationsEnabled),
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
          activeColor: AppColors.primaryColor,
        ),
      ),
    );
  }
}
