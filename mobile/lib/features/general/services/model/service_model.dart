import 'package:flutter/cupertino.dart';

class LaundryServiceModel {
  final String id;
  final String name;
  final String description;
  final String duration;
  final IconData icon;
  final List<String> features;
  final Color color;
  final String imageUrl;
  final bool isPopular;

  LaundryServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.icon,
    required this.features,
    required this.color,
    required this.imageUrl,
    this.isPopular = false,
  });
}

class ServiceItemModel {
  final String item;

  ServiceItemModel({required this.item});
}
