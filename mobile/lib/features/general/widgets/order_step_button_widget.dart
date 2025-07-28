import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderStepButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isCompleted;
  final bool isEnabled;
  final VoidCallback? onTap;

  const OrderStepButton({
    super.key,
    required this.icon,
    required this.title,
    required this.isCompleted,
    required this.isEnabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
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
                  color: theme.colorScheme.secondaryContainer.withValues(
                    alpha: 0.2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color:
                      isCompleted
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primaryContainer,
                  size: 24,
                ),
              ),
              SizedBox(width: 2.h),
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color:
                      isCompleted
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primaryContainer,
                ),
              ),
              Spacer(),
              isCompleted
                  ? Icon(LucideIcons.badgeCheck, color: Colors.green)
                  : Icon(
                    LucideIcons.plus,
                    color: theme.colorScheme.primaryContainer,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
