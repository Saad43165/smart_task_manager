import 'package:flutter/material.dart';
import 'package:smart_tasks_manager/models/task_model.dart';
import '../utils/app_styles.dart';
import '../utils/app_colors.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String priority;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  TaskCard({
    required this.title,
    required this.priority,
    required this.onTap,
    required this.onDelete, required Task task,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        child: ListTile(
          title: Text(title, style: AppStyles.bodyTextStyle),
          subtitle: Text(
            'Priority: $priority',
            style: TextStyle(color: Colors.grey),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: AppColors.primaryColor),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}
