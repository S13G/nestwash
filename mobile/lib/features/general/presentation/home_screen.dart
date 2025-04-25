import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/model/service_model.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:nestcare/shared/widgets/service_card_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final allActiveOrders = [
      ServiceModel(
        serviceTitle: 'Wash & Iron',
        itemCardImageName: 'wash_and_iron',
        status: 'In Progress',
        itemCardBackgroundColor: theme.colorScheme.onPrimary,
        items: [
          ServiceItemModel(item: '1. jeans'),
          ServiceItemModel(item: '2. Shorts with really long name'),
          ServiceItemModel(item: '3. wrappers'),
          ServiceItemModel(item: '4. boxers'),
        ],
      ),
      ServiceModel(
        serviceTitle: 'Wash',
        itemCardImageName: 'wash',
        status: 'Ready',
        itemCardBackgroundColor: theme.colorScheme.primary,
        items: [
          ServiceItemModel(item: '1. jeans'),
          ServiceItemModel(item: '2. Shorts with really long name'),
          ServiceItemModel(item: '3. wrappers'),
          ServiceItemModel(item: '4. boxers'),
        ],
      ),
    ];

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
                      'Nancy',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 4.h,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 14.w),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: null,
                  icon: Icon(Icons.more_vert, color: Colors.white, size: 5.h),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Offers/Discounts', style: theme.textTheme.bodyLarge),
                    TextButton(
                      onPressed: null,
                      child: Text(
                        'See all',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 2.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFF9966), Color(0xFFFF5E62)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withValues(alpha: 0.1),
                        offset: const Offset(0, 8),
                        blurRadius: 30,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '50%',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 5.h,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Limited offer!!',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Get 50% discount for every order ',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 1.5.h,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active Orders', style: theme.textTheme.bodyLarge),
                TextButton(
                  onPressed: null,
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
