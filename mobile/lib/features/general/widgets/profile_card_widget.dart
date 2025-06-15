import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileCardWidget extends HookConsumerWidget {
  const ProfileCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.onSurface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(5.w),
        boxShadow: [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(7.5.w),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
            ),
            child: Icon(Icons.person, color: Colors.white, size: 7.w),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('John Doe', style: theme.textTheme.titleSmall?.copyWith(color: Colors.white)),
                SizedBox(height: 0.5.h),
                Text('john.doe@email.com', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.8))),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.pushNamed("customer_profile"),
            child: Icon(Icons.edit, color: Colors.white.withValues(alpha: 0.8), size: 5.w),
          ),
        ],
      ),
    );
  }
}
