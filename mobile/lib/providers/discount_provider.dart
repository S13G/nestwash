import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/core/config/app_theme.dart';
import 'package:nestcare/features/general/model/discount_model.dart';
import 'package:nestcare/features/general/services/model/discount_usage_model.dart';

// Discount categories
final selectedDiscountCategoryProvider = StateProvider<String>((ref) => 'All');
final allDiscountsCategoriesProvider = StateProvider<List<String>>((ref) {
  return ['All', 'Wash & Fold', 'Dry Cleaning', 'Premium', 'Express'];
});

// Discount data
final allDiscountsProvider = StateProvider<List<DiscountModel>>((ref) {
  return [
    DiscountModel(
      id: '1',
      title: 'New Customer Special',
      description: 'Get 25% off your first wash & fold service',
      code: 'WELCOME25',
      discountPercentage: 25,
      serviceProviderName: 'CleanPro Laundry',
      serviceProviderImage: 'assets/images/cleanpro_logo.png',
      expiryDate: DateTime.now().add(const Duration(days: 7)),
      usedCount: 12,
      totalCount: 50,
      category: 'Wash & Fold',
      gradientStart: AppColors.primary,
      gradientEnd: AppColors.accent,
    ),
    DiscountModel(
      id: '2',
      title: 'Weekend Flash Sale',
      description: 'Weekend special - 30% off dry cleaning services',
      code: 'WEEKEND30',
      discountPercentage: 30,
      serviceProviderName: 'Premium Dry Clean',
      serviceProviderImage: 'assets/images/premium_logo.png',
      expiryDate: DateTime.now().add(const Duration(days: 2)),
      usedCount: 8,
      totalCount: 25,
      category: 'Dry Cleaning',
      gradientStart: AppColors.onTertiary,
      gradientEnd: AppColors.secondaryContainer,
    ),
    DiscountModel(
      id: '3',
      title: 'Express Service Deal',
      description: 'Same day service with 15% discount',
      code: 'EXPRESS15',
      discountPercentage: 15,
      serviceProviderName: 'QuickWash Express',
      serviceProviderImage: 'assets/images/quickwash_logo.png',
      expiryDate: DateTime.now().add(const Duration(days: 5)),
      usedCount: 20,
      totalCount: 100,
      category: 'Express',
      gradientStart: AppColors.onPrimary,
      gradientEnd: AppColors.accent,
    ),
  ];
});
final filteredDiscountsProvider = StateProvider<List<DiscountModel>>((ref) {
  final selectedCategory = ref.watch(selectedDiscountCategoryProvider);
  final allDiscounts = ref.read(allDiscountsProvider);

  if (selectedCategory == 'All') return allDiscounts;
  return allDiscounts
      .where((discount) => discount.category == selectedCategory)
      .toList();
});

// Provide mock discount usages and family selector
final discountUsagesProvider = Provider<List<DiscountUsage>>((ref) {
  return [
    DiscountUsage(
      discountId: '1',
      customerName: 'Adaeze Okafor',
      customerImage: 'assets/images/user_pic.png',
      orderId: 'ORD-1024',
      serviceName: 'Wash & Fold',
      usedAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      amountSaved: 1500,
    ),
    DiscountUsage(
      discountId: '2',
      customerName: 'Tunde Bello',
      customerImage: 'assets/images/user_pic.png',
      orderId: 'ORD-1031',
      serviceName: 'Dry Cleaning',
      usedAt: DateTime.now().subtract(const Duration(days: 3, hours: 4)),
      amountSaved: 2000,
    ),
    DiscountUsage(
      discountId: '1',
      customerName: 'Maryam Yusuf',
      customerImage: 'assets/images/user_pic.png',
      orderId: 'ORD-1040',
      serviceName: 'Wash & Iron',
      usedAt: DateTime.now().subtract(const Duration(hours: 6)),
      amountSaved: 1200,
    ),
  ];
});

final discountUsagesByIdProvider = Provider.family<List<DiscountUsage>, String>(
  (ref, discountId) {
    final all = ref.watch(discountUsagesProvider);
    return all.where((u) => u.discountId == discountId).toList();
  },
);
