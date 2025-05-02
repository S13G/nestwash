import 'package:flutter/material.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NestScaffold(
      title: 'support',
      showBackButton: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconImageWidget(
                iconName: 'support_icon',
                width: 5.h,
                height: 5.h,
              ),
              SizedBox(width: 3.w),
              Text('Support Service', style: theme.textTheme.titleLarge),
            ],
          ),
          SizedBox(height: 2.h),
          RichText(
            text: TextSpan(
              style: theme.textTheme.bodyLarge,
              children: [
                TextSpan(
                  text:
                      "Nestwash support center is available to assist you everyday between ",
                ),
                TextSpan(
                  text: "10:00am - 10:00pm",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'For any feedback, suggestions or complaints, please reach out to us on:',
          ),
          SizedBox(height: 1.h),
          Text(
            'support@nestcare.com',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),
          Divider(),
          Center(
            child: ImageWidget(
              imageName: 'nestcare_logo',
              color: theme.colorScheme.primary,
              width: 14.h,
              height: 8.h,
            ),
          ),
        ],
      ),
    );
  }
}
