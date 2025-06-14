import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/model/transaction_model.dart';

final selectedTransactionFilterProvider = StateProvider<TransactionFilterType>((ref) => TransactionFilterType.all);
final allTransactionFiltersProvider = StateProvider<List<String>>((ref) {
  return ["All", "This Month", "Last 3 Months", "Last 6 Months", "This Year"];
});

// all transactions data
final allTransactionsProvider = StateProvider<List<TransactionModel>>((ref) {
  return [
    TransactionModel(
      id: 'TXN001',
      serviceName: 'Wash & Fold Premium',
      providerName: 'CleanCo Services',
      providerImage: 'provider1.png',
      amount: 28.50,
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: TransactionStatus.completed,
      items: ['3x Shirts', '2x Jeans', '1x Jacket'],
    ),
    TransactionModel(
      id: 'TXN002',
      serviceName: 'Dry Cleaning',
      providerName: 'Elite Cleaners',
      providerImage: 'provider2.png',
      amount: 45.00,
      date: DateTime.now().subtract(const Duration(days: 3)),
      status: TransactionStatus.completed, // Use enum
      items: ['2x Suits', '1x Dress'],
    ),
    TransactionModel(
      id: 'TXN003',
      serviceName: 'Express Wash',
      providerName: 'QuickWash Pro',
      providerImage: 'provider3.png',
      amount: 15.75,
      date: DateTime.now().subtract(const Duration(days: 7)),
      status: TransactionStatus.refunded, // Use enum
      items: ['5x T-Shirts'],
    ),
    TransactionModel(
      id: 'TXN004',
      serviceName: 'Delicate Care',
      providerName: 'Gentle Touch Laundry',
      providerImage: 'provider4.png',
      amount: 32.25,
      date: DateTime.now().subtract(const Duration(days: 14)),
      status: TransactionStatus.completed, // Use enum
      items: ['2x Silk Blouses', '1x Cashmere Sweater'],
    ),
    TransactionModel(
      id: 'TXN005',
      serviceName: 'Bulk Wash & Fold',
      providerName: 'FamilyWash Services',
      providerImage: 'provider5.png',
      amount: 67.80,
      date: DateTime.now().subtract(const Duration(days: 21)),
      status: TransactionStatus.completed, // Use enum
      items: ['15x Mixed Items'],
    ),
    TransactionModel(
      id: 'TXN006',
      serviceName: 'Spot Removal',
      providerName: 'Stain Away Experts',
      providerImage: 'provider6.png',
      amount: 10.00,
      date: DateTime.now().subtract(const Duration(days: 40)),
      status: TransactionStatus.completed, // Use enum
      items: ['1x Shirt (stain removed)'],
    ),
    TransactionModel(
      id: 'TXN007',
      serviceName: 'Curtain Cleaning',
      providerName: 'Home Shine Services',
      providerImage: 'provider7.png',
      amount: 75.00,
      date: DateTime.now().subtract(const Duration(days: 95)),
      status: TransactionStatus.completed, // Use enum
      items: ['2x Large Curtains'],
    ),
    TransactionModel(
      id: 'TXN008',
      serviceName: 'Rug Cleaning',
      providerName: 'Rug Revival Co.',
      providerImage: 'provider8.png',
      amount: 120.00,
      date: DateTime.now().subtract(const Duration(days: 185)),
      status: TransactionStatus.completed, // Use enum
      items: ['1x Persian Rug'],
    ),
    TransactionModel(
      id: 'TXN009',
      serviceName: 'Leather Cleaning',
      providerName: 'Leather Care Specialists',
      providerImage: 'provider9.png',
      amount: 90.00,
      date: DateTime.now().subtract(const Duration(days: 250)),
      status: TransactionStatus.completed, // Use enum
      items: ['1x Leather Jacket'],
    ),
    TransactionModel(
      id: 'TXN010',
      serviceName: 'Shoe Cleaning',
      providerName: 'Sneaker Sparkle',
      providerImage: 'provider10.png',
      amount: 20.00,
      date: DateTime.now().subtract(const Duration(days: 300)),
      status: TransactionStatus.completed, // Use enum
      items: ['1x Pair Sneakers'],
    ),
  ];
});

final filteredTransactionsProvider = StateProvider<List<TransactionModel>>((ref) {
  final all = ref.watch(allTransactionsProvider);
  final filter = ref.watch(selectedTransactionFilterProvider);

  final now = DateTime.now();
  final int currentYear = now.year;
  final int currentMonth = now.month;

  return all.where((transaction) {
    switch (filter) {
      case TransactionFilterType.thisMonth:
        return transaction.date.year == currentYear && transaction.date.month == currentMonth;
      case TransactionFilterType.last3Months:
        final threeMonthsAgo = DateTime(currentYear, currentMonth - 2, now.day); // Start of 3 months ago
        return transaction.date.isAfter(threeMonthsAgo) || transaction.date.isAtSameMomentAs(threeMonthsAgo);
      case TransactionFilterType.last6Months:
        final sixMonthsAgo = DateTime(currentYear, currentMonth - 5, now.day); // Start of 6 months ago
        return transaction.date.isAfter(sixMonthsAgo) || transaction.date.isAtSameMomentAs(sixMonthsAgo);
      case TransactionFilterType.thisYear:
        return transaction.date.year == currentYear;
      case TransactionFilterType.all:
        return true;
    }
  }).toList();
});

// Provider for calculating total spent for summary card
final totalSpentThisMonthProvider = Provider<double>((ref) {
  final filtered = ref.watch(filteredTransactionsProvider);

  return filtered
      .where((t) => t.date.year == DateTime.now().year && t.date.month == DateTime.now().month && t.status == TransactionStatus.completed)
      .fold(0.0, (sum, item) => sum + item.amount);
});

// Provider for calculating total orders for summary card
final totalOrdersOfAllTimeProvider = Provider<int>((ref) {
  final all = ref.watch(allTransactionsProvider);
  return all.length;
});
