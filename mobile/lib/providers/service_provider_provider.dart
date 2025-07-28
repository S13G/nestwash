import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/services/model/service_provider_model.dart';
import 'package:nestcare/shared/util/service_provider_utils.dart';

final selectedServiceProvider = StateProvider<ServiceProvider?>((ref) => null);
final selectedServiceFilterProvider = StateProvider<ServiceProviderFilterType>(
  (ref) => ServiceProviderFilterType.all,
);
final selectedServiceSortProvider = StateProvider<ServiceProviderSortType>(
  (ref) => ServiceProviderSortType.highestRated,
);
final searchQueryProvider = StateProvider<String>((ref) => '');
final searchControllerProvider = Provider.autoDispose<TextEditingController>((
  ref,
) {
  final controller = TextEditingController();

  void listener() {
    ref.read(searchQueryProvider.notifier).state = controller.text.trim();
  }

  controller.addListener(listener);

  ref.onDispose(() {
    controller.removeListener(listener);
    controller.dispose();
  });

  return controller;
});

final allServiceProviders = StateProvider<List<ServiceProvider>>((ref) {
  return [
    ServiceProvider(
      id: '1',
      name: "Sarah Johnson",
      profileImage: "assets/images/provider1.png",
      rating: 4.9,
      reviewCount: 127,
      price: 15.99,
      isVerified: true,
      isAvailable: true,
      responseTime: "< 10 min",
      distance: "2.1 km",
      city: "Downtown",
      services: ["Wash & Fold", "Dry Clean", "Express"],
    ),
    ServiceProvider(
      id: '2',
      name: "Mike Chen",
      profileImage: "assets/images/provider2.png",
      rating: 4.8,
      reviewCount: 89,
      price: 12.50,
      isVerified: true,
      isAvailable: false,
      responseTime: "< 15 min",
      distance: "1.8 km",
      city: "Midtown",
      services: ["Wash & Fold", "Ironing"],
    ),
    ServiceProvider(
      id: '3',
      name: "Emily Rodriguez",
      profileImage: "assets/images/provider3.png",
      rating: 4.7,
      reviewCount: 156,
      price: 18.75,
      isVerified: true,
      isAvailable: true,
      responseTime: "< 5 min",
      distance: "3.2 km",
      city: "Uptown",
      services: ["Premium Care", "Dry Clean", "Alterations"],
    ),
    ServiceProvider(
      id: '4',
      name: "David Park",
      profileImage: "assets/images/provider4.png",
      rating: 4.6,
      reviewCount: 203,
      price: 14.25,
      isVerified: false,
      isAvailable: true,
      responseTime: "< 20 min",
      distance: "2.7 km",
      city: "Westside",
      services: ["Wash & Fold", "Express", "Ironing"],
    ),
  ];
});

final filteredServiceProviders = Provider<List<ServiceProvider>>((ref) {
  final filter = ref.watch(selectedServiceFilterProvider);
  final sortBy = ref.watch(selectedServiceSortProvider);
  final allProviders = ref.watch(allServiceProviders);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  List<ServiceProvider> filtered = allProviders;

  // Apply filter
  if (filter == ServiceProviderFilterType.available) {
    filtered =
        filtered
            .where((serviceProvider) => serviceProvider.isAvailable)
            .toList();
  } else if (filter == ServiceProviderFilterType.verified) {
    filtered =
        filtered
            .where((serviceProvider) => serviceProvider.isVerified)
            .toList();
  } else if (filter == ServiceProviderFilterType.topRated) {
    filtered =
        filtered
            .where((serviceProvider) => serviceProvider.rating >= 4.8)
            .toList();
  } else if (filter == ServiceProviderFilterType.outsideCity) {
    // Assuming current user city is "Downtown" - you can get this from user provider
    filtered =
        filtered
            .where(
              (serviceProvider) =>
                  serviceProvider.city?.isNotEmpty == true &&
                  serviceProvider.city != "Downtown",
            )
            .toList();
  }

  // Apply search
  if (searchQuery.isNotEmpty) {
    filtered =
        filtered
            .where(
              (serviceProvider) =>
                  serviceProvider.name.toLowerCase().contains(searchQuery),
            )
            .toList();
  }

  // Apply sorting
  if (sortBy == ServiceProviderSortType.highestRated) {
    filtered.sort((a, b) => b.rating.compareTo(a.rating));
  } else if (sortBy == ServiceProviderSortType.lowestRated) {
    filtered.sort((a, b) => a.rating.compareTo(b.rating));
  } else if (sortBy == ServiceProviderSortType.lowestPrice) {
    filtered.sort((a, b) => a.price.compareTo(b.price));
  } else if (sortBy == ServiceProviderSortType.highestPrice) {
    filtered.sort((a, b) => b.price.compareTo(a.price));
  }

  return filtered;
});
