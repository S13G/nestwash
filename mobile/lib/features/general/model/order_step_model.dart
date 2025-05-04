import 'package:flutter/material.dart';

class OrderStep {
  final IconData icon;
  final String title;
  final bool isCompleted;

  OrderStep({
    required this.icon,
    required this.title,
    this.isCompleted = false,
  });
}
