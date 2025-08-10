import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/shared/widgets/loader_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../providers/auth_provider.dart' show loadingProvider;

class NestButton extends HookConsumerWidget {
  const NestButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.textColor,
    this.mediumText = false,
    this.prefixIcon,
    this.buttonSize,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final bool mediumText;
  final Icon? prefixIcon;
  final Size? buttonSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loading = ref.watch(loadingProvider);

    return SizedBox(
      width: buttonSize?.width,
      height: buttonSize?.height ?? 7.h,
      child: TextButton(
        onPressed: loading ? null : onPressed,
        style: TextButton.styleFrom(
          backgroundColor:
              loading
                  ? theme.colorScheme.secondaryContainer
                  : color ?? theme.colorScheme.primary,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide.none,
          ),
        ),
        child:
            loading == true
                ? const LoaderWidget()
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (prefixIcon != null) ...[
                      prefixIcon!,
                      SizedBox(width: 2.w),
                    ],
                    Text(
                      text[0].toUpperCase() + text.substring(1).toLowerCase(),
                      style:
                          mediumText
                              ? theme.textTheme.bodyLarge?.copyWith(
                                color: textColor ?? Colors.white,
                                fontWeight: FontWeight.bold,
                              )
                              : theme.textTheme.titleSmall?.copyWith(
                                color: textColor ?? Colors.white,
                              ),
                    ),
                  ],
                ),
      ),
    );
  }
}

class NestOutlinedButton extends HookConsumerWidget {
  const NestOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.textColor,
    this.mediumText = false,
    this.prefixIcon,
    this.buttonSize,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final bool mediumText;
  final Icon? prefixIcon;
  final Size? buttonSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loading = ref.watch(loadingProvider);

    return SizedBox(
      width: buttonSize?.width,
      height: buttonSize?.height ?? 7.h,
      child: OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: BorderSide(
            color: color ?? theme.colorScheme.onPrimaryContainer,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.w),
          ),
        ),
        child:
            loading == true
                ? const LoaderWidget()
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (prefixIcon != null) ...[
                      prefixIcon!,
                      SizedBox(width: 2.w),
                    ],
                    Text(
                      text[0].toUpperCase() + text.substring(1).toLowerCase(),
                      style:
                          mediumText
                              ? theme.textTheme.bodyLarge?.copyWith(
                                color:
                                    textColor ??
                                    theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              )
                              : theme.textTheme.titleSmall?.copyWith(
                                color:
                                    textColor ??
                                    theme.colorScheme.onPrimaryContainer,
                              ),
                    ),
                  ],
                ),
      ),
    );
  }
}
