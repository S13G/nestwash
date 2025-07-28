import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/features/general/services/controller/rating_controller.dart';
import 'package:nestcare/features/general/services/model/rating_submission_model.dart';
import 'package:nestcare/features/general/services/model/service_provider_model.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_form_fields.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:go_router/go_router.dart';

class RatingModal extends HookConsumerWidget {
  final ServiceProvider provider;

  const RatingModal({super.key, required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final commentController = useTextEditingController();
    final rating = useState<double>(5.0);
    final serviceType = useState<String>('Regular Cleaning');

    final ratingState = ref.watch(ratingControllerProvider);

    // Listen to state changes
    ref.listen<RatingSubmissionState>(ratingControllerProvider, (
      previous,
      next,
    ) {
      if (next.success != null) {
        ToastUtil.showSuccessToast(context, next.success!);
        context.pop();
        ref.read(ratingControllerProvider.notifier).clearState();
      }
      if (next.error != null) {
        ToastUtil.showErrorToast(context, next.error!);
      }
    });

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.onTertiaryContainer,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Rate ${provider.name}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(
                    LucideIcons.x,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.w),

            // Rating Stars
            Text(
              'Your Rating',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSecondary,
              ),
            ),
            SizedBox(height: 2.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    rating.value = (index + 1).toDouble();
                  },
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    child: Icon(
                      Icons.star_rounded,
                      size: 10.w,
                      color:
                          index < rating.value.floor()
                              ? Colors.amber
                              : Colors.grey.withValues(alpha: 0.3),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 4.w),

            // Service Type Dropdown
            Text(
              'Service Type',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSecondary,
              ),
            ),
            SizedBox(height: 2.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: serviceType.value,
                  isExpanded: true,
                  icon: Icon(
                    LucideIcons.chevronDown,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: 4.w,
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSecondary,
                  ),
                  dropdownColor: theme.colorScheme.onTertiaryContainer,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      serviceType.value = newValue;
                    }
                  },
                  items:
                      [
                        'Regular Cleaning',
                        'Express Cleaning',
                        'Dry Cleaning',
                        'Stain Removal',
                        'Ironing',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
              ),
            ),
            SizedBox(height: 4.w),

            // Comment Field
            Text(
              'Your Review',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSecondary,
              ),
            ),
            SizedBox(height: 2.w),
            NestFormField(
              controller: commentController,
              hintText: 'Share your experience...',
              maxLines: 4,
              belowSpacing: false,
            ),
            SizedBox(height: 6.w),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: NestButton(
                text: 'Submit Rating',
                onPressed:
                    ratingState.isLoading
                        ? null
                        : () {
                          if (!_validateRatingSubmission(
                            context,
                            commentController.text,
                            serviceType.value,
                          )) {
                            return;
                          }

                          ref
                              .read(ratingControllerProvider.notifier)
                              .submitRating(
                                serviceProviderId: provider.id,
                                rating: rating.value,
                                comment: commentController.text.trim(),
                                serviceType: serviceType.value,
                              );
                        },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateRatingSubmission(
    BuildContext context,
    String comment,
    String serviceType,
  ) {
    if (comment.trim().isEmpty) {
      ToastUtil.showErrorToast(context, 'Please write a review comment');
      return false;
    }
    if (serviceType.isEmpty) {
      ToastUtil.showErrorToast(context, 'Please select a service type');
      return false;
    }
    return true;
  }
}
