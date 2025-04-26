import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/orders/presentation/orders_screen.dart';
import 'package:nestcare/features/general/presentation/discounts_screen.dart';
import 'package:nestcare/features/general/presentation/home_screen.dart';
import 'package:nestcare/features/general/services/presentation/services_screen.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BottomNavScreen extends ConsumerWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavigationProvider);

    final screens = [
      HomeScreen(),
      OrdersScreen(),
      ServicesScreen(),
      DiscountsScreen(),
    ];

    return NestScaffold(
      appBar: null,
      padding: EdgeInsets.only(top: 4.h, left: 4.h, right: 4.h),
      body: SafeArea(child: screens[selectedIndex]),
      bottomNavigationBar: NestCareBottomNavBar(),
    );
  }
}

class NestCareBottomNavBar extends ConsumerWidget {
  const NestCareBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedIndex = ref.watch(bottomNavigationProvider);

    return Container(
      height: 7.h,
      margin: EdgeInsets.all(4.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) {
          final icons = ['home', 'orders', 'services', 'discounts'];

          return Expanded(
            child: GestureDetector(
              onTap:
                  () =>
                      ref.read(bottomNavigationProvider.notifier).state = index,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconImageWidget(
                    iconName: icons[index],
                    width: 4.h,
                    height: 4.h,
                  ),
                  SizedBox(height: 0.8.h),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 0.4.h,
                    width: 4.h,
                    decoration: BoxDecoration(
                      color:
                          selectedIndex == index
                              ? Colors.white
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
