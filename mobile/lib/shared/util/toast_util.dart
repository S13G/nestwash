import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ToastUtil {
  static void showSuccessToast(BuildContext context, String message, {Color? color}) {
    _showCustomToast(context, message, backgroundColor: color ?? Theme.of(context).colorScheme.onPrimary, icon: Icons.check_circle);
  }

  static void showErrorToast(BuildContext context, String message) {
    _showCustomToast(context, message, backgroundColor: Theme.of(context).colorScheme.error, icon: Icons.error);
  }

  static void _showCustomToast(BuildContext context, String message, {required Color backgroundColor, required IconData icon}) {
    final theme = Theme.of(context);
    final overlay = Overlay.of(context);

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (context) => _AnimatedToast(
            message: message,
            backgroundColor: backgroundColor,
            icon: icon,
            theme: theme,
            onAnimationComplete: () => overlayEntry.remove(),
          ),
    );

    // Insert the toast
    overlay.insert(overlayEntry);
  }
}

class _AnimatedToast extends HookConsumerWidget {
  final String message;
  final Color backgroundColor;
  final IconData icon;
  final ThemeData theme;
  final VoidCallback onAnimationComplete;

  const _AnimatedToast({
    required this.message,
    required this.backgroundColor,
    required this.icon,
    required this.theme,
    required this.onAnimationComplete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useAnimationController(duration: const Duration(milliseconds: 300), reverseDuration: const Duration(milliseconds: 250));

    final slideAnimation = useMemoized(
      () => Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack, reverseCurve: Curves.easeInBack)),
      [controller],
    );

    final fadeAnimation = useMemoized(
      () => Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn, reverseCurve: Curves.easeOut)),
      [controller],
    );

    final isDismissed = useRef(false);

    final dismissToast = useCallback(() async {
      if (isDismissed.value) return;
      isDismissed.value = true;

      if (controller.isAnimating || controller.isCompleted) {
        await controller.reverse();
      }
      onAnimationComplete();
    }, [controller, onAnimationComplete]);

    // Start animation and auto-dismiss effect
    useEffect(() {
      controller.forward();

      final timer = Timer(const Duration(milliseconds: 1500), () {
        dismissToast();
      });

      return () {
        timer.cancel();
      };
    }, [controller, dismissToast]);

    return Positioned(
      top: 6.h,
      left: 5.w,
      right: 5.w,
      child: SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: dismissToast,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: Colors.white),
                    SizedBox(width: 2.w),
                    Expanded(child: Text(message, style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void useToastEffect(BuildContext context, {String? error, String? success}) {
  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (error != null) {
        ToastUtil.showErrorToast(context, error);
      }
      if (success != null) {
        ToastUtil.showSuccessToast(context, success);
      }
    });
    return null;
  }, [error, success]);
}
