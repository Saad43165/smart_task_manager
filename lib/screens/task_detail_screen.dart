import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../utils/app_styles.dart';
import '../utils/app_colors.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  TaskDetailScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.08),
              Text(
                'Task Details',
                style: AppStyles.headingStyle.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              Divider(
                color: Colors.grey.shade300,
                thickness: 1.5,
                endIndent: size.width * 0.7,
              ),
              SizedBox(height: size.height * 0.05),
              Text(
                task.title,
                style: AppStyles.headingStyle.copyWith(fontSize: 22),
              ),
              SizedBox(height: 16),
              Text('Priority: ${task.priority}', style: AppStyles.bodyTextStyle),
              SizedBox(height: 16),
              Text('Start Date: ${task.startDate.toLocal()}',
                  style: AppStyles.bodyTextStyle),
              SizedBox(height: 8),
              Text('End Date: ${task.endDate.toLocal()}',
                  style: AppStyles.bodyTextStyle),
              SizedBox(height: 16),
              Text(
                task.description,
                style: AppStyles.bodyTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
