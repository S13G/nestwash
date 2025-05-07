import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MenuOptionsWidget extends ConsumerWidget {
  const MenuOptionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        context.pushNamed("customer_menu");
      },
      icon: Icon(Icons.more_vert, color: theme.colorScheme.primary, size: 5.h),
    );
  }
}
