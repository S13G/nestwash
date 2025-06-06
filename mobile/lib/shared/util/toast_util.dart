import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ToastUtil {
  static void showSuccessToast(BuildContext context, String message) {
    _showCustomToast(
      context,
      message,
      backgroundColor: Theme.of(context).colorScheme.primary,
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
    final theme = Theme.of(context);
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: 6.h, // Top margin
            left: 5.w,
            right: 5.w,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
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
                        style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    // Insert the toast
    overlay.insert(overlayEntry);

    // Remove it after some seconds
    Future.delayed(Duration(milliseconds: 1500)).then((value) => overlayEntry.remove());
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
