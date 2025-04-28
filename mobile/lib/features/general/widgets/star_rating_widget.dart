import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  final int index;
  final int rating;

  const StarRatingWidget({
    super.key,
    required this.index,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: Icon(
        index < rating ? Icons.star : Icons.star_border,
        key: ValueKey(index < rating), // important for AnimatedSwitcher
        color: Colors.amber,
        size: 30,
      ),
    );
  }
}
