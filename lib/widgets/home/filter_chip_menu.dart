import "package:flutter/material.dart";

class FilterChipMenu extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;
  final IconData? icon;

  const FilterChipMenu({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if we're in landscape mode on a small device
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final isSmallDevice = MediaQuery.of(context).size.width < 600;
    final useCompactMode = isLandscape && isSmallDevice;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: useCompactMode ? 6 : 10),
        padding: EdgeInsets.symmetric(
            horizontal: useCompactMode ? 10 : 14,
            vertical: useCompactMode ? 6 : 8
        ),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.transparent : color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: useCompactMode ? 14 : 16,
                color: isSelected ? Colors.white : color,
              ),
              SizedBox(width: useCompactMode ? 4 : 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: "Nunito",
                fontSize: useCompactMode ? 12 : 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}