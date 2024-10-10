import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/themeprovider.dart';
import 'screens/font_provider.dart';
import 'screens/tasks_provider.dart'; // Import TaskProvider
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FontProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()), // Add TaskProvider here
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, FontProvider>(
      builder: (context, themeProvider, fontProvider, child) {
        return MaterialApp(
          title: 'Smart Task Manager',
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: _buildTextTheme(fontProvider.fontSize),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: _buildTextTheme(fontProvider.fontSize),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => OnboardingScreen(),
            '/login': (context) => LoginScreen(),
            '/signup': (context) => SignupScreen(),
            '/reset-password': (context) => ResetPasswordScreen(),
            '/dashboard': (context) => DashboardScreen(),
            '/settings': (context) => SettingsScreen(),
          },
        );
      },
    );
  }

  TextTheme _buildTextTheme(double fontSize) {
    return TextTheme(
      bodyLarge: TextStyle(fontSize: fontSize),
      bodyMedium: TextStyle(fontSize: fontSize),
      displayLarge: TextStyle(fontSize: fontSize),
      displayMedium: TextStyle(fontSize: fontSize),
      displaySmall: TextStyle(fontSize: fontSize),
      headlineMedium: TextStyle(fontSize: fontSize),
      headlineSmall: TextStyle(fontSize: fontSize),
      titleLarge: TextStyle(fontSize: fontSize),
      titleMedium: TextStyle(fontSize: fontSize),
      titleSmall: TextStyle(fontSize: fontSize),
    );
  }
}
