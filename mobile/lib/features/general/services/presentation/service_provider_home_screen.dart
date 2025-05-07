import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/widgets/menu_options_widget.dart';
import 'package:nestcare/features/general/widgets/service_card_widget.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:nestcare/providers/orders_provider.dart';
import 'package:nestcare/providers/services_provider.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ServiceProviderHomeScreen extends ConsumerWidget {
  const ServiceProviderHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final allActiveOrders = ref.watch(allActiveOrdersProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 2.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 4.h,
                  child: ImageWidget(imageName: 'user_pic'),
                ),
                SizedBox(width: 4.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning!',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primaryContainer,
                      ),
                    ),
                    Text(
                      'William',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontStyle: FontStyle.italic,
                        fontSize: 4.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                MenuOptionsWidget(),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('New Orders', style: theme.textTheme.bodyLarge),
                TextButton(
                  onPressed: () {
                    ref.read(bottomNavigationProvider.notifier).state = 1;
                    ref.read(selectedOrderTabProvider.notifier).state = 2;
                  },
                  child: Text(
                    'See all',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allActiveOrders.length,
            itemBuilder: (context, index) {
              final service = allActiveOrders[index];

              return ServiceCard(service: service);
            },
          ),
          SizedBox(height: 3.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active Orders', style: theme.textTheme.bodyLarge),
                TextButton(
                  onPressed: () {
                    ref.read(bottomNavigationProvider.notifier).state = 1;
                    ref.read(selectedOrderTabProvider.notifier).state = 0;
                  },
                  child: Text(
                    'See all',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allActiveOrders.length,
            itemBuilder: (context, index) {
              final service = allActiveOrders[index];

              return ServiceCard(service: service);
            },
          ),
        ],
      ),
    );
  }
}
