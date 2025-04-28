import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderStepButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isCompleted;
  final VoidCallback onTap;

  const OrderStepButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.grey.shade600, size: 24),
            ),
            SizedBox(width: 2.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            Spacer(),
            isCompleted
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.add, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }
}
