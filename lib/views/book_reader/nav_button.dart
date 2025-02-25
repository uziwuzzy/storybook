import 'package:flutter/material.dart';
import 'package:storybook/config/app_colors.dart';

class NavButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback? onPressed;

  const NavButton({
    Key? key,
    required this.icon,
    required this.isActive,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: isActive ? AppColors.primary : Colors.grey,
        ),
        onPressed: onPressed,
      ),
    );
  }
}