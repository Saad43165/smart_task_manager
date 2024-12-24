import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../screens/tasks_provider.dart';
import '../screens/themeprovider.dart';
import '../screens/font_provider.dart';
import '../utils/app_styles.dart';
import '../utils/app_colors.dart';
import 'task_detail_screen.dart';

class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({Key? key}) : super(key: key);

  @override
  _CompletedTasksScreenState createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  String? _selectedPriorityFilter;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontProvider = Provider.of<FontProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : AppColors.primaryColor;
    final secondaryTextColor = isDarkMode ? Colors.grey[300] : Colors.grey[800];

    List<Task> completedTasks = taskProvider.completedTasks;

    // Apply the filter if one is selected
    if (_selectedPriorityFilter != null) {
      completedTasks = completedTasks
          .where((task) => task.priority == _selectedPriorityFilter)
          .toList();
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            _buildHeader(textColor, fontProvider.fontSize),
            Divider(
              color: isDarkMode ? Colors.grey[600] : Colors.grey.shade300,
              thickness: 1.5,
              endIndent: MediaQuery.of(context).size.width * 0.7,
            ),
            SizedBox(height: 20),
            Expanded(
              child: completedTasks.isEmpty
                  ? _buildNoTasksMessage(secondaryTextColor!, fontProvider.fontSize)
                  : _buildCompletedTasksList(completedTasks, taskProvider, context, fontProvider.fontSize),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Completed Tasks',
          style: AppStyles.headingStyle.copyWith(
            fontSize: fontSize + 12,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        IconButton(
          icon: Icon(Icons.filter_list, color: textColor),
          onPressed: _showFilterOptions,
        ),
      ],
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Filter by Priority',
                style: AppStyles.headingStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 16),
              _buildFilterOption('All', null),
              _buildFilterOption('High', 'High'),
              _buildFilterOption('Medium', 'Medium'),
              _buildFilterOption('Low', 'Low'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String label, String? priority) {
    return ListTile(
      title: Text(
        label,
        style: AppStyles.bodyTextStyle,
      ),
      onTap: () {
        setState(() {
          _selectedPriorityFilter = priority;
        });
        Navigator.pop(context);
      },
      trailing: _selectedPriorityFilter == priority
          ? Icon(Icons.check, color: AppColors.primaryColor)
          : null,
    );
  }

  Widget _buildNoTasksMessage(Color textColor, double fontSize) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: AppColors.primaryColor.withOpacity(0.7),
          ),
          SizedBox(height: 16),
          Text(
            "No completed tasks",
            style: AppStyles.bodyTextStyle.copyWith(
              fontSize: fontSize,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedTasksList(
      List<Task> completedTasks, TaskProvider taskProvider, BuildContext context, double fontSize) {
    return ListView.builder(
      itemCount: completedTasks.length,
      itemBuilder: (context, index) {
        final task = completedTasks[index];
        return _buildTaskCard(task, taskProvider, context, fontSize);
      },
    );
  }

  Widget _buildTaskCard(Task task, TaskProvider taskProvider, BuildContext context, double fontSize) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.05),
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
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 30,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  task.title,
                  style: AppStyles.headingStyle.copyWith(
                    fontSize: fontSize + 2,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _priorityTag(task.priority, fontSize),
            ],
          ),
          SizedBox(height: 8),
          _buildTaskDates(task, fontSize),
          SizedBox(height: 8),
          if (task.description.isNotEmpty)
            Text(
              task.description,
              style: AppStyles.bodyTextStyle.copyWith(
                fontSize: fontSize - 2,
                color: Colors.grey[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          SizedBox(height: 8),
          _buildCompletionInfo(task, fontSize),
          SizedBox(height: 8),
          _buildTaskActionButtons(task, taskProvider, context, fontSize),
        ],
      ),
    );
  }

  Widget _priorityTag(String priority, double fontSize) {
    Color color;
    String label;

    switch (priority) {
      case 'High':
        color = Colors.red;
        label = 'High';
        break;
      case 'Medium':
        color = Colors.orange;
        label = 'Medium';
        break;
      case 'Low':
        color = Colors.green;
        label = 'Low';
        break;
      default:
        color = Colors.grey;
        label = 'Normal';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppStyles.bodyTextStyle.copyWith(
          fontSize: fontSize - 2,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTaskDates(Task task, double fontSize) {
    return Row(
      children: [
        Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(
          'Start: ${DateFormat('MMM d, yyyy').format(task.startDate)}',
          style: AppStyles.bodyTextStyle.copyWith(
            fontSize: fontSize - 2,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(width: 16),
        Text(
          'End: ${DateFormat('MMM d, yyyy').format(task.endDate)}',
          style: AppStyles.bodyTextStyle.copyWith(
            fontSize: fontSize - 2,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionInfo(Task task, double fontSize) {
    return Row(
      children: [
        Icon(Icons.task_alt, size: 16, color: Colors.green),
        SizedBox(width: 4),
        Text(
          'Completed on: ${DateFormat('MMM d, yyyy').format(task.endDate)}',
          style: AppStyles.bodyTextStyle.copyWith(
            fontSize: fontSize - 2,
            color: Colors.green[700],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskActionButtons(Task task, TaskProvider taskProvider, BuildContext context, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
            );
          },
          icon: Icon(Icons.info_outline, size: 16, color: Colors.white),
          label: Text("Details", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            taskProvider.undoCompleteTask(taskProvider.completedTasks.indexOf(task));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Task "${task.title}" restored to active tasks.'),
                duration: Duration(seconds: 3),
              ),
            );
          },
          icon: Icon(Icons.undo, size: 16, color: Colors.white),
          label: Text("Restore", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
