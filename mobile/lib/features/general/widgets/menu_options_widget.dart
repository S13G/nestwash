import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MenuOptionsWidget extends ConsumerWidget {
  const MenuOptionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        ref.read(routerProvider).pushNamed("customer_menu");
      },
      icon: Icon(Icons.more_vert, color: Colors.white, size: 5.h),
    );
  }
}
