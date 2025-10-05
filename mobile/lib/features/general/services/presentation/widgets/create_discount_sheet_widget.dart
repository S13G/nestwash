import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/features/general/model/discount_model.dart';
import 'package:nestcare/features/general/services/presentation/widgets/discount_widgets.dart';
import 'package:nestcare/providers/discount_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreateDiscountSheet extends HookConsumerWidget {
  final List<String> offeredServices;
  final String providerName;
  final String providerImage;

  const CreateDiscountSheet({
    super.key,
    required this.offeredServices,
    required this.providerName,
    required this.providerImage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final titleController = useTextEditingController(text: '');
    final descriptionController = useTextEditingController(text: '');
    final codeController = useTextEditingController(text: _generateCode());
    final valueController = useTextEditingController(text: '');
    final qtyController = useTextEditingController(text: '10');
    final selectedService = useState<String>(
      offeredServices.isNotEmpty ? offeredServices.first : '',
    );
    final isAmountBased = useState<bool>(false);
    final expiry = useState<DateTime>(
      DateTime.now().add(const Duration(days: 7)),
    );

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 4.w,
        right: 4.w,
        top: 2.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 2.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              Icon(LucideIcons.badgePercent, color: theme.colorScheme.primary),
              SizedBox(width: 2.w),
              Text(
                'Create Discount',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.2.h),
          if (offeredServices.isEmpty)
            Text(
              'You have no offered services set. Add services first.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          SizedBox(height: 1.h),
          LabeledDropdown(
            label: 'Service',
            value: selectedService.value,
            items: offeredServices,
            onChanged: (v) => selectedService.value = v ?? '',
          ),
          SizedBox(height: 1.h),
          ToggleRow(
            label: 'Discount Type',
            isAmountBased: isAmountBased.value,
            onChanged: (v) => isAmountBased.value = v,
          ),
          SizedBox(height: 1.h),
          LabeledField(
            label: isAmountBased.value ? 'Amount (₦)' : 'Percentage (%)',
            controller: valueController,
            inputType: TextInputType.numberWithOptions(
              decimal: isAmountBased.value,
            ),
          ),
          SizedBox(height: 1.h),
          LabeledField(label: 'Title', controller: titleController),
          SizedBox(height: 1.h),
          LabeledField(
            label: 'Description',
            controller: descriptionController,
            maxLines: 3,
          ),
          SizedBox(height: 1.h),
          LabeledField(
            label: 'Promo Code',
            controller: codeController,
            helper: 'Customers will use this code to redeem',
          ),
          SizedBox(height: 1.h),
          LabeledField(
            label: 'Quantity Limit',
            controller: qtyController,
            inputType: TextInputType.number,
          ),
          SizedBox(height: 1.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Expiry Date and Time',
              style: theme.textTheme.bodySmall?.copyWith(),
            ),
          ),
          SizedBox(height: 1.h),
          ExpiryPickerRow(
            theme: theme,
            expiry: expiry.value,
            onPickDate: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: expiry.value,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                expiry.value = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  expiry.value.hour,
                  expiry.value.minute,
                );
              }
            },
            onPickTime: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(expiry.value),
              );
              if (time != null) {
                expiry.value = DateTime(
                  expiry.value.year,
                  expiry.value.month,
                  expiry.value.day,
                  time.hour,
                  time.minute,
                );
              }
            },
          ),
          SizedBox(height: 2.h),
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              final qty = int.tryParse(qtyController.text.trim()) ?? 0;
              final valueRaw = valueController.text.trim();
              final percentage =
                  isAmountBased.value ? 0 : (int.tryParse(valueRaw) ?? 0);
              final amount =
                  isAmountBased.value
                      ? (double.tryParse(valueRaw) ?? 0.0)
                      : null;

              if (selectedService.value.isEmpty) {
                _errorToast(context, 'Please select a service');
                return;
              }
              if (!isAmountBased.value &&
                  (percentage <= 0 || percentage > 100)) {
                _errorToast(
                  context,
                  'Enter a valid percentage between 1 and 100',
                );
                return;
              }
              if (isAmountBased.value && (amount == null || amount <= 0)) {
                _errorToast(context, 'Enter a valid amount greater than 0');
                return;
              }
              if (qty <= 0) {
                _errorToast(context, 'Quantity must be at least 1');
                return;
              }

              _showConfirmDialog(
                context: context,
                theme: theme,
                service: selectedService.value,
                title: titleController.text.trim(),
                description: descriptionController.text.trim(),
                code: codeController.text.trim(),
                percentage: percentage,
                amount: amount,
                qty: qty,
                expiry: expiry.value,
                onConfirm: () {
                  final id = DateTime.now().millisecondsSinceEpoch.toString();
                  final newDiscount = DiscountModel(
                    id: id,
                    title:
                        titleController.text.trim().isNotEmpty
                            ? titleController.text.trim()
                            : '${selectedService.value} Offer',
                    description: descriptionController.text.trim(),
                    code:
                        codeController.text.trim().isNotEmpty
                            ? codeController.text.trim()
                            : _generateCode(),
                    discountPercentage: percentage,
                    discountAmount: amount,
                    serviceProviderName: providerName,
                    serviceProviderImage: providerImage,
                    expiryDate: expiry.value,
                    usedCount: 0,
                    totalCount: qty,
                    category: selectedService.value,
                    gradientStart: theme.colorScheme.primary,
                    gradientEnd: theme.colorScheme.onTertiary,
                  );

                  final current = ref.read(allDiscountsProvider);
                  ref.read(allDiscountsProvider.notifier).state = [
                    ...current,
                    newDiscount,
                  ];

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  ToastUtil.showSuccessToast(context, 'Discount created');
                },
              );
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.onTertiary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Save Discount',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  void _showConfirmDialog({
    required BuildContext context,
    required ThemeData theme,
    required String service,
    required String title,
    required String description,
    required String code,
    required int percentage,
    required double? amount,
    required int qty,
    required DateTime expiry,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            title: Row(
              children: [
                Text(
                  'Confirm Discount?',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Once confirmed, this discount cannot be changed or deactivated until the end date. To deactivate, please contact support.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: onConfirm,
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  String _generateCode() {
    final now = DateTime.now();
    return 'SAVE${now.millisecond}${now.second}${String.fromCharCode(65 + now.minute % 26)}'
        .toUpperCase();
  }

  void _errorToast(BuildContext context, String msg) {
    ToastUtil.showErrorToast(context, msg);
  }
}
