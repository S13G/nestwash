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
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            GoRouter.of(context).pop();
                          },
                        )
                        : null,
                title: Text(title![0].toUpperCase() + title!.substring(1)),
                actions: actions,
              )
              : null),
      body:
          padding == EdgeInsets.zero
              ? body
              : Padding(
                padding:
                    padding ??
                    EdgeInsets.only(left: 4.h, right: 4.h, bottom: 8.h),
                child: body,
              ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
