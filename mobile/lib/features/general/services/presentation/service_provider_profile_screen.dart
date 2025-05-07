import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/widgets/additional_info_card_widget.dart';
import 'package:nestcare/features/general/widgets/star_rating_widget.dart';
import 'package:nestcare/providers/services_provider.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ServiceProviderProfileScreen extends ConsumerWidget {
  const ServiceProviderProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final serviceProviderName = ref.watch(selectedServiceProviderNameProvider);
    final isAvailable = ref.watch(serviceProviderAvailabilityProvider);
    final isExpanded = ref.watch(serviceProviderExpandedDescriptionProvider);
    final fullText =
        "$serviceProviderName's expertise in wash & iron service is complemented by her friendly and approachable nature. She enjoys building strong relationships with her clients and takes the time to listen to their needs and concerns. Her focus on customer satisfaction has earned her a loyal following and many repeat clients. ";

    final shortText =
        fullText.length > 150 ? fullText.substring(0, 150) : fullText;

    final services = ref.watch(allServicesProvider);
    final rating = ref.watch(ratingProvider);

    return NestScaffold(
      showBackButton: true,
      title: "Profile",
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: ImageWidget(
                    imageName: "lily_profile_pic",
                    width: double.infinity,
                  ),
                ),
                SizedBox(width: 1.h),
                Column(
                  children: [
                    Text(
                      serviceProviderName,
                      style: theme.textTheme.titleSmall,
                    ),
                    SizedBox(height: 0.4.h),
                    Text(
                      "Laundry Cleaner",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(Icons.star, color: Colors.yellow),
                Text(
                  "4.9",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              width: isAvailable ? 36.w : 44.w,
              padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
              decoration: BoxDecoration(
                color:
                    isAvailable
                        ? Colors.green.withValues(alpha: 0.8)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isAvailable
                          ? Colors.transparent
                          : theme.colorScheme.primaryContainer,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 8,
                    backgroundColor: isAvailable ? Colors.white : Colors.grey,
                  ),
                  SizedBox(width: 1.h),

                  Text(
                    isAvailable ? 'Available' : 'Not available',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color:
                          isAvailable
                              ? Colors.white
                              : theme.colorScheme.primaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Text("Description", style: theme.textTheme.titleSmall),
            SizedBox(height: 1.h),
            RichText(
              text: TextSpan(
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.primaryContainer,
                ),
                children: [
                  TextSpan(text: isExpanded ? fullText : "$shortText..."),
                  TextSpan(
                    text: isExpanded ? "Read less" : "Read more",
                    style: theme.textTheme.bodyLarge?.copyWith(
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
            Text("Service Offerings", style: theme.textTheme.titleSmall),
            SizedBox(height: 3.h),
            SizedBox(
              height: 13.h,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(width: 2.h),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];

                  return Container(
                    height: 12.h,
                    width: 13.h,
                    padding: EdgeInsets.symmetric(vertical: 2.5.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150),
                      color: theme.colorScheme.onPrimary,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ImageWidget(
                          imageName: service.serviceTitleImageName!,
                          height: 5.h,
                          width: 5.h,
                        ),
                        Text(
                          service.serviceTitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 13.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 3.h),
            Text("Rate the seller", style: theme.textTheme.titleSmall),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    ref.read(ratingProvider.notifier).state = index + 1;
                  },
                  child: StarRatingWidget(index: index, rating: rating),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
