import 'dart:ui';

class ServiceItemModel {
  final String title;
  final String status;
  final String imageName;
  final List<String> items;
  final Color backgroundColor;

  ServiceItemModel({
    required this.title,
    required this.status,
    required this.imageName,
    required this.items,
    required this.backgroundColor,
  });
}
