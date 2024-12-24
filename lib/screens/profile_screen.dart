import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../screens/user_provider.dart';
import '../utils/app_styles.dart';
import '../utils/app_colors.dart';
import 'themeprovider.dart';
import 'font_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontProvider = Provider.of<FontProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    // Set background and text colors based on theme
    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : AppColors.primaryColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: FutureBuilder<DocumentSnapshot>(
        future: _fetchUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading profile'));
          } else if (snapshot.hasData) {
            var userData = snapshot.data?.data() as Map<String, dynamic>?;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    _buildHeader(context, textColor, fontProvider.fontSize),
                    Divider(
                      color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
                      thickness: 1.5,
                      endIndent: size.width * 0.7,
                    ),
                    const SizedBox(height: 20),
                    _buildProfileCard(userData, isDarkMode, fontProvider.fontSize),
                    const SizedBox(height: 30),
                    _buildLogoutButton(context, textColor, fontProvider.fontSize),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No user data available'));
          }
        },
      ),
    );
  }

  Future<DocumentSnapshot> _fetchUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    } else {
      throw Exception('User not logged in');
    }
  }

  Widget _buildHeader(BuildContext context, Color textColor, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Profile',
          style: AppStyles.headingStyle.copyWith(
            fontSize: fontSize + 12,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit, color: textColor),
          onPressed: () {
            Navigator.pushNamed(context, '/user-info');
          },
        ),
      ],
    );
  }

  Widget _buildProfileCard(Map<String, dynamic>? userData, bool isDarkMode, double fontSize) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : AppColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Profile',
            style: AppStyles.headingStyle.copyWith(
              fontSize: fontSize + 6,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : AppColors.primaryColor,
            ),
          ),
          Divider(
            color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
            thickness: 1,
            height: 30,
          ),
          _buildProfileDetail(Icons.email_outlined, 'Email', userData?['email'] ?? 'Not Provided', fontSize, isDarkMode),
          _buildProfileDetail(Icons.person_outline, 'Name', userData?['name'] ?? 'Not Provided', fontSize, isDarkMode),
          _buildProfileDetail(Icons.phone_outlined, 'Phone', userData?['phone'] ?? 'Not Provided', fontSize, isDarkMode),
          _buildProfileDetail(Icons.cake_outlined, 'Date of Birth', userData?['dob'] ?? 'Not Provided', fontSize, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildProfileDetail(IconData icon, String title, String detail, double fontSize, bool isDarkMode) {
    final textColor = isDarkMode ? Colors.white70 : Colors.grey[600];
    final detailColor = isDarkMode ? Colors.white : AppColors.primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: detailColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.bodyTextStyle.copyWith(
                    fontSize: fontSize,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: AppStyles.bodyTextStyle.copyWith(
                    fontSize: fontSize + 2,
                    fontWeight: FontWeight.bold,
                    color: detailColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, Color textColor, double fontSize) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacementNamed(context, '/login');
        },
        icon: const Icon(Icons.logout, color: Colors.white),
        label: Text(
          'Logout',
          style: AppStyles.bodyTextStyle.copyWith(
            fontSize: fontSize,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          elevation: 5,
          shadowColor: Colors.grey.withOpacity(0.4),
        ),
      ),
    );
  }
}
