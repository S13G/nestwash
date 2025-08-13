import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ToastUtil {
  static OverlayEntry? _currentToast;
  static Timer? _currentTimer;

  static void showSuccessToast(
    BuildContext context,
    String message, {
    Color? color,
  }) {
    _showCustomToast(
      context,
      message,
      backgroundColor: color ?? Theme.of(context).colorScheme.onPrimary,
      icon: Icons.check_circle,
    );
  }

  static void showErrorToast(BuildContext context, String message) {
    _showCustomToast(
      context,
      message,
      backgroundColor: Theme.of(context).colorScheme.error,
      icon: Icons.error,
    );
  }

  static void _showCustomToast(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required IconData icon,
  }) {
    // Remove existing toast if present
    _dismissCurrentToast();

    final theme = Theme.of(context);
    final overlay = Overlay.of(context);

    _currentToast = OverlayEntry(
      builder:
          (context) => _AnimatedToast(
            message: message,
            backgroundColor: backgroundColor,
            icon: icon,
            theme: theme,
            onAnimationComplete: () {
              _dismissCurrentToast();
            },
          ),
    );

    // Insert the new toast
    overlay.insert(_currentToast!);
  }

  static void _dismissCurrentToast() {
    try {
      _currentTimer?.cancel();
      _currentTimer = null;

      if (_currentToast?.mounted == true) {
        _currentToast?.remove();
      }
      _currentToast = null;
    } catch (e) {
      debugPrint('Toast dismissal error: $e');
    }
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
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 250),
    );

    final slideAnimation = useMemoized(
      () => Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInBack,
        ),
      ),
      [controller],
    );

    final fadeAnimation = useMemoized(
      () => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeIn,
          reverseCurve: Curves.easeOut,
        ),
      ),
      [controller],
    );

    final isDismissed = useRef(false);
    final localTimer = useRef<Timer?>(null);

    final dismissToast = useCallback(() async {
      if (isDismissed.value) return;
      isDismissed.value = true;

      // Cancel local timer
      localTimer.value?.cancel();
      localTimer.value = null;

      try {
        if (controller.status == AnimationStatus.completed ||
            controller.status == AnimationStatus.forward) {
          await controller.reverse();
        }
      } catch (e) {
        debugPrint('Toast animation error: $e');
      } finally {
        onAnimationComplete();
      }
    }, [controller, onAnimationComplete]);

    // Start animation and auto-dismiss effect
    useEffect(() {
      controller.forward();

      // Use local timer instead of static timer
      localTimer.value = Timer(const Duration(milliseconds: 1400), () {
        if (!isDismissed.value) {
          dismissToast();
        }
      });

      // Also store in ToastUtil for external cancellation
      ToastUtil._currentTimer = localTimer.value;

      return () {
        localTimer.value?.cancel();
        localTimer.value = null;
      };
    }, [controller, dismissToast]);

    // Handle widget disposal
    useEffect(() {
      return () {
        if (!isDismissed.value) {
          localTimer.value?.cancel();
          onAnimationComplete();
        }
      };
    }, []);

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
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: Colors.white),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        message,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
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
