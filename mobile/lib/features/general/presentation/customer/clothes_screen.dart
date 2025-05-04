import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker;
import 'package:nestcare/providers/orders_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:nestcare/shared/widgets/loader_widget.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ClothesScreen extends ConsumerWidget {
  const ClothesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final images = ref.watch(selectedImagesProvider);
    final itemCount = ref.watch(selectedItemsCountProvider);
    final isLoading = ref.watch(isImageUploadingProvider);

    Future<void> pickImages(WidgetRef ref) async {
      try {
        // Set loading state to true
        ref.read(isImageUploadingProvider.notifier).state = true;

        final picker = ImagePicker();
        final images = await picker.pickMultiImage(imageQuality: 70);

        if (images.isNotEmpty) {
          final currentImages = ref.read(selectedImagesProvider.notifier).state;
          if ((currentImages.length + images.length) > 5) {
            if (!context.mounted) return;
            ToastUtil.showErrorToast(
              context,
              "You can't upload more than 5 images",
            );
            return;
          }

          final files = images.map((x) => File(x.path)).toList();
          ref.read(selectedImagesProvider.notifier).state = [
            ...currentImages,
            ...files,
          ];
        }
      } catch (e) {
        if (context.mounted) {
          ToastUtil.showErrorToast(
            context,
            "Error loading images: ${e.toString()}",
          );
        }
      } finally {
        // Set loading state to false
        ref.read(isImageUploadingProvider.notifier).state = false;
      }
    }

    void removeImage(int index) {
      final currentImages = List<File>.from(
        ref.read(selectedImagesProvider.notifier).state,
      );
      currentImages.removeAt(index);
      ref.read(selectedImagesProvider.notifier).state = currentImages;
    }

    return NestScaffold(
      showBackButton: true,
      title: 'clothes',
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image Upload Section
                  GestureDetector(
                    onTap: isLoading ? null : () => pickImages(ref),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.5.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          isLoading
                              ? LoaderWidget(color: theme.colorScheme.primary)
                              : IconImageWidget(
                                iconName: 'select_clothes_image_icon',
                                width: 12.w,
                                height: 12.h,
                              ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Images',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  isLoading
                                      ? 'Processing images...'
                                      : 'Upload your dirty clothes',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color:
                                        isLoading
                                            ? theme.colorScheme.primary
                                            : theme
                                                .colorScheme
                                                .primaryContainer,
                                  ),
                                ),
                                if (images.isNotEmpty)
                                  Container(
                                    margin: EdgeInsets.only(top: 0.5.h),
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${images.length} image${images.length > 1 ? 's' : ''} selected',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme.colorScheme.primary,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          isLoading
                              ? Container(
                                width: 12.w,
                                height: 12.h,
                                alignment: Alignment.center,
                              )
                              : IconImageWidget(
                                iconName: 'add_image_icon',
                                width: 12.w,
                                height: 12.h,
                              ),
                        ],
                      ),
                    ),
                  ),

                  // Display selected images
                  if (images.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 1.w, bottom: 1.h),
                            child: Row(
                              children: [
                                Text(
                                  'Selected Images',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(right: 2.w),
                                  width: 30.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          images[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: GestureDetector(
                                          onTap:
                                              isLoading
                                                  ? null
                                                  : () => removeImage(index),
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              size: 16,
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
                      ),
                    ),

                  SizedBox(height: 2.5.h),

                  // Select Items Section
                  GestureDetector(
                    onTap: () {
                      context.pushNamed('select_clothes');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.5.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.primaryContainer.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          IconImageWidget(
                            iconName: 'select_icon',
                            width: 10.w,
                            height: 8.h,
                            color:
                                itemCount > 0
                                    ? theme.colorScheme.primary
                                    : null,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              itemCount > 0 ? 'Items Selected' : 'Select Items',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color:
                                    itemCount > 0
                                        ? Colors.blue
                                        : theme.colorScheme.primaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(
                            itemCount > 0 ? Icons.check_circle : Icons.add,
                            color:
                                itemCount > 0
                                    ? Colors.green
                                    : theme.colorScheme.primaryContainer,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 2.5.h),

                  // Notes (Optional)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextFormField(
                      maxLines: null,
                      onChanged:
                          (value) =>
                              ref.read(notesProvider.notifier).state = value,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Notes (Optional)',
                      ),
                    ),
                  ),

                  SizedBox(height: 2.5.h),
                ],
              ),
            ),
          ),

          // Confirm Button at the bottom
          NestButton(
            text: 'Confirm',
            onPressed:
                isLoading
                    ? null
                    : () {
                      if (images.isEmpty) {
                        ToastUtil.showErrorToast(
                          context,
                          'Please upload at least one image.',
                        );
                        return;
                      }

                      if (itemCount <= 0) {
                        ToastUtil.showErrorToast(
                          context,
                          'Please select at least one clothing item.',
                        );
                        return;
                      }

                      context.pop(true);
                    },
          ),
        ],
      ),
    );
  }
}
