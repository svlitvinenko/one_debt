import 'package:flutter/material.dart';

class DSPersonRating extends StatelessWidget {
  final double rating;
  const DSPersonRating({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final int rating = this.rating.clamp(0, 5).floor();
    final int colored = rating;
    final int grey = 5 - rating;
    return SizedBox(
      height: 12,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(
            colored,
            (index) => Padding(
              padding: EdgeInsets.only(right: index == 4 ? 0 : 1),
              child: const Icon(
                Icons.star_sharp,
                size: 12,
              ),
            ),
          ),
          ...List.generate(
            grey,
            (index) => Padding(
              padding: EdgeInsets.only(right: colored + index + 1 == 5 ? 0 : 1),
              child: const Icon(
                Icons.star_outline_sharp,
                size: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
