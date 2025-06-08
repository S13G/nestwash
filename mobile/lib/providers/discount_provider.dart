import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/core/config/app_theme.dart';
import 'package:nestcare/features/general/model/discount_model.dart';

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
  return allDiscounts.where((discount) => discount.category == selectedCategory).toList();
});
