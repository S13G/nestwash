import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/presentation/customer/customer_discount_screen.dart';
import 'package:nestcare/features/general/presentation/customer/customer_home_screen.dart';
import 'package:nestcare/features/general/presentation/notifications_screen.dart';
import 'package:nestcare/features/general/services/presentation/laundry_services_screen.dart';
import 'package:nestcare/features/general/services/presentation/service_provider_chat_list_screen.dart';
import 'package:nestcare/features/general/services/presentation/service_provider_discounts_screen.dart';
import 'package:nestcare/features/general/services/presentation/service_provider_home_screen.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:nestcare/providers/notifications_provider.dart';
import 'package:nestcare/providers/user_provider.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'customer/laundry_orders_screen.dart' show LaundryOrdersScreen;

class BottomNavScreen extends ConsumerWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavigationProvider);
    final accountType = ref.read(userProvider)?.accountType;

    final List<Widget> screens;
    if (accountType == "service_provider") {
      screens = [
        const ServiceProviderHomeScreen(),
        const LaundryOrdersScreen(),
        const ServiceProviderChatListScreen(),
        const ServiceProviderDiscountsScreen(),
        const NotificationsScreen(),
      ];
    } else {
      screens = [
        const CustomerHomeScreen(),
        const LaundryOrdersScreen(),
        const LaundryServicesScreen(),
        const CustomerDiscountScreen(),
        const NotificationsScreen(),
      ];
    }

    return NestScaffold(
      appBar: null,
      padding: EdgeInsets.only(top: 4.h, left: 4.h, right: 4.h),
      body: SafeArea(child: screens[selectedIndex]),
      bottomNavigationBar: const NestCareBottomNavBar(),
    );
  }
}

class NestCareBottomNavBar extends ConsumerWidget {
  const NestCareBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedIndex = ref.watch(bottomNavigationProvider);
    final accountType = ref.read(userProvider)?.accountType;

    final unreadNotifications = ref.watch(allUnreadNotificationsProvider);
    final hasUnreadNotifications = unreadNotifications.isNotEmpty;

    return Container(
      height: 7.h,
      margin: EdgeInsets.all(4.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (index) {
          final icons =
              accountType == "service_provider"
                  ? ['home', 'orders', 'chats', 'discounts', 'notifications']
                  : ['home', 'orders', 'services', 'discounts', 'notifications'];

          return Expanded(
            child: GestureDetector(
              onTap: () => ref.read(bottomNavigationProvider.notifier).state = index,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (index == 4)
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconImageWidget(
                          iconName: icons[index],
                          width: 4.h,
                          height: 4.h,
                          color: Colors.white,
                        ),
                        // Conditionally show the dot based on hasUnreadNotifications
                        if (hasUnreadNotifications)
                          Positioned(
                            top: 4,
                            right: 7,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    )
                  else
                    IconImageWidget(
                      iconName: icons[index],
                      width: 4.h,
                      height: 4.h,
                      color: Colors.white,
                    ),
                  SizedBox(height: 0.8.h),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 0.4.h,
                    width: 4.h,
                    decoration: BoxDecoration(
                      color: selectedIndex == index ? Colors.white : Colors.transparent,
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
