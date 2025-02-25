import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RatingStars extends StatelessWidget {
  final RxInt rating = 0.obs;
  final int starCount;
  final double size;
  final Color color;
  final Function(int)? onRatingChanged;

  RatingStars({
    Key? key,
    this.starCount = 5,
    this.size = 40,
    this.color = Colors.amber,
    this.onRatingChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        return GestureDetector(
          onTap: () {
            rating.value = index + 1;
            if (onRatingChanged != null) {
              onRatingChanged!(rating.value);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Obx(() => Icon(
              index < rating.value ? Icons.star : Icons.star_border,
              color: color,
              size: size,
            )),
          ),
        );
      }),
    );
  }
}