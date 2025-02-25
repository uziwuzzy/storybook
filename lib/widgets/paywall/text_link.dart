import 'package:flutter/material.dart';

class TextLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const TextLink({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          color: Colors.white,
          decoration: TextDecoration.underline,
          shadows: [
            Shadow(color: Colors.black, blurRadius: 2, offset: Offset(0.5, 0.5)),
          ],
        ),
      ),
    );
  }
}