import 'package:flutter/material.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderTrackingScreen extends StatelessWidget {
  final int currentStep;
  final double progressPercentage;

  const OrderTrackingScreen({
    super.key,
    this.currentStep = 6,
    this.progressPercentage = 0.6,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Define the order steps
    final steps = [
      'Order confirmed',
      'Payment confirmed',
      'Pickup arranged',
      'Laundry in process',
      'Laundry complete',
      'Awaiting delivery/pickup',
      'Out for delivery',
      'Delivered',
    ];

    return NestScaffold(
      showBackButton: true,
      title: 'track your order',
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 3.h),

            // Stepper
            Expanded(
              child: CustomStepper(
                steps: steps,
                currentStep: currentStep,
                theme: theme,
              ),
            ),

            // Progress Bar
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Stack(
                children: [
                  // Background
                  Container(
                    height: 2.5.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(
                        alpha: 0.4,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),

                  // Progress
                  FractionallySizedBox(
                    widthFactor: progressPercentage,
                    child: Container(
                      height: 2.5.h,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary, // Royal blue color
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),

                  // Percentage text
                  Center(
                    child: Text(
                      '${(progressPercentage * 100).toInt()}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _buildOrderActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderActions(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.support_agent),
          label: Text('Contact Support'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 1.5.h),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: 2,
          ),
        ),
      ],
    );
  }
}

class CustomStepper extends StatelessWidget {
  final List<String> steps;
  final int currentStep;
  final ThemeData theme;

  const CustomStepper({
    super.key,
    required this.steps,
    required this.currentStep,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Left side with circles and connecting lines
                  _buildLeftSide(),

                  SizedBox(width: 4.w),

                  // Right side with step descriptions
                  _buildRightSide(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeftSide() {
    return Column(
      children: List.generate(steps.length * 2 - 1, (index) {
        // Even indices are the circles (0, 2, 4, etc.)
        if (index % 2 == 0) {
          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex < currentStep;
          final isCurrentStep = stepIndex == currentStep - 1;

          return Container(
            width: 15.w,
            height: 15.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color:
                  isCompleted || isCurrentStep
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primaryContainer.withValues(
                        alpha: 0.6,
                      ),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: Text(
              '${stepIndex + 1}',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          );
        }
        // Odd indices are the connecting lines (1, 3, 5, etc.)
        else {
          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex < currentStep - 1;

          return Container(
            width: 1.5.w,
            height: 10.h,
            color:
                isCompleted
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
          );
        }
      }),
    );
  }

  Widget _buildRightSide() {
    return Expanded(
      child: Column(
        children: List.generate(steps.length * 2 - 1, (index) {
          // Even indices are the step descriptions (0, 2, 4, etc.)
          if (index % 2 == 0) {
            final stepIndex = index ~/ 2;
            final isCompleted = stepIndex < currentStep;
            final isCurrentStep = stepIndex == currentStep - 1;

            return Container(
              height: 15.w,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color:
                    isCompleted || isCurrentStep
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color:
                      isCompleted || isCurrentStep
                          ? Colors.transparent
                          : theme.colorScheme.primaryContainer.withValues(
                            alpha: 0.6,
                          ),
                  width: 1,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Text(
                steps[stepIndex],
                style: theme.textTheme.bodyLarge?.copyWith(
                  color:
                      isCompleted || isCurrentStep
                          ? Colors.white
                          : theme.colorScheme.primaryContainer.withValues(
                            alpha: 0.6,
                          ),
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
          // Odd indices are the spacers (1, 3, 5, etc.)
          else {
            return SizedBox(height: 10.h);
          }
        }),
      ),
    );
  }
}
