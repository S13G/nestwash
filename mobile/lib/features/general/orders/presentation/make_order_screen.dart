import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/orders/model/order_step_model.dart';
import 'package:nestcare/features/general/widgets/order_step_button_widget.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:nestcare/providers/orders_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MakeOrderScreen extends ConsumerWidget {
  const MakeOrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(orderProgressProvider);
    final currentStep = ref.watch(currentStepProvider);
    final theme = Theme.of(context);

    // Order steps
    final orderSteps = [
      OrderStep(
        icon: Icons.home,
        title: 'Pickup address',
        isCompleted: currentStep > 0,
      ),
      OrderStep(
        icon: Icons.local_shipping,
        title: 'Schedule pick up',
        isCompleted: currentStep > 1,
      ),
      OrderStep(
        icon: Icons.house,
        title: 'Drop off address',
        isCompleted: currentStep > 2,
      ),
      OrderStep(
        icon: Icons.calendar_month,
        title: 'Schedule drop off',
        isCompleted: currentStep > 3,
      ),
    ];

    return NestScaffold(
      showBackButton: true,
      title: 'Place Order',
      padding: EdgeInsets.zero,
      body: Column(
        children: [
          // Progress indicator section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${(progress * 100).toInt()} % complete',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 1.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                    minHeight: 0.8.h,
                  ),
                ),
              ],
            ),
          ),

          // Order steps
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.h),
              child: Column(
                children: [
                  ...orderSteps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: OrderStepButton(
                        icon: step.icon,
                        title: step.title,
                        isCompleted: step.isCompleted,
                        onTap: () {
                          _handleStepTap(ref, index);
                        },
                      ),
                    );
                  }),
                  Spacer(),
                  // Continue button
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: NestButton(
                      text: 'Continue',
                      onPressed: () {
                        _handleContinue(ref, context, currentStep);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleStepTap(WidgetRef ref, int stepIndex) {
    // Update current step and progress when step is tapped
    ref.read(currentStepProvider.notifier).state = stepIndex;

    // Calculate progress based on step
    final newProgress = (stepIndex + 1) / 4;
    ref.read(orderProgressProvider.notifier).state = newProgress;
  }

  void _handleContinue(WidgetRef ref, BuildContext context, int currentStep) {
    if (currentStep < 3) {
      // Move to next step
      final nextStep = currentStep + 1;
      ref.read(currentStepProvider.notifier).state = nextStep;

      // Update progress
      final newProgress = (nextStep + 1) / 4;
      ref.read(orderProgressProvider.notifier).state = newProgress;
    } else {
      // Complete order process
      ToastUtil.showSuccessToast(context, "Order placed successfully");

      // Navigate back or to confirmation screen
      Future.delayed(Duration(seconds: 1), () {
        ref.read(routerProvider).pop();
      });
    }
  }
}
