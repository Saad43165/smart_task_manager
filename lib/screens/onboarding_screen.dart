import 'package:flutter/material.dart';
import 'package:smart_tasks_manager/widgets/custom_button.dart';
import 'dashboard_screen.dart';
import '../utils/app_styles.dart';
import '../utils/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Welcome to Smart Task Manager",
      "description": "Manage your tasks efficiently and stay productive.",
      "image": "assets/images/onboarding.png",
    },
    {
      "title": "Organize Tasks Easily",
      "description": "Categorize, prioritize, and set reminders for your tasks.",
      "image": "assets/images/onboarding.png",
    },
    {
      "title": "Stay on Top of Deadlines",
      "description": "Never miss a deadline with timely notifications.",
      "image": "assets/images/onboarding.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      onboardingData[index]["title"]!,
                      style: AppStyles.headingStyle.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: size.height * 0.03),
                    // Description
                    Text(
                      onboardingData[index]["description"]!,
                      style: AppStyles.bodyTextStyle.copyWith(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: size.height * 0.05),
                    // Image
                    Image.asset(
                      onboardingData[index]["image"]!,
                      height: size.height * 0.3,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: size.height * 0.05),
                    // Page Indicator
                    _buildPageIndicator(),
                    SizedBox(height: size.height * 0.05),
                    // Next or Get Started Button
                    index == onboardingData.length - 1
                        ? CustomButton(
                      text: "Get Started",
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    )
                        : CustomButton(
                      text: "Next",
                      onPressed: () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                    ),

                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Method to build the page indicator
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: onboardingData.asMap().entries.map((entry) {
        int index = entry.key;
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          height: 14.0,
          width: _currentPage == index ? 24.0 : 12.0,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? AppColors.primaryColor
                : AppColors.primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
