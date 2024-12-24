import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../screens/themeprovider.dart';
import '../screens/font_provider.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabTapped;

  BottomNavBar({
    required this.selectedIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontProvider = Provider.of<FontProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final selectedItemColor = isDarkMode ? Colors.white : AppColors.primaryColor;
    final unselectedItemColor = isDarkMode ? Colors.grey[400] : Colors.grey;

    return BottomNavigationBar(
      backgroundColor: bgColor,
      currentIndex: selectedIndex,
      onTap: onTabTapped,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: fontProvider.fontSize - 2, // Slightly reduce font size for selected labels
      unselectedFontSize: fontProvider.fontSize - 4, // Reduce font size more for unselected labels
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Expiring',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_circle),
          label: 'Completed',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
