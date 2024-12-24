import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../screens/tasks_provider.dart';
import '../screens/themeprovider.dart';
import '../screens/font_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import 'task_detail_screen.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontProvider = Provider.of<FontProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : AppColors.primaryColor;
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[700];

    final searchResults = taskProvider.tasks
        .where((task) => task.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            _buildTitle(textColor, fontProvider.fontSize),
            Divider(
              color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
              thickness: 1.5,
              endIndent: MediaQuery.of(context).size.width * 0.7,
            ),
            SizedBox(height: 20),
            _buildSearchBar(context, textColor, fontProvider.fontSize),
            SizedBox(height: 20),
            Expanded(
              child: searchResults.isEmpty
                  ? _buildNoResultsFound(fontProvider.fontSize, secondaryTextColor!)
                  : _buildSearchResults(searchResults, fontProvider.fontSize, secondaryTextColor!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(Color textColor, double fontSize) {
    return Text(
      'Search Tasks',
      style: AppStyles.headingStyle.copyWith(
        fontSize: fontSize + 12,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, Color textColor, double fontSize) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: AppStyles.bodyTextStyle.copyWith(
                color: textColor,
                fontSize: fontSize,
              ),
              decoration: InputDecoration(
                hintText: 'Search by task title...',
                hintStyle: AppStyles.bodyTextStyle.copyWith(
                  color: textColor.withOpacity(0.5),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14.0),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: textColor),
            onPressed: () {
              setState(() {
                _searchQuery = '';
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsFound(double fontSize, Color secondaryTextColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: secondaryTextColor),
          SizedBox(height: 16),
          Text(
            "No tasks match your search.",
            style: AppStyles.bodyTextStyle.copyWith(
              fontSize: fontSize,
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<Task> searchResults, double fontSize, Color secondaryTextColor) {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final task = searchResults[index];
        return _buildTaskCard(task, fontSize, secondaryTextColor);
      },
    );
  }

  Widget _buildTaskCard(Task task, double fontSize, Color secondaryTextColor) {
    return GestureDetector(
      onTap: () => _openTaskDetails(task),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecorahtion(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  task.title,
                  style: AppStyles.headingStyle.copyWith(
                    fontSize: fontSize + 2,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _priorityIndicator(task.priority, fontSize),
              ],
            ),
            SizedBox(height: 6),
            Text(
              '${DateFormat('MMM d, yyyy').format(task.startDate)} - ${DateFormat('MMM d, yyyy').format(task.endDate)}',
              style: AppStyles.bodyTextStyle.copyWith(
                fontSize: fontSize - 2,
                color: secondaryTextColor,
              ),
            ),
            SizedBox(height: 8),
            Divider(color: Colors.grey.shade300, thickness: 1, height: 20),
            Text(
              task.description.isEmpty ? 'No description available' : task.description,
              style: AppStyles.bodyTextStyle.copyWith(
                fontSize: fontSize - 2,
                color: secondaryTextColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _priorityIndicator(String priority, double fontSize) {
    Color priorityColor;

    switch (priority) {
      case 'High':
        priorityColor = Colors.red;
        break;
      case 'Medium':
        priorityColor = Colors.orange;
        break;
      case 'Low':
        priorityColor = Colors.green;
        break;
      default:
        priorityColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: priorityColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        priority,
        style: AppStyles.bodyTextStyle.copyWith(
          fontSize: fontSize - 4,
          color: priorityColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _openTaskDetails(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
    );
  }
}
