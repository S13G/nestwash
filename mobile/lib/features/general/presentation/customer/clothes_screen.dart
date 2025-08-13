import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/providers/orders_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/loader_widget.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ClothesScreen extends HookConsumerWidget {
  const ClothesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final images = ref.watch(selectedImagesProvider);
    final itemCount = ref.watch(selectedItemsCountProvider);
    final isLoading = ref.watch(isImageUploadingProvider);
    final notes = ref.watch(notesProvider);
    final animations = useLaundryAnimations(null);

    return NestScaffold(
      showBackButton: true,
      title: 'Upload Clothes',
      body: FadeTransition(
        opacity: animations.fadeAnimation,
        child: Column(
          children: [
            // Header Section
            _buildHeaderSection(theme),

            SizedBox(height: 3.h),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Upload Section
                    _buildImageUploadSection(
                      context,
                      theme,
                      ref,
                      images,
                      isLoading,
                    ),

                    SizedBox(height: 3.h),

                    // Selected Images Display
                    if (images.isNotEmpty) ...[
                      _buildSelectedImagesSection(
                        theme,
                        images,
                        isLoading,
                        ref,
                      ),
                      SizedBox(height: 3.h),
                    ],

                    // Items Selection Section
                    _buildItemsSelectionSection(context, theme, itemCount),

                    SizedBox(height: 3.h),

                    // Notes Section
                    _buildNotesSection(theme, ref, notes),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),

            // Bottom Action Button
            _buildBottomAction(
              context,
              theme,
              ref,
              images,
              itemCount,
              isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.08),
            theme.colorScheme.primary.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload Your Clothes',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Take photos and select items for cleaning',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadSection(
    BuildContext context,
    ThemeData theme,
    WidgetRef ref,
    List<File> images,
    bool isLoading,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.5.h),
        GestureDetector(
          onTap: isLoading ? null : () => _pickImages(context, ref),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(4.5.w),
            decoration: BoxDecoration(
              color:
                  images.isNotEmpty
                      ? theme.colorScheme.primary.withValues(alpha: 0.06)
                      : theme.colorScheme.onTertiaryContainer,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color:
                    images.isNotEmpty
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withValues(alpha: 0.08),
                width: images.isNotEmpty ? 2.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      images.isNotEmpty
                          ? theme.colorScheme.primary.withValues(alpha: 0.15)
                          : Colors.black.withValues(alpha: 0.03),
                  blurRadius: images.isNotEmpty ? 12 : 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon Container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          images.isNotEmpty
                              ? [
                                theme.colorScheme.primary,
                                theme.colorScheme.primary.withValues(
                                  alpha: 0.8,
                                ),
                              ]
                              : [
                                theme.colorScheme.onPrimaryContainer.withValues(
                                  alpha: 0.1,
                                ),
                                theme.colorScheme.onPrimaryContainer.withValues(
                                  alpha: 0.05,
                                ),
                              ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child:
                      isLoading
                          ? LoaderWidget(color: Colors.white)
                          : Icon(
                            LucideIcons.camera,
                            color:
                                images.isNotEmpty
                                    ? Colors.white
                                    : theme.colorScheme.onPrimaryContainer,
                            size: 6.w,
                          ),
                ),

                SizedBox(width: 4.w),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLoading
                            ? 'Processing images...'
                            : images.isNotEmpty
                            ? 'Photos uploaded'
                            : 'Upload photos',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color:
                              images.isNotEmpty
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        isLoading
                            ? 'Please wait...'
                            : images.isNotEmpty
                            ? '${images.length} image${images.length > 1 ? 's' : ''} selected'
                            : 'Take photos of your dirty clothes',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color:
                              isLoading
                                  ? theme.colorScheme.primary
                                  : images.isNotEmpty
                                  ? theme.colorScheme.primary.withValues(
                                    alpha: 0.7,
                                  )
                                  : theme.colorScheme.onPrimaryContainer
                                      .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                // Action Icon
                AnimatedRotation(
                  turns: images.isNotEmpty ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    images.isNotEmpty ? LucideIcons.check : LucideIcons.plus,
                    color:
                        images.isNotEmpty
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onPrimaryContainer.withValues(
                              alpha: 0.5,
                            ),
                    size: 5.w,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedImagesSection(
    ThemeData theme,
    List<File> images,
    bool isLoading,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Selected Photos',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${images.length}/5',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        SizedBox(
          height: 20.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(right: 3.w),
                width: 35.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    // Overlay gradient
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                    ),
                    // Remove button
                    Positioned(
                      top: 2.w,
                      right: 2.w,
                      child: GestureDetector(
                        onTap:
                            isLoading ? null : () => _removeImage(ref, index),
                        child: Container(
                          padding: EdgeInsets.all(1.5.w),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            LucideIcons.x,
                            size: 4.w,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItemsSelectionSection(
    BuildContext context,
    ThemeData theme,
    int itemCount,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Clothing Items',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.5.h),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            context.pushNamed('select_clothes');
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(4.5.w),
            decoration: BoxDecoration(
              color:
                  itemCount > 0
                      ? theme.colorScheme.primary.withValues(alpha: 0.06)
                      : theme.colorScheme.onTertiaryContainer,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color:
                    itemCount > 0
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withValues(alpha: 0.08),
                width: itemCount > 0 ? 2.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      itemCount > 0
                          ? theme.colorScheme.primary.withValues(alpha: 0.15)
                          : Colors.black.withValues(alpha: 0.03),
                  blurRadius: itemCount > 0 ? 12 : 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon Container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          itemCount > 0
                              ? [
                                theme.colorScheme.primary,
                                theme.colorScheme.primary.withValues(
                                  alpha: 0.8,
                                ),
                              ]
                              : [
                                theme.colorScheme.onPrimaryContainer.withValues(
                                  alpha: 0.1,
                                ),
                                theme.colorScheme.onPrimaryContainer.withValues(
                                  alpha: 0.05,
                                ),
                              ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    LucideIcons.boxes,
                    color:
                        itemCount > 0
                            ? Colors.white
                            : theme.colorScheme.onPrimaryContainer,
                    size: 6.w,
                  ),
                ),

                SizedBox(width: 4.w),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemCount > 0 ? 'Items selected' : 'Select items',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color:
                              itemCount > 0
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        itemCount > 0
                            ? '$itemCount item${itemCount > 1 ? 's' : ''} selected'
                            : 'Choose clothing items for cleaning',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color:
                              itemCount > 0
                                  ? theme.colorScheme.primary.withValues(
                                    alpha: 0.7,
                                  )
                                  : theme.colorScheme.onPrimaryContainer
                                      .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                // Action Icon
                AnimatedRotation(
                  turns: itemCount > 0 ? 0.25 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    itemCount > 0
                        ? LucideIcons.check
                        : LucideIcons.chevronRight,
                    color:
                        itemCount > 0
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onPrimaryContainer.withValues(
                              alpha: 0.5,
                            ),
                    size: 5.w,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(ThemeData theme, WidgetRef ref, String notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Special Instructions',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.5.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.onTertiaryContainer,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color:
                  notes.isNotEmpty
                      ? theme.colorScheme.primary.withValues(alpha: 0.3)
                      : theme.colorScheme.primary.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: TextFormField(
            maxLines: 3,
            onChanged:
                (value) => ref.read(notesProvider.notifier).state = value,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Add any special care instructions (optional)',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withValues(
                  alpha: 0.6,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(
    BuildContext context,
    ThemeData theme,
    WidgetRef ref,
    List<File> images,
    int itemCount,
    bool isLoading,
  ) {
    final isValid = images.isNotEmpty && itemCount > 0;

    return Container(
      padding: EdgeInsets.only(bottom: 3.h),
      child: NestButton(
        text: 'Confirm Selection',
        onPressed:
            isLoading
                ? null
                : isValid
                ? () => _handleConfirm(context, ref)
                : null,
        color:
            isValid
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withValues(alpha: 0.3),
      ),
    );
  }

  // Helper Methods
  Future<void> _pickImages(BuildContext context, WidgetRef ref) async {
    try {
      HapticFeedback.lightImpact();
      ref.read(isImageUploadingProvider.notifier).state = true;

      final picker = ImagePicker();
      final pickedImages = await picker.pickMultiImage(imageQuality: 70);

      if (pickedImages.isNotEmpty) {
        final currentImages = ref.read(selectedImagesProvider.notifier).state;
        if ((currentImages.length + pickedImages.length) > 5) {
          if (!context.mounted) return;
          ToastUtil.showErrorToast(
            context,
            "You can't upload more than 5 images",
          );
          return;
        }

        final files = pickedImages.map((x) => File(x.path)).toList();
        ref.read(selectedImagesProvider.notifier).state = [
          ...currentImages,
          ...files,
        ];

        HapticFeedback.mediumImpact();
      }
    } catch (e) {
      if (context.mounted) {
        ToastUtil.showErrorToast(
          context,
          "Error loading images: ${e.toString()}",
        );
      }
    } finally {
      ref.read(isImageUploadingProvider.notifier).state = false;
    }
  }

  void _removeImage(WidgetRef ref, int index) {
    HapticFeedback.lightImpact();
    final currentImages = List<File>.from(
      ref.read(selectedImagesProvider.notifier).state,
    );
    currentImages.removeAt(index);
    ref.read(selectedImagesProvider.notifier).state = currentImages;
  }

  void _handleConfirm(BuildContext context, WidgetRef ref) {
    final images = ref.read(selectedImagesProvider);
    final itemCount = ref.read(selectedItemsCountProvider);

    if (images.isEmpty) {
      ToastUtil.showErrorToast(context, 'Please upload at least one image.');
      return;
    }

    if (itemCount <= 0) {
      ToastUtil.showErrorToast(
        context,
        'Please select at least one clothing item.',
      );
      return;
    }

    HapticFeedback.mediumImpact();
    _completeClothesStep(ref);
    context.pop(true);
  }

  void _completeClothesStep(WidgetRef ref) {
    // Mark step 4 (clothes/wears) as completed
    final completed = [...ref.read(completedStepsProvider)];
    completed[4] = true;
    ref.read(completedStepsProvider.notifier).state = completed;

    // Update progress
    final newProgress =
        completed.where((step) => step).length / completed.length;
    ref.read(orderProgressProvider.notifier).state = newProgress;
  }
}
