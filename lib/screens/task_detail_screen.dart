import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../utils/app_styles.dart';
import '../utils/app_colors.dart';
import 'themeprovider.dart';
import 'font_provider.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  TaskDetailScreen({required this.task});

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
                SizedBox(height: 16),
                _buildHeader(textColor, fontProvider.fontSize),
                Divider(
                  color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
                  thickness: 1.5,
                  endIndent: MediaQuery.of(context).size.width * 0.7,
                ),
                SizedBox(height: 20),
                _buildTaskTitle(task, textColor, fontProvider.fontSize),
                SizedBox(height: 20),
                _buildTaskDetails(task, textColor, fontProvider.fontSize, isDarkMode),
                SizedBox(height: 20),
                _buildTaskDescription(task, textColor, fontProvider.fontSize, isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Task Details',
          style: AppStyles.headingStyle.copyWith(
            fontSize: fontSize + 10,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        Icon(Icons.info, color: textColor, size: 30),
      ],
    );
  }

  Widget _buildTaskTitle(Task task, Color textColor, double fontSize) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.task, color: textColor, size: 30),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              task.title,
              style: AppStyles.headingStyle.copyWith(
                fontSize: fontSize + 8,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskDetails(Task task, Color textColor, double fontSize, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            icon: Icons.flag,
            label: 'Priority',
            value: task.priority,
            color: _getPriorityColor(task.priority),
            fontSize: fontSize,
            textColor: textColor,
            isDarkMode: isDarkMode,
          ),
          Divider(color: Colors.grey.shade300, height: 30, thickness: 1),
          _buildDetailRow(
            icon: Icons.calendar_today,
            label: 'Start Date',
            value: DateFormat('MMM d, yyyy').format(task.startDate),
            fontSize: fontSize,
            textColor: textColor,
            isDarkMode: isDarkMode,
          ),
          SizedBox(height: 8),
          _buildDetailRow(
            icon: Icons.calendar_today,
            label: 'End Date',
            value: DateFormat('MMM d, yyyy').format(task.endDate),
            fontSize: fontSize,
            textColor: textColor,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskDescription(Task task, Color textColor, double fontSize, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: AppStyles.headingStyle.copyWith(
              fontSize: fontSize + 2,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            task.description.isNotEmpty ? task.description : 'No description available.',
            style: AppStyles.bodyTextStyle.copyWith(
              fontSize: fontSize,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required double fontSize,
    required Color textColor,
    required bool isDarkMode,
    Color? color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: color ?? textColor, size: 20),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            '$label: $value',
            style: AppStyles.bodyTextStyle.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
