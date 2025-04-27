import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/shared/widgets/loader_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../providers/auth_provider.dart' show loadingProvider;

class NestButton extends ConsumerWidget {
  const NestButton({super.key, required this.text, this.onPressed, this.color});

  final String text;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loading = ref.watch(loadingProvider);

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: Size(double.infinity, 5.5.h),
        backgroundColor: color ?? theme.colorScheme.primary,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide.none,
        ),
      ),
      child:
          loading == true
              ? const LoaderWidget()
              : Text(
                text[0].toUpperCase() + text.substring(1).toLowerCase(),
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
    );
  }
}
