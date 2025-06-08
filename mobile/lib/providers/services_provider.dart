import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/core/config/app_theme.dart';
import 'package:nestcare/features/general/services/model/service_model.dart';

// all services screen
final allServicesProvider = StateProvider<List<LaundryServiceModel>>((ref) {
  return [
    LaundryServiceModel(
      id: 'wash_fold',
      name: 'Wash & Fold',
      description: 'Complete washing, drying, and folding service for your everyday clothes',
      duration: '2-3 days',
      icon: Icons.local_laundry_service_rounded,
      color: AppColors.primary,
      imageUrl: 'wash_fold_illustration.svg',
      features: ['Professional washing', 'Machine drying', 'Neat folding', 'Fabric softener'],
      isPopular: true,
    ),
    LaundryServiceModel(
      id: 'dry_clean',
      name: 'Dry Cleaning',
      description: 'Premium dry cleaning for delicate fabrics and formal wear',
      duration: '3-4 days',
      icon: Icons.dry_cleaning_rounded,
      color: AppColors.onTertiary,
      imageUrl: 'dry_clean_illustration.svg',
      features: [
        'Eco-friendly solvents',
        'Stain removal',
        'Professional pressing',
        'Garment protection',
      ],
    ),
    LaundryServiceModel(
      id: 'express',
      name: 'Express Service',
      description: 'Quick turnaround for urgent laundry needs',
      duration: '24 hours',
      icon: Icons.flash_on_rounded,
      color: AppColors.accent,
      imageUrl: 'express_illustration.svg',
      features: [
        'Same-day service',
        'Priority handling',
        'Express delivery',
        'Perfect for emergencies',
      ],
    ),
    LaundryServiceModel(
      id: 'ironing',
      name: 'Ironing Only',
      description: 'Professional ironing and pressing service',
      duration: '1-2 days',
      icon: Icons.iron_rounded,
      color: AppColors.onPrimary,
      imageUrl: 'ironing_illustration.svg',
      features: ['Steam pressing', 'Crease removal', 'Collar & cuff care', 'Hanger service'],
    ),
    LaundryServiceModel(
      id: 'premium',
      name: 'Premium Care',
      description: 'Luxury treatment for your most valuable garments',
      duration: '4-5 days',
      icon: Icons.star_rounded,
      color: AppColors.secondaryContainer,
      imageUrl: 'premium_illustration.svg',
      features: ['Hand washing', 'Premium detergents', 'Individual care', 'Luxury packaging'],
    ),
    LaundryServiceModel(
      id: 'alterations',
      name: 'Alterations',
      description: 'Professional tailoring and garment alterations',
      duration: '5-7 days',
      icon: Icons.content_cut_rounded,
      color: AppColors.tertiary,
      imageUrl: 'alterations_illustration.svg',
      features: ['Expert tailoring', 'Size adjustments', 'Repair services', 'Custom fitting'],
    ),
  ];
});
final selectedServiceProvider = StateProvider<String?>((ref) => null);
final filteredServiceProvider = Provider.family<List<LaundryServiceModel>, String>((
  ref,
  searchQuery,
) {
  final search = searchQuery.toLowerCase();
  final allServices = ref.watch(allServicesProvider);

  if (search.isEmpty) return allServices;

  return allServices.where((service) {
    return service.name.toLowerCase().contains(search);
  }).toList();
});

final allActiveOrdersProvider = StateProvider<List<LaundryServiceModel>>((ref) {
  return [];
});

final searchSpecificServiceProviderTextProvider = StateProvider<String>((ref) => '');

final searchSpecificServiceProviderControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) {
    final controller = TextEditingController();

    void listener() {
      ref.read(searchSpecificServiceProviderTextProvider.notifier).state = controller.text.trim();
    }

    controller.addListener(listener);

    ref.onDispose(() {
      controller.removeListener(listener);
      controller.dispose();
    });

    return controller;
  },
);

final allSpecificCareServiceProviders = StateProvider<List<Map<String, String>>>((ref) {
  return [
    {"name": "Lily Wilson", "profile_image": "lily_profile_pic", "rating": "4.5"},
    {"name": "Emily Johnson", "profile_image": "lily_profile_pic", "rating": "4.2"},
    {"name": "David Brown", "profile_image": "lily_profile_pic", "rating": "4.8"},
    {"name": "Sophia Davis", "profile_image": "lily_profile_pic", "rating": "4.6"},
    {"name": "Oliver Wilson", "profile_image": "lily_profile_pic", "rating": "4.3"},
  ];
});

final filteredSpecificCareServiceProviders = StateProvider<List<Map<String, String>>>((ref) {
  final search = ref.watch(searchSpecificServiceProviderTextProvider).toLowerCase();
  final allProviders = ref.watch(allSpecificCareServiceProviders);

  if (search.isEmpty) return allProviders;
  return allProviders.where((service) {
    return service["name"]!.toLowerCase().contains(search);
  }).toList();
});

final selectedServiceProviderNameProvider = StateProvider<String>((ref) => '');
final serviceProviderAvailabilityProvider = StateProvider<bool>((ref) => true);
final ratingProvider = StateProvider<int>((ref) => 0);
final serviceProviderExpandedDescriptionProvider = StateProvider<bool>((ref) => false);
