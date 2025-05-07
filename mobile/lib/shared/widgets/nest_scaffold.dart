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
                        ? IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: theme.colorScheme.secondary,
                          ),
                          onPressed:
                              backButtonOnPressed ??
                              () {
                                context.pop();
                              },
                        )
                        : null,
                title: Text(
                  title![0].toUpperCase() + title!.substring(1),
                  style: theme.textTheme.titleMedium,
                ),
                actions: actions,
              )
              : null),
      body:
          padding == EdgeInsets.zero
              ? SafeArea(child: body)
              : Padding(
                padding:
                    padding ??
                    EdgeInsets.only(left: 4.h, right: 4.h, bottom: 6.h),
                child: SafeArea(child: body),
              ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
