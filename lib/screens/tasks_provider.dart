import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _completedTasks = [];

  // Getters
  List<Task> get tasks => _tasks;
  List<Task> get completedTasks => _completedTasks;

  // Add a new task
  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  // Update an existing task
  void updateTask(int index, Task updatedTask) {
    _tasks[index] = updatedTask;
    notifyListeners();
  }

  // Delete a task
  void deleteTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  // Mark a task as completed
  void completeTask(int index) {
    Task completedTask = _tasks.removeAt(index);
    _completedTasks.add(completedTask);
    notifyListeners();
  }

  // Undo a completed task
  void undoCompleteTask(int index) {
    Task taskToRestore = _completedTasks.removeAt(index);
    _tasks.add(taskToRestore);
    notifyListeners();
  }

  // Delete a completed task
  void deleteCompletedTask(int index) {
    _completedTasks.removeAt(index);
    notifyListeners();
  }

  // Additional helper methods:

  // Filter tasks by a specific date
  List<Task> filterTasksByDate(DateTime date) {
    return _tasks.where((task) => isSameDay(task.startDate, date)).toList();
  }

  // Filter completed tasks by priority
  List<Task> filterCompletedTasksByPriority(String priority) {
    return _completedTasks.where((task) => task.priority == priority).toList();
  }

  // Clear all completed tasks (e.g., if the user wants to remove them)
  void clearCompletedTasks() {
    _completedTasks.clear();
    notifyListeners();
  }

  // Check if two dates are the same day (helper method)
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
