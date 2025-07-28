import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/features/general/widgets/order_step_button_widget.dart';
import 'package:nestcare/providers/orders_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MakeOrderScreen extends ConsumerWidget {
  const MakeOrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final progress = ref.watch(orderProgressProvider);
    final currentStep = ref.watch(currentStepProvider);
    final completedSteps = ref.watch(completedStepsProvider);

    final orderSteps = [
      {'title': 'Pickup address', 'icon': LucideIcons.mapPinHouse},
      {'title': 'Schedule pick up', 'icon': LucideIcons.truck},
      {'title': 'Drop off address', 'icon': LucideIcons.mapPinHouse},
      {'title': 'Schedule drop off', 'icon': LucideIcons.calendarDays},
      {'title': 'Clothes', 'icon': LucideIcons.boxes},
    ];

    return NestScaffold(
      showBackButton: true,
      title: 'Place Order',
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${(progress * 100).toInt()}% complete',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: theme.colorScheme.secondaryContainer
                        .withValues(alpha: 0.5),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                    minHeight: 0.8.h,
                  ),
                ),
              ],
            ),
          ),

          // Steps
          Expanded(
            child: Column(
              children: [
                ...orderSteps.asMap().entries.map((entry) {
                  final index = entry.key;
                  final step = entry.value;

                  final isEnabled = index == 0 || completedSteps[index - 1];
                  final isCompleted = completedSteps[index];

                  return Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: OrderStepButton(
                      icon: step['icon'] as IconData,
                      title: step['title'] as String,
                      isCompleted: isCompleted,
                      isEnabled: isEnabled,
                      onTap: () => _navigateToStep(context, ref, index),
                    ),
                  );
                }),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: NestButton(
                    text: 'Continue',
                    onPressed: () => _handleContinue(ref, context, currentStep),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToStep(
    BuildContext context,
    WidgetRef ref,
    int stepIndex,
  ) async {
    ref.read(currentStepProvider.notifier).state = stepIndex;

    // Pick the correct screen based on stepIndex
    String namedRoute;
    switch (stepIndex) {
      case 0:
        namedRoute = 'customer_addresses';
        break;
      case 1:
        namedRoute = 'schedule_pickup';
        break;
      case 2:
        namedRoute = 'customer_addresses';
        break;
      case 3:
        namedRoute = 'schedule_drop_off';
        break;
      case 4:
        namedRoute = 'clothes';
      default:
        return;
    }

    final result = await context.pushNamed(namedRoute);

    if (result == true) {
      ref.read(currentStepProvider.notifier).state = stepIndex;

      completeStep(ref, stepIndex);
    }
  }

  void _handleContinue(WidgetRef ref, BuildContext context, int currentStep) {
    final completed = [...ref.read(completedStepsProvider)];

    if (!completed[currentStep]) {
      ToastUtil.showErrorToast(context, 'Please complete this step first.');
      return;
    }

    if (currentStep < 3) {
      ref.read(currentStepProvider.notifier).state = currentStep + 1;
    } else {
      ToastUtil.showSuccessToast(context, 'Order placed successfully');
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!context.mounted) return;
        context.goNamed("order_details");
      });
    }
  }

  void completeStep(WidgetRef ref, int stepIndex) {
    final completed = [...ref.read(completedStepsProvider)];
    completed[stepIndex] = true;
    ref.read(completedStepsProvider.notifier).state = completed;

    // Update progress
    final newProgress =
        completed.where((step) => step).length / completed.length;
    ref.read(orderProgressProvider.notifier).state = newProgress;
  }
}
