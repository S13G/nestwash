import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/core/config/app_theme.dart';
import 'package:nestcare/features/general/model/transaction_model.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/providers/transactions_provider.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TransactionHistoryScreen extends HookConsumerWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final selectedFilter = ref.watch(selectedTransactionFilterProvider);
    final filteredTransactions = ref.watch(filteredTransactionsProvider);
    final totalSpent = ref.watch(totalSpentThisMonthProvider);
    final totalOrders = ref.watch(totalOrdersOfAllTimeProvider);

    final animations = useLaundryAnimations(null);

    return NestScaffold(
      padding: EdgeInsets.zero,
      showBackButton: true,
      title: 'transaction history',
      body: Column(
        children: [
          _buildSummaryCards(theme, totalSpent, totalOrders, animations),
          SizedBox(height: 1.h),

          _buildFilterSection(selectedFilter, ref, TransactionFilterType.values, theme),
          SizedBox(height: 2.h),

          Expanded(child: SlideTransition(position: animations.slideAnimation, child: _buildTransactionList(filteredTransactions, theme))),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(ThemeData theme, double totalSpent, int totalOrders, LaundryAnimations animations) {
    return FadeTransition(
      opacity: animations.fadeAnimation,
      child: SlideTransition(
        position: animations.slideAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  theme,
                  'Total Spent',
                  '\$${totalSpent.toStringAsFixed(2)}',
                  'This Month',
                  Icons.account_balance_wallet_outlined,
                  AppColors.primary,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildSummaryCard(
                  theme,
                  'Total Orders',
                  totalOrders.toString(),
                  'All Time',
                  Icons.receipt_long_outlined,
                  AppColors.onTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(ThemeData theme, String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(2.5.w)),
                child: Icon(icon, color: color, size: 5.w),
              ),
              const Spacer(),
              Icon(Icons.trending_up, color: AppColors.onPrimary, size: 4.w),
            ],
          ),
          SizedBox(height: 2.h),
          Text(value, style: theme.textTheme.titleMedium),
          SizedBox(height: 0.5.h),
          Text(title, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.w500)),
          Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
        ],
      ),
    );
  }

  Widget _buildFilterSection(TransactionFilterType selectedFilter, WidgetRef ref, List<TransactionFilterType> filterOptions, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Text('Filter by:', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(width: 3.w),
          Expanded(
            child: SizedBox(
              height: 4.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filterOptions.length,
                itemBuilder: (context, index) {
                  final option = filterOptions[index];
                  final isSelected = selectedFilter == option;

                  return GestureDetector(
                    onTap: () {
                      ref.read(selectedTransactionFilterProvider.notifier).state = option;
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 2.w),
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(6.w),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Text(
                        _filterTypeToDisplayString(option),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<TransactionModel> transactions, ThemeData theme) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'No transactions found for the selected filter.',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionCard(transaction, theme);
      },
    );
  }

  Widget _buildTransactionCard(TransactionModel transaction, ThemeData theme) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              // Provider Avatar
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary, theme.colorScheme.onSurface],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: Icon(Icons.store, color: Colors.white, size: 6.w),
              ),
              SizedBox(width: 3.w),

              // Transaction Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transaction.serviceName, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(height: 0.5.h),
                    Text(transaction.providerName, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
                  ],
                ),
              ),

              // Amount and Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${transaction.amount.toStringAsFixed(2)}', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 0.5.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _getStatusColor(transaction.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: Text(
                      transaction.status.name[0].toUpperCase() + transaction.status.name.substring(1),
                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: _getStatusColor(transaction.status)),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Transaction Details
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(3.w)),
            child: Column(
              children: [
                _buildDetailRow(theme, 'Transaction ID', transaction.id),
                SizedBox(height: 2.h),
                _buildDetailRow(theme, 'Date', _formatDate(transaction.date)),
                SizedBox(height: 2.h),

                // Items Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Items:', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Wrap(
                        spacing: 2.w,
                        runSpacing: 1.h,
                        children:
                            transaction.items.map((item) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.onTertiaryContainer,
                                  borderRadius: BorderRadius.circular(2.w),
                                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1),
                                ),
                                child: Text(item, style: theme.textTheme.bodyMedium),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(ThemeData theme, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
        Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  // Correctly uses TransactionStatus enum
  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return AppColors.onPrimary;
      case TransactionStatus.refunded:
        return Colors.orange.shade600;
      case TransactionStatus.pending:
        return AppColors.accent;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _filterTypeToDisplayString(TransactionFilterType type) {
    switch (type) {
      case TransactionFilterType.all:
        return 'All';
      case TransactionFilterType.thisMonth:
        return 'This Month';
      case TransactionFilterType.last3Months:
        return 'Last 3 Months';
      case TransactionFilterType.last6Months:
        return 'Last 6 Months';
      case TransactionFilterType.thisYear:
        return 'This Year';
    }
  }
}
