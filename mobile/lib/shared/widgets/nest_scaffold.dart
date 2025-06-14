import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NestScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool showBackButton;
  final VoidCallback? backButtonOnPressed;

  const NestScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.padding,
    this.backgroundColor,
    this.showBackButton = false,
    this.backButtonOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      appBar:
          appBar ??
          (title != null
              ? AppBar(
                leading:
                    showBackButton
                        ? GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.secondary, size: 5.w),
                        )
                        : null,
                title: Text(title!.split(' ').map((word) => word[0].toUpperCase() + word.substring(1)).join(' '), style: theme.textTheme.titleMedium),
                actions: actions,
              )
              : null),
      body:
          padding == EdgeInsets.zero
              ? SafeArea(child: body)
              : Padding(padding: padding ?? EdgeInsets.only(left: 4.h, right: 4.h), child: SafeArea(child: body)),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
