import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/widgets/profile_card_widget.dart';
import 'package:nestcare/providers/orders_provider.dart';
import 'package:nestcare/providers/services_provider.dart';
import 'package:nestcare/providers/user_provider.dart';
import 'package:nestcare/shared/widgets/active_text_button.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedTab = ref.watch(selectedOrderTabProvider);
    final allActiveOrders = ref.watch(allActiveOrdersProvider);
    final accountType = ref.read(userProvider)?.accountType;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileCardWidget(theme: theme),
        SizedBox(height: 3.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Orders", style: theme.textTheme.bodyLarge),
              SizedBox(height: 3.h),
              Row(
                children: [
                  ActiveTextButton(
                    theme: theme,
                    selectedTab: selectedTab,
                    onPressed: () {
                      ref.read(selectedOrderTabProvider.notifier).state = 0;
                    },
                    text: "Active (0)",
                    selectedNumber: 0,
                  ),
                  SizedBox(width: 8.w),
                  ActiveTextButton(
                    theme: theme,
                    selectedTab: selectedTab,
                    onPressed: () {
                      ref.read(selectedOrderTabProvider.notifier).state = 1;
                    },
                    text: "Past",
                    selectedNumber: 1,
                  ),
                  if (accountType == "service_provider") ...[
                    SizedBox(width: 8.w),
                    ActiveTextButton(
                      theme: theme,
                      selectedTab: selectedTab,
                      onPressed: () {
                        ref.read(selectedOrderTabProvider.notifier).state = 2;
                      },
                      text: "New",
                      selectedNumber: 2,
                    ),
                  ],
                ],
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: Column(
                    children: [
                      ImageWidget(
                        imageName: 'empty_orders',
                        width: 67.w,
                        height: 20.h,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        "Your orders history is empty..",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.primaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
