import 'dart:ui';

class ServiceModel {
  final String? serviceTitle;
  final String? serviceTitleImageName;
  final String? itemCardImageName;
  final List<ServiceItemModel>? items;
  final String? status;
  final Color? itemCardBackgroundColor;

  ServiceModel({
    this.serviceTitle,
    this.serviceTitleImageName,
    this.itemCardImageName,
    this.items,
    this.status,
    this.itemCardBackgroundColor,
  });
}

class ServiceItemModel {
  final String item;

  ServiceItemModel({required this.item});
}
