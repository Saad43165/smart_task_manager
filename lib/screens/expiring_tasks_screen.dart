import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../screens/tasks_provider.dart';
import '../screens/themeprovider.dart';
import '../screens/font_provider.dart';
import '../utils/app_styles.dart';
import '../utils/app_colors.dart';
import 'task_detail_screen.dart';
import 'package:intl/intl.dart';

class ExpiringTasksScreen extends StatelessWidget {
  const ExpiringTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontProvider = Provider.of<FontProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : AppColors.primaryColor;
    final secondaryTextColor = isDarkMode ? Colors.grey[300] : Colors.grey[800];

    final expiringTasks = taskProvider.tasks
        .where((task) =>
    task.endDate.isBefore(DateTime.now().add(Duration(days: 3))) &&
        task.endDate.isAfter(DateTime.now()))
        .toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Text(
              'Expiring Tasks',
              style: AppStyles.headingStyle.copyWith(
                fontSize: fontProvider.fontSize + 12,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Divider(
              color: isDarkMode ? Colors.grey[600] : Colors.grey.shade300,
              thickness: 1.5,
              endIndent: MediaQuery.of(context).size.width * 0.7,
            ),
            SizedBox(height: 20),
            Expanded(
              child: expiringTasks.isEmpty
                  ? Center(
                child: Text(
                  "No expiring tasks",
                  style: AppStyles.bodyTextStyle.copyWith(
                    fontSize: fontProvider.fontSize,
                    color: secondaryTextColor,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: expiringTasks.length,
                itemBuilder: (context, index) {
                  final task = expiringTasks[index];
                  return _buildExpiringTaskCard(context, task, isDarkMode, fontProvider.fontSize);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiringTaskCard(BuildContext context, Task task, bool isDarkMode, double fontSize) {
    final cardColor = isDarkMode ? Colors.grey[850] : AppColors.primaryColor.withOpacity(0.05);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: AppStyles.headingStyle.copyWith(
                    fontSize: fontSize + 2,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Expiring',
                  style: AppStyles.bodyTextStyle.copyWith(
                    fontSize: fontSize - 2,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Due: ${DateFormat('MMM d, yyyy').format(task.endDate)}',
            style: AppStyles.bodyTextStyle.copyWith(
              fontSize: fontSize - 2,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 8),
          Text(
            task.description,
            style: AppStyles.bodyTextStyle.copyWith(
              fontSize: fontSize - 2,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _priorityIndicator(task.priority, fontSize),
              IconButton(
                icon: Icon(Icons.arrow_forward, color: AppColors.primaryColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailScreen(task: task),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priorityIndicator(String priority, double fontSize) {
    Color priorityColor;
    String priorityText;

    switch (priority) {
      case 'High':
        priorityColor = Colors.red;
        priorityText = 'High Priority';
        break;
      case 'Medium':
        priorityColor = Colors.orange;
        priorityText = 'Medium Priority';
        break;
      case 'Low':
        priorityColor = Colors.green;
        priorityText = 'Low Priority';
        break;
      default:
        priorityColor = Colors.grey;
        priorityText = 'Priority';
    }

    return Row(
      children: [
        Icon(
          Icons.flag,
          color: priorityColor,
          size: 18,
        ),
        SizedBox(width: 4),
        Text(
          priorityText,
          style: AppStyles.bodyTextStyle.copyWith(
            fontSize: fontSize - 2,
            color: priorityColor,
          ),
        ),
      ],
    );
  }
}
