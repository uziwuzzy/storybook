import 'package:flutter/material.dart';

class VoiceOptionItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final Color color;
  final VoidCallback onTap;

  const VoiceOptionItem({
    Key? key,
    required this.icon,
    required this.name,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color.withOpacity(0.8)),
            const SizedBox(width: 16),
            Text(
              name,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 18,
                color: color.withOpacity(0.8),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}