import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _completedTasks = [];

  // Getters
  List<Task> get tasks => List.unmodifiable(_tasks); // Immutable copy
  List<Task> get completedTasks => List.unmodifiable(_completedTasks); // Immutable copy

  // Add a new task (Prevent duplicates by checking the title)
  void addTask(Task task) {
    if (!_tasks.any((t) => t.title == task.title)) {
      _tasks.add(task);
      notifyListeners();
    }
  }

  // Update an existing task
  void updateTask(int index, Task updatedTask) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  // Delete a task
  void deleteTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
      notifyListeners();
    }
  }

  // Mark a task as completed
  void completeTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      Task completedTask = _tasks.removeAt(index);
      _completedTasks.add(completedTask);
      notifyListeners();
    }
  }

  // Undo a completed task
  void undoCompleteTask(int index) {
    if (index >= 0 && index < _completedTasks.length) {
      Task taskToRestore = _completedTasks.removeAt(index);
      _tasks.add(taskToRestore);
      notifyListeners();
    }
  }

  // Delete a completed task
  void deleteCompletedTask(int index) {
    if (index >= 0 && index < _completedTasks.length) {
      _completedTasks.removeAt(index);
      notifyListeners();
    }
  }

  // Clear all completed tasks
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

  // Filter tasks based on category: "All Tasks", "Today", or "This Week"
  List<Task> filterTasks(String category) {
    if (category == "Today") {
      // Filter tasks for today
      return _tasks.where((task) => isSameDay(task.startDate, DateTime.now())).toList();
    } else if (category == "This Week") {
      // Filter tasks for this week
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
      return _tasks.where((task) =>
      (task.startDate.isAfter(startOfWeek) || isSameDay(task.startDate, startOfWeek)) &&
          (task.startDate.isBefore(endOfWeek) || isSameDay(task.startDate, endOfWeek))
      ).toList();
    }
    // Return all tasks if "All Tasks" is selected
    return _tasks;
  }

  // Filter tasks by a specific date
  List<Task> filterTasksByDate(DateTime date) {
    return _tasks.where((task) => isSameDay(task.startDate, date)).toList();
  }

  // Filter completed tasks by priority
  List<Task> filterCompletedTasksByPriority(String priority) {
    return _completedTasks.where((task) => task.priority == priority).toList();
  }

  // Get a task by its title
  Task? getTaskByTitle(String title) {
    try {
      return _tasks.firstWhere((task) => task.title == title);
    } catch (e) {
      return null; // Return null if no task is found
    }
  }

  // Sort tasks by start date (ascending or descending)
  void sortTasksByDate({bool ascending = true}) {
    _tasks.sort((a, b) => ascending ? a.startDate.compareTo(b.startDate) : b.startDate.compareTo(a.startDate));
    notifyListeners();
  }
}
