import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddressCard extends ConsumerWidget {
  final String street;
  final String houseNumber;
  final ThemeData theme;

  const AddressCard({
    super.key,
    required this.street,
    required this.houseNumber,
    required this.theme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: theme.colorScheme.primaryContainer),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Address", style: theme.textTheme.bodyMedium),
              Spacer(),
              GestureDetector(
                onTap: () {
                  context.pushNamed("edit_address");
                },
                child: Icon(
                  Icons.edit_outlined,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 1.w),
              GestureDetector(
                onTap: () async {
                  final shouldDelete = await showDeleteConfirmationDialog(
                    context,
                  );

                  if (!context.mounted) return;

                  if (shouldDelete == true) {
                    ToastUtil.showSuccessToast(context, "Deleted successfully");
                  }
                },
                child: Icon(Icons.delete, color: theme.colorScheme.primary),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            street,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primaryContainer,
            ),
          ),
          SizedBox(height: 1.h),
          Text("City", style: theme.textTheme.bodyMedium),
          SizedBox(height: 1.h),
          Text(
            houseNumber,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Confirm Deletion', style: theme.textTheme.titleMedium),
            content: const Text(
              'Are you sure you want to delete this address?',
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => context.pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  elevation: 1,
                ),
                child: Text(
                  'Delete',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );

    return result ?? false;
  }
}
