import 'dart:ui';

class DiscountModel {
  final String id;
  final String title;
  final String description;
  final String code;
  final int discountPercentage;
  final String serviceProviderName;
  final String serviceProviderImage;
  final DateTime expiryDate;
  final int usedCount;
  final int totalCount;
  final String category;
  final Color gradientStart;
  final Color gradientEnd;

  DiscountModel({
    required this.id,
    required this.title,
    required this.description,
    required this.code,
    required this.discountPercentage,
    required this.serviceProviderName,
    required this.serviceProviderImage,
    required this.expiryDate,
    required this.usedCount,
    required this.totalCount,
    required this.category,
    required this.gradientStart,
    required this.gradientEnd,
  });
}
