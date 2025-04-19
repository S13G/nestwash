import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NestScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry? padding;

  const NestScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          appBar ??
          (title != null
              ? AppBar(title: Text(title!), actions: actions)
              : null),
      body:
          padding == EdgeInsets.zero
              ? body
              : Padding(
                padding:
                    padding ??
                    EdgeInsets.symmetric(horizontal: 4.h, vertical: 4.h),
                child: body,
              ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
