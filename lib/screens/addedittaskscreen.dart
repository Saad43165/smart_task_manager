import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:smart_tasks_manager/screens/tasks_provider.dart';

import '../models/task_model.dart';
import '../utils/app_styles.dart';
import '../utils/app_colors.dart';
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

    return Scaffold(
      backgroundColor: Colors.white,
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
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              Divider(
                color: Colors.grey.shade300,
                thickness: 1.5,
                endIndent: MediaQuery.of(context).size.width * 0.7,
              ),
              SizedBox(height: 24),

              // Task Title Field
              _buildTextField('Task Title', _titleController),
              SizedBox(height: 16),

              // Task Description Field
              _buildTextField('Task Description', _descriptionController),
              SizedBox(height: 16),

              // Start Date Field
              _buildDatePicker('Start Date', _startDate, (date) => setState(() => _startDate = date)),
              SizedBox(height: 16),

              // End Date Field
              _buildDatePicker('End Date', _endDate, (date) => setState(() => _endDate = date)),
              SizedBox(height: 16),

              // Priority Dropdown
              _buildPriorityDropdown(),
              SizedBox(height: 24),

              // Save Button
              CustomButton(
                text: widget.task == null ? 'Add Task' : 'Save Changes',
                onPressed: () {
                  final newTask = Task(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    startDate: _startDate ?? DateTime.now(),
                    endDate: _endDate ?? DateTime.now(),
                    priority: _priority,
                  );
                  if (widget.task == null) {
                    taskProvider.addTask(newTask);
                  } else {
                    taskProvider.updateTask(widget.taskIndex!, newTask);
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: label == 'Task Title' ? 'Enter task title' : 'Enter task description',
        prefixIcon: label == 'Task Title' ? Icon(Icons.title, color: AppColors.primaryColor) : Icon(Icons.description, color: AppColors.primaryColor),
        labelStyle: TextStyle(color: AppColors.primaryColor),
        hintStyle: TextStyle(color: Colors.grey.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? selectedDate, Function(DateTime) onDateSelected) {
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
          prefixIcon: Icon(Icons.calendar_today, color: AppColors.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate) : 'Select Date',
          style: AppStyles.bodyTextStyle,
        ),
      ),
    );
  }

  Widget _buildPriorityDropdown() {
    return DropdownButtonFormField<String>(
      value: _priority,
      decoration: InputDecoration(
        labelText: 'Priority',
        prefixIcon: Icon(Icons.priority_high, color: AppColors.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: ['High', 'Medium', 'Low'].map((priority) {
        return DropdownMenuItem(
          value: priority,
          child: Text(priority),
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
