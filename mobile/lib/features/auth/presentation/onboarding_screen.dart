import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pageController = usePageController();
    final currentPage = useState(0);

    final onboardingItems = [
      OnboardingItem(
        image: 'delivery_image',
        title: 'Premium Laundry Services',
        description:
            'Experience top-quality laundry and dry cleaning services from trusted professionals.',
      ),
      OnboardingItem(
        image: 'wash_and_iron',
        title: 'For Service Providers',
        description:
            'Join our network of professional laundry service providers and grow your business.',
      ),
      OnboardingItem(
        image: 'delivery_man_image',
        title: 'Fast & Reliable',
        description:
            'Enjoy convenient pickup and delivery with real-time order tracking.',
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (index) => currentPage.value = index,
                itemCount: onboardingItems.length,
                itemBuilder: (context, index) {
                  final item = onboardingItems[index];
                  return _buildOnboardingPage(item, theme);
                },
              ),
            ),
            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingItems.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  height: 2.w,
                  width: currentPage.value == index ? 6.w : 2.w,
                  decoration: BoxDecoration(
                    color:
                        currentPage.value == index
                            ? theme.colorScheme.primary
                            : theme.colorScheme.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            // Action buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  NestButton(
                    text: 'Register as Customer',
                    onPressed: () => _navigateToSignup(context, 'customer'),
                  ),
                  SizedBox(height: 2.h),
                  NestOutlinedButton(
                    text: 'Register as Service Provider',
                    onPressed: () => _navigateToSignup(context, 'provider'),
                  ),
                  SizedBox(height: 2.h),
                  TextButton(
                    onPressed: () => context.goNamed('login'),
                    child: Text(
                      'Already have an account? Login',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingItem item, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageWidget(
            imageName: item.image,
            height: 40.h,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 4.h),
          Text(
            item.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            item.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateToSignup(BuildContext context, String accountType) {
    context.pushNamed('signup', queryParameters: {'accountType': accountType});
  }
}

class OnboardingItem {
  final String image;
  final String title;
  final String description;

  const OnboardingItem({
    required this.image,
    required this.title,
    required this.description,
  });
}
