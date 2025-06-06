import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/providers/home_provider.dart';

class LogoutButtonWidget extends ConsumerWidget {
  const LogoutButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Center(
      child: TextButton(
        onPressed: () {
          ref.read(clearAllProviders)();
          context.goNamed("signup", extra: 3);
        },
        child: Text(
          'Log out',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.primary,
            decoration: TextDecoration.underline,
            decorationColor: theme.colorScheme.primary,
            decorationThickness: 2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
