import 'package:flutter/material.dart';

class EarningsMetric extends StatelessWidget {
  final String label;
  final String amount;
  final bool dim;
  
  const EarningsMetric({super.key, required this.label, required this.amount, this.dim = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          amount,
          style: TextStyle(
            color: dim ? Colors.white70 : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: (dim ? Colors.white70 : Colors.white).withValues(alpha: 0.8), fontSize: 12),
        ),
      ],
    );
  }
}