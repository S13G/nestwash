import 'package:flutter/material.dart';

class ActiveTextButton extends StatelessWidget {
  const ActiveTextButton({
    super.key,
    required this.theme,
    required this.selectedTab,
    required this.onPressed,
    required this.text,
    required this.selectedNumber,
  });

  final ThemeData theme;
  final int selectedTab;
  final VoidCallback? onPressed;
  final String text;
  final int selectedNumber;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor:
            selectedTab == selectedNumber
                ? theme.colorScheme.onPrimary
                : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color:
                selectedTab == selectedNumber
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.primaryContainer,
          ),
        ),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color:
              selectedTab == selectedNumber
                  ? Colors.white
                  : theme.colorScheme.primaryContainer,
        ),
      ),
    );
  }
}
