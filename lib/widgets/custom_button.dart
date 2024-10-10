import 'package:flutter/material.dart';
import 'package:smart_tasks_manager/utils/app_colors.dart';
import 'package:smart_tasks_manager/utils/app_styles.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    Key? key,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        // Delay to allow the animation before calling the function
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) {
            widget.onPressed();
          }
        });
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: Transform.scale(
        scale: _isPressed ? 0.95 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? (_isPressed
                ? AppColors.primaryColor.withOpacity(0.7)
                : AppColors.primaryColor)
                : (_isPressed
                ? AppColors.accentColor.withOpacity(0.7)
                : AppColors.accentColor),
            borderRadius: BorderRadius.circular(8),
            boxShadow: _isPressed
                ? []
                : [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: AppStyles.buttonTextStyle.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
