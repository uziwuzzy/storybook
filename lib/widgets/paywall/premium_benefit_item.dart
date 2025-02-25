import 'package:flutter/material.dart';

class PremiumBenefitItem extends StatelessWidget {
  final String text;

  const PremiumBenefitItem({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          const Icon(
            Icons.star,
            color: Colors.amber,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 18,
                color: Colors.white,
                shadows: [
                  Shadow(color: Colors.black, blurRadius: 3, offset: Offset(1, 1)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}