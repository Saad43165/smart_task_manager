import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/task_model.dart';
import '../utils/app_styles.dart';
import '../utils/app_colors.dart';
import 'task_detail_screen.dart';
import 'addedittaskscreen.dart';
import 'tasks_provider.dart';
import 'settings_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import 'profile_screen.dart';
import 'expiring_tasks_screen.dart';
import 'search_screen.dart';
import 'completed_tasks_screen.dart';
import 'themeprovider.dart';
import 'font_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentCategoryIndex = 0;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  Task? _lastDeletedTask;
  int? _lastDeletedIndex;
  Task? _lastCompletedTask;
  int? _lastCompletedIndex;
  Timer? _undoTimer;

  final List<String> categories = ["All Tasks", "Today", "This Week"];

  @override
  void dispose() {
    _undoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontProvider = Provider.of<FontProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : AppColors.primaryColor;
    final secondaryTextColor = isDarkMode ? Colors.grey[300] : Colors.grey[800];

    return Scaffold(
      backgroundColor: bgColor,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          _buildDashboardPage(textColor, secondaryTextColor!, fontProvider.fontSize),
          ExpiringTasksScreen(),
          SearchScreen(),
          CompletedTasksScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTabTapped: _onTabTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: () => _showAddTaskModal(context),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      )
          : null,
    );
  }

  Widget _buildDashboardPage(Color textColor, Color secondaryTextColor, double fontSize) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = _filterTasks(taskProvider.tasks);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          _buildHeader(textColor, fontSize),
          SizedBox(height: 20),
          _buildWelcomeText(fontSize, textColor, secondaryTextColor),
          SizedBox(height: 20),
          _buildCategoryTabs(fontSize),
          SizedBox(height: 20),
          Expanded(child: _buildTaskList(tasks, fontSize)),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildHeader(Color textColor, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Dashboard',
          style: AppStyles.headingStyle.copyWith(
            fontSize: fontSize + 10,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        IconButton(
          icon: Icon(Icons.settings, color: textColor),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeText(double fontSize, Color textColor, Color secondaryTextColor) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Smart Task Manager!',
            style: AppStyles.headingStyle.copyWith(
              fontSize: fontSize + 4,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Manage your tasks efficiently and stay productive.',
            style: AppStyles.bodyTextStyle.copyWith(
              fontSize: fontSize,
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: categories.map((category) {
        int index = categories.indexOf(category);
        bool isSelected = _currentCategoryIndex == index;
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentCategoryIndex = index;
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ]
                  : [],
              border: isSelected
                  ? null
                  : Border.all(color: AppColors.primaryColor.withOpacity(0.6)),
            ),
            child: Text(
              category,
              style: AppStyles.bodyTextStyle.copyWith(
                fontSize: fontSize,
                color: isSelected ? Colors.white : AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Task> _filterTasks(List<Task> tasks) {
    if (_currentCategoryIndex == 1) {
      return tasks.where((task) => isSameDay(task.startDate, DateTime.now())).toList();
    } else if (_currentCategoryIndex == 2) {
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
      return tasks.where((task) {
        return (task.startDate.isAfter(startOfWeek) || isSameDay(task.startDate, startOfWeek)) &&
            (task.startDate.isBefore(endOfWeek) || isSameDay(task.startDate, endOfWeek));
      }).toList();
    }
    return tasks;
  }

  Widget _buildTaskList(List<Task> tasks, double fontSize) {
    return tasks.isEmpty
        ? Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          "No tasks available",
          style: AppStyles.bodyTextStyle.copyWith(
            fontSize: fontSize,
            color: Colors.grey[600],
          ),
        ),
      ),
    )
        : ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildSlidableTaskCard(task, index, fontSize);
      },
    );
  }

  Widget _buildSlidableTaskCard(Task task, int index, double fontSize) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    bool isExpired = task.endDate.isBefore(DateTime.now());
    bool isCompleted = taskProvider.completedTasks.contains(task);

    return GestureDetector(
      onLongPress: () => _markTaskAsCompleted(taskProvider, index, task),
      onTap: () => _openTaskDetails(task),
      child: Slidable(
        key: ValueKey(task.title),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => _editTask(task, index),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                _deleteTask(taskProvider, index, task);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(vertical: 8.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.blue[100]
                : (isExpired ? Colors.grey[200] : Colors.white),
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
          child: _buildTaskContent(task, isExpired, fontSize),
        ),
      ),
    );
  }

  Widget _buildTaskContent(Task task, bool isExpired, double fontSize) {
    return Column(
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
                  color: isExpired ? Colors.red : AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _priorityTag(task.priority, fontSize),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                '${DateFormat('MMM d, yyyy').format(task.startDate)} - ${DateFormat('MMM d, yyyy').format(task.endDate)}',
                style: AppStyles.bodyTextStyle.copyWith(
                  fontSize: fontSize - 2,
                  color: Colors.grey[600],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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
        _statusIndicator(isExpired, fontSize),
      ],
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

  Widget _statusIndicator(bool isExpired, double fontSize) {
    if (isExpired) {
      return Row(
        children: [
          Icon(Icons.warning, color: Colors.red, size: 16),
          SizedBox(width: 4),
          Text(
            'Expired',
            style: AppStyles.bodyTextStyle.copyWith(
              fontSize: fontSize - 2,
              color: Colors.red,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(Icons.access_time, color: Colors.blue, size: 16),
          SizedBox(width: 4),
          Text(
            'Upcoming',
            style: AppStyles.bodyTextStyle.copyWith(
              fontSize: fontSize - 2,
              color: Colors.blue,
            ),
          ),
        ],
      );
    }
  }

  void _markTaskAsCompleted(TaskProvider taskProvider, int index, Task task) {
    setState(() {
      _lastCompletedTask = task;
      _lastCompletedIndex = index;
    });

    taskProvider.completeTask(index);

    _undoTimer?.cancel();
    _undoTimer = Timer(Duration(seconds: 3), () {
      _lastCompletedTask = null;
      _lastCompletedIndex = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${task.title}" marked as completed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            if (_lastCompletedTask != null) {
              taskProvider.undoCompleteTask(_lastCompletedIndex!);
              setState(() {
                _lastCompletedTask = null;
                _lastCompletedIndex = null;
              });
            }
          },
        ),
      ),
    );
  }

  void _deleteTask(TaskProvider taskProvider, int index, Task task) {
    setState(() {
      _lastDeletedTask = task;
      _lastDeletedIndex = index;
    });

    taskProvider.deleteTask(index);

    _undoTimer?.cancel();
    _undoTimer = Timer(Duration(seconds: 3), () {
      _lastDeletedTask = null;
      _lastDeletedIndex = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${task.title}" deleted'),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            if (_lastDeletedTask != null) {
              taskProvider.addTask(_lastDeletedTask!);
              setState(() {
                _lastDeletedTask = null;
                _lastDeletedIndex = null;
              });
            }
          },
        ),
      ),
    );
  }

  void _showAddTaskModal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditTaskScreen()),
    );
  }

  void _editTask(Task task, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditTaskScreen(task: task, taskIndex: index)),
    );
  }

  void _openTaskDetails(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
    );
  }
}
