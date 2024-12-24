import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_tasks_manager/screens/font_provider.dart';
import 'package:smart_tasks_manager/screens/tasks_provider.dart';
import 'package:smart_tasks_manager/screens/themeprovider.dart';
import 'package:smart_tasks_manager/screens/user_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/user_info_screen.dart';
import 'screens/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FontProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
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
          debugShowCheckedModeBanner: false,
          title: 'Smart Task Manager',
          themeMode: themeProvider.themeMode,
          theme: _buildThemeData(Brightness.light, fontProvider.fontSize),
          darkTheme: _buildThemeData(Brightness.dark, fontProvider.fontSize),
          initialRoute: '/',
          routes: {
            '/': (context) => OnboardingScreen(),
            '/login': (context) => LoginScreen(),
            '/signup': (context) => SignupScreen(),
            '/reset-password': (context) => ResetPasswordScreen(),
            '/dashboard': (context) => DashboardScreen(),
            '/settings': (context) => SettingsScreen(),
            '/user-info': (context) => UserInfoScreen(),
            '/profile': (context) => ProfileScreen(),
          },
        );
      },
    );
  }

  ThemeData _buildThemeData(Brightness brightness, double fontSize) {
    final baseTheme = brightness == Brightness.light
        ? ThemeData.light()
        : ThemeData.dark();

    return baseTheme.copyWith(
      primaryColor: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: _buildTextTheme(fontSize, brightness),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(Colors.blue),
        trackColor: MaterialStateProperty.all(Colors.blue.shade200),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: Colors.blue,
        inactiveTrackColor: Colors.blue.shade100,
        thumbColor: Colors.blue,
        overlayColor: Colors.blue.withOpacity(0.2),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          textStyle: TextStyle(fontSize: fontSize),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  TextTheme _buildTextTheme(double fontSize, Brightness brightness) {
    Color textColor = brightness == Brightness.dark ? Colors.white : Colors.black;

    return TextTheme(
      bodyLarge: TextStyle(fontSize: fontSize, color: textColor),
      bodyMedium: TextStyle(fontSize: fontSize, color: textColor),
      bodySmall: TextStyle(fontSize: fontSize, color: textColor),
      displayLarge: TextStyle(fontSize: fontSize, color: textColor),
      displayMedium: TextStyle(fontSize: fontSize, color: textColor),
      displaySmall: TextStyle(fontSize: fontSize, color: textColor),
      headlineLarge: TextStyle(fontSize: fontSize, color: textColor),
      headlineMedium: TextStyle(fontSize: fontSize, color: textColor),
      headlineSmall: TextStyle(fontSize: fontSize, color: textColor),
      titleLarge: TextStyle(fontSize: fontSize, color: textColor),
      titleMedium: TextStyle(fontSize: fontSize, color: textColor),
      titleSmall: TextStyle(fontSize: fontSize, color: textColor),
    );
  }
}
