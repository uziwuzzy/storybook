import 'package:flutter/material.dart';
import 'package:storybook/config/app_colors.dart';

class SubscriptionOption extends StatelessWidget {
  final String title;
  final String price;
  final String perPeriod;
  final String? originalPrice;
  final String? discount;
  final bool isPopular;
  final VoidCallback onTap;

  const SubscriptionOption({
    Key? key,
    required this.title,
    required this.price,
    required this.perPeriod,
    this.originalPrice,
    this.discount,
    required this.isPopular,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main container
          Container(
            padding: EdgeInsets.fromLTRB(16, isPopular ? 24 : 16, 16, 16),
            decoration: BoxDecoration(
              color: isPopular ? Colors.amber.withOpacity(0.9) : Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: isPopular
                  ? Border.all(color: Colors.amber.shade800, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Baloo',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isPopular ? Colors.black87 : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  price,
                  style: TextStyle(
                    fontFamily: 'Baloo',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isPopular ? Colors.black87 : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  perPeriod,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    color: isPopular ? Colors.black87.withOpacity(0.7) : Colors.grey.shade700,
                  ),
                ),
                if (originalPrice != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    originalPrice!,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Discount badge
          if (isPopular && discount != null)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Text(
                  discount!,
                  style: const TextStyle(
                    fontFamily: 'Baloo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          // Most popular badge
          if (isPopular)
            Positioned(
              top: -15,
              left: 0,
              right: 0,
              child: Container(
                height: 30,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade800,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      "BEST VALUE",
                      style: TextStyle(
                        fontFamily: 'Baloo',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}