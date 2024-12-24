import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:smart_tasks_manager/screens/tasks_provider.dart';

import '../models/task_model.dart';
import '../utils/app_styles.dart';
import '../utils/app_colors.dart';
import 'themeprovider.dart';
import 'font_provider.dart';
import '../widgets/custom_button.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;
  final int? taskIndex;

  AddEditTaskScreen({this.task, this.taskIndex});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String _priority = "Medium";

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _startDate = widget.task!.startDate;
      _endDate = widget.task!.endDate;
      _priority = widget.task!.priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontProvider = Provider.of<FontProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    // Set background and text colors based on theme
    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : AppColors.primaryColor;
    final hintTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              // Screen Title
              Text(
                widget.task == null ? 'Add Task' : 'Edit Task',
                style: AppStyles.headingStyle.copyWith(
                  fontSize: fontProvider.fontSize + 12,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Divider(
                color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
                thickness: 1.5,
                endIndent: MediaQuery.of(context).size.width * 0.7,
              ),
              SizedBox(height: 24),

              // Task Title Field
              _buildTextField('Task Title', _titleController, textColor, hintTextColor!),
              SizedBox(height: 16),

              // Task Description Field
              _buildTextField('Task Description', _descriptionController, textColor, hintTextColor),
              SizedBox(height: 16),

              // Start Date Field
              _buildDatePicker('Start Date', _startDate, (date) => setState(() => _startDate = date), textColor),
              SizedBox(height: 16),

              // End Date Field
              _buildDatePicker('End Date', _endDate, (date) => setState(() => _endDate = date), textColor),
              SizedBox(height: 16),

              // Priority Dropdown
              _buildPriorityDropdown(textColor),
              SizedBox(height: 24),

              // Save Button
              CustomButton(
                text: widget.task == null ? 'Add Task' : 'Save Changes',
                onPressed: () {
                  if (_validateFields()) {
                    final newTask = Task(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      startDate: _startDate!,
                      endDate: _endDate!,
                      priority: _priority,
                    );
                    if (widget.task == null) {
                      taskProvider.addTask(newTask);
                    } else {
                      taskProvider.updateTask(widget.taskIndex!, newTask);
                    }
                    Navigator.pop(context);
                  } else {
                    _showErrorDialog();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateFields() {
    return _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _startDate != null &&
        _endDate != null;
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Please fill in all the fields before saving.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, Color textColor, Color hintTextColor) {
    return TextField(
      controller: controller,
      style: AppStyles.bodyTextStyle.copyWith(color: textColor, fontSize: Provider.of<FontProvider>(context).fontSize),
      decoration: InputDecoration(
        labelText: label,
        hintText: label == 'Task Title' ? 'Enter task title' : 'Enter task description',
        prefixIcon: Icon(
          label == 'Task Title' ? Icons.title : Icons.description,
          color: textColor,
        ),
        labelStyle: TextStyle(color: textColor),
        hintStyle: TextStyle(color: hintTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor),
        ),
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? selectedDate, Function(DateTime) onDateSelected, Color textColor) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.calendar_today, color: textColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          labelStyle: TextStyle(color: textColor),
        ),
        child: Text(
          selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate) : 'Select Date',
          style: AppStyles.bodyTextStyle.copyWith(
            color: textColor,
            fontSize: Provider.of<FontProvider>(context).fontSize,
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityDropdown(Color textColor) {
    return DropdownButtonFormField<String>(
      value: _priority,
      decoration: InputDecoration(
        labelText: 'Priority',
        prefixIcon: Icon(Icons.priority_high, color: textColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        labelStyle: TextStyle(color: textColor),
      ),
      dropdownColor: Colors.grey[800], // Ensures dropdown adapts to dark mode
      items: ['High', 'Medium', 'Low'].map((priority) {
        return DropdownMenuItem(
          value: priority,
          child: Text(priority, style: TextStyle(color: textColor)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _priority = value!;
        });
      },
    );
  }
}
