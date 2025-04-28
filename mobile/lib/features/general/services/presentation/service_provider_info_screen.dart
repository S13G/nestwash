import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/widgets/additional_info_card_widget.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:nestcare/providers/services_provider.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ServiceProviderInfoScreen extends ConsumerWidget {
  const ServiceProviderInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final serviceTitle = ref.watch(selectedServiceTitleProvider);
    final serviceProviderName = ref.watch(selectedServiceProviderNameProvider);
    final isExpanded = ref.watch(serviceProviderExpandedDescriptionProvider);
    final fullText =
        "$serviceProviderName's expertise in wash & iron service is complemented by her friendly and approachable nature. She enjoys building strong relationships with her clients and takes the time to listen to their needs and concerns. Her focus on customer satisfaction has earned her a loyal following and many repeat clients. ";

    final shortText =
        fullText.length > 150 ? fullText.substring(0, 150) : fullText;

    return NestScaffold(
      showBackButton: true,
      title: serviceTitle,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ImageWidget(
                  imageName: 'wash_and_iron_image',
                  width: 40.h,
                  height: 25.h,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              serviceProviderName,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.h),
            RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primaryContainer,
                ),
                children: [
                  TextSpan(text: isExpanded ? fullText : "$shortText..."),
                  TextSpan(
                    text: isExpanded ? "Read less" : "Read more",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            ref
                                .read(
                                  serviceProviderExpandedDescriptionProvider
                                      .notifier,
                                )
                                .state = !isExpanded;
                          },
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AdditionalInfoContainer(title: 'Reviews', value: '4.9'),
                AdditionalInfoContainer(title: 'Jobs Done', value: '+40'),
                AdditionalInfoContainer(title: 'Experience', value: '2 years'),
              ],
            ),
            SizedBox(height: 3.h),
            Text("Cleaning Process", style: theme.textTheme.bodyLarge),
            SizedBox(height: 1.h),
            RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primaryContainer,
                ),
                children: [
                  TextSpan(text: "$serviceProviderName's "),
                  TextSpan(
                    text: "$serviceTitle ",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        "cleaning process involves:  Opti Clean, Dry Clean, Wash, Air dry & Steam press and here is your clothes ready.",
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Text("Pricing", style: theme.textTheme.bodyLarge),
            SizedBox(height: 1.h),
            RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primaryContainer,
                ),
                children: [
                  TextSpan(text: "Each item is "),
                  TextSpan(
                    text: "charged separately.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ServiceItemCard(
                  iconName: 'jacket_icon',
                  price: 2.00,
                  itemName: 'jacket',
                ),
                ServiceItemCard(
                  iconName: 'dress_icon',
                  price: 4.00,
                  itemName: 'dress',
                ),
                ServiceItemCard(
                  iconName: 'tshirt_icon',
                  price: 3.00,
                  itemName: 't-shirt',
                ),
              ],
            ),
            SizedBox(height: 3.h),
            NestButton(text: 'Continue'),
          ],
        ),
      ),
    );
  }
}

class ServiceItemCard extends StatelessWidget {
  const ServiceItemCard({
    super.key,
    required this.iconName,
    required this.itemName,
    required this.price,
  });

  final String iconName;
  final String itemName;
  final double price;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        IconImageWidget(iconName: iconName, width: 5.h, height: 5.h),
        Text(
          itemName[0].toUpperCase() + itemName.substring(1),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primaryContainer,
          ),
        ),
        Text(
          '\$ ${price.toStringAsFixed(2)}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
