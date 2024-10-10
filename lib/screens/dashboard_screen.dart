import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../utils/app_styles.dart';
import '../utils/app_colors.dart';
import 'task_detail_screen.dart';
import 'addedittaskscreen.dart';
import 'tasks_provider.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _selectedDate = DateTime.now();
  int _currentCategoryIndex = 0;
  final List<String> categories = ["All Tasks", "Today", "This Week"];
  Map<int, bool> _completedTaskFlags = {};

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = _filterTasks(taskProvider.tasks);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            // Row for the Dashboard title and settings button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dashboard',
                  style: AppStyles.headingStyle.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.settings, color: AppColors.primaryColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  },
                ),
              ],
            ),
            Divider(
              color: Colors.grey.shade300,
              thickness: 1.5,
              endIndent: MediaQuery.of(context).size.width * 0.7,
            ),
            SizedBox(height: 20),
            _buildCalendar(),
            SizedBox(height: 20),
            _buildCategoryTabs(),
            SizedBox(height: 20),
            Expanded(
              child: tasks.isEmpty
                  ? Center(child: Text("No tasks available"))
                  : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return _buildSlidableTaskCard(task, index);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskModal(context),
        child: Icon(Icons.add),
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

Widget _buildCalendar() {
    return TableCalendar(
      focusedDay: _selectedDate,
      firstDay: DateTime(2000),
      lastDay: DateTime(2100),
      calendarFormat: CalendarFormat.week,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDate = selectedDay;
        });
      },
      selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
    );
  }

  Widget _buildCategoryTabs() {
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
              border: isSelected ? null : Border.all(color: AppColors.primaryColor.withOpacity(0.6)),
            ),
            child: Text(
              category,
              style: AppStyles.bodyTextStyle.copyWith(
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
      return tasks.where((task) => task.startDate.isAfter(startOfWeek) && task.endDate.isBefore(endOfWeek)).toList();
    }
    return tasks;
  }

  Widget _buildSlidableTaskCard(Task task, int index) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    bool isExpired = task.endDate.isBefore(DateTime.now());
    bool isCompleted = _completedTaskFlags[index] ?? false;

    return GestureDetector(
      onLongPress: () {
        setState(() {
          _completedTaskFlags[index] = true;
        });
      },
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
                taskProvider.deleteTask(index);
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
          decoration: BoxDecoration(
            color: isCompleted ? Colors.blue[100] : (isExpired ? Colors.grey[200] : Colors.white),
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
          child: isCompleted
              ? ListTile(
            leading: Icon(Icons.check_circle, color: Colors.blue),
            title: Text(
              'Mark as Completed?',
              style: AppStyles.headingStyle.copyWith(fontSize: 18, color: Colors.blue),
            ),
            onTap: () => _confirmCompletion(taskProvider, index),
          )
              : ListTile(
            contentPadding: EdgeInsets.all(16.0),
            title: Text(
              task.title,
              style: AppStyles.headingStyle.copyWith(
                fontSize: 18,
                color: isExpired ? Colors.red : AppColors.primaryColor,
              ),
            ),
            subtitle: Text(
              '${DateFormat('yyyy-MM-dd').format(task.startDate)} - ${DateFormat('yyyy-MM-dd').format(task.endDate)}',
              style: AppStyles.bodyTextStyle.copyWith(fontSize: 14),
            ),
            trailing: _priorityIcon(task.priority),
            onTap: () => _openTaskDetails(task),
          ),
        ),
      ),
    );
  }

  void _confirmCompletion(TaskProvider taskProvider, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Task Completed'),
          content: Text('Are you sure you have completed this task?'),
          actions: [
            TextButton(
              onPressed: () {
                taskProvider.completeTask(index);
                setState(() {
                  _completedTaskFlags.remove(index);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Task marked as completed')),
                );
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _completedTaskFlags[index] = false;
                });
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
          ],
        );
      },
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
Widget _priorityIcon(String priority) {
  switch (priority) {
    case 'High':
      return Icon(Icons.priority_high, color: Colors.red, size: 24);
    case 'Medium':
      return Icon(Icons.warning, color: Colors.orange, size: 24);
    case 'Low':
      return Icon(Icons.low_priority, color: Colors.green, size: 24);
    default:
      return Icon(Icons.priority_high, color: Colors.grey, size: 24);
  }
}
