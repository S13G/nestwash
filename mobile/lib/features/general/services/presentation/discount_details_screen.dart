import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/features/general/model/discount_model.dart';
import 'package:nestcare/providers/discount_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DiscountDetailsScreen extends HookConsumerWidget {
  final DiscountModel discount;
  const DiscountDetailsScreen({super.key, required this.discount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final usages = ref.watch(discountUsagesByIdProvider(discount.id));

    final isExpired = DateTime.now().isAfter(discount.expiryDate);
    final remaining = (discount.totalCount - discount.usedCount).clamp(
      0,
      discount.totalCount,
    );
    final redemptionRate =
        discount.totalCount == 0
            ? 0
            : (discount.usedCount / discount.totalCount);

    final avgSaved =
        usages.isEmpty
            ? 0.0
            : usages
                    .map((u) => u.amountSaved)
                    .fold<double>(0.0, (sum, v) => sum + v) /
                usages.length;

    return NestScaffold(
      padding: EdgeInsets.zero,
      title: discount.title,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              padding: EdgeInsets.all(4.5.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.onSurface,
                    theme.colorScheme.onTertiary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _formatDiscountValue(discount).toUpperCase(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${discount.category} • Code ${discount.code}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '$remaining/${discount.totalCount}',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.6.h),
                        Text(
                          _formatExpiry(context, discount.expiryDate),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color:
                                isExpired
                                    ? theme.colorScheme.error
                                    : Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Stats row
            Row(
              children: [
                _StatChip(
                  icon: LucideIcons.activity,
                  label: 'Redemption Rate',
                  value: '${(redemptionRate * 100).toStringAsFixed(0)}%',
                ),
                SizedBox(width: 2.w),
                _StatChip(
                  icon: LucideIcons.wallet,
                  label: 'Total Saved',
                  value: '₦${avgSaved.toStringAsFixed(0)}',
                ),
                SizedBox(width: 2.w),
                _StatChip(
                  icon: LucideIcons.users,
                  label: 'Uses',
                  value: '${discount.usedCount}',
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Usages list
            Text('Redemptions', style: theme.textTheme.titleSmall),
            SizedBox(height: 1.h),
            if (usages.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.12),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.info, size: 20),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'No customers have used this code yet.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: usages.length,
                separatorBuilder: (_, __) => SizedBox(height: 1.h),
                itemBuilder: (context, index) {
                  final u = usages[index];
                  return Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.12,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundImage: AssetImage(u.customerImage),
                        ),
                        SizedBox(width: 2.5.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                u.customerName,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 0.3.h),
                              Text(
                                '${u.serviceName} • Order ${u.orderId}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                              SizedBox(height: 0.4.h),
                              Text(
                                _formatUsedAt(u.usedAt),
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '₦${u.amountSaved.toStringAsFixed(0)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  String _formatDiscountValue(DiscountModel d) {
    if ((d.discountAmount ?? 0) > 0 && d.discountPercentage == 0) {
      return '₦${d.discountAmount!.toStringAsFixed(0)} off';
    }
    return '${d.discountPercentage}% off';
  }

  String _formatExpiry(BuildContext context, DateTime date) {
    final td = TimeOfDay.fromDateTime(date);
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return 'Expires $dateStr ${td.format(context)}';
  }

  String _formatUsedAt(DateTime dt) {
    final dateStr =
        '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    final timeStr =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return 'Used on $dateStr $timeStr';
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.primary),
            SizedBox(width: 1.5.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.bodySmall),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
