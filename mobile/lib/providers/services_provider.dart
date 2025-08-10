import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/core/config/app_theme.dart';
import 'package:nestcare/features/general/services/model/service_model.dart';

// all services screen
final allServicesProvider = StateProvider<List<LaundryServiceModel>>((ref) {
  return [
    LaundryServiceModel(
      id: 'wash_fold',
      name: 'Wash & Fold',
      description:
          'Complete washing, drying, and folding service for your everyday clothes',
      duration: '2-3 days',
      icon: LucideIcons.washingMachine,
      color: AppColors.primary,
      imageUrl: 'wash_fold_illustration.svg',
      features: ['Machine wash', 'Tumble dry', 'Neat fold'],
      isPopular: true,
    ),
    LaundryServiceModel(
      id: 'dry_clean',
      name: 'Dry Cleaning',
      description: 'Premium dry cleaning for delicate fabrics and formal wear',
      duration: '3-4 days',
      icon: LucideIcons.brushCleaning,
      color: AppColors.onTertiary,
      imageUrl: 'dry_clean_illustration.svg',
      features: ['Stain removal', 'Soft press', 'Fabric care'],
    ),
    LaundryServiceModel(
      id: 'ironing',
      name: 'Ironing Only',
      description: 'Professional ironing and pressing service',
      duration: '1-2 days',
      icon: LucideIcons.anvil,
      color: AppColors.onPrimary,
      imageUrl: 'ironing_illustration.svg',
      features: ['Steam press', 'Sharp creases', 'Hanger ready'],
    ),
    LaundryServiceModel(
      id: 'premium',
      name: 'Premium Care',
      description: 'Luxury treatment for your most valuable garments',
      duration: '4-5 days',
      icon: LucideIcons.star,
      color: AppColors.secondaryContainer,
      imageUrl: 'premium_illustration.svg',
      features: ['Hand wash', 'Luxury soap', 'Special wrap'],
    ),
    LaundryServiceModel(
      id: 'household',
      name: 'Household Items',
      description:
          'Cleaning for curtains, duvets, bedsheets, and other household fabrics',
      duration: '3-5 days',
      icon: LucideIcons.blinds,
      color: AppColors.accent,
      imageUrl: 'household_items_illustration.svg',
      features: ['Curtain wash', 'Duvet clean', 'Sheet press'],
    ),
    LaundryServiceModel(
      id: 'footwears',
      name: 'Footwears',
      description: 'Professional footwear cleanings',
      duration: '1-2 days',
      icon: LucideIcons.footprints,
      color: AppColors.hint,
      imageUrl: 'footwears_illustration.svg',
      features: ['Sneaker wash', 'Sole scrub', 'Color restore'],
    ),
  ];
});
final selectedServiceProvider = StateProvider<String?>((ref) => null);
final filteredServiceProvider =
    Provider.family<List<LaundryServiceModel>, String>((ref, searchQuery) {
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

final searchSpecificServiceProviderTextProvider = StateProvider<String>(
  (ref) => '',
);

final searchSpecificServiceProviderControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
      final controller = TextEditingController();

      void listener() {
        ref.read(searchSpecificServiceProviderTextProvider.notifier).state =
            controller.text.trim();
      }

      controller.addListener(listener);

      ref.onDispose(() {
        controller.removeListener(listener);
        controller.dispose();
      });

      return controller;
    });

final allSpecificCareServiceProviders =
    StateProvider<List<Map<String, String>>>((ref) {
      return [
        {
          "name": "Lily Wilson",
          "profile_image": "lily_profile_pic",
          "rating": "4.5",
        },
        {
          "name": "Emily Johnson",
          "profile_image": "lily_profile_pic",
          "rating": "4.2",
        },
        {
          "name": "David Brown",
          "profile_image": "lily_profile_pic",
          "rating": "4.8",
        },
        {
          "name": "Sophia Davis",
          "profile_image": "lily_profile_pic",
          "rating": "4.6",
        },
        {
          "name": "Oliver Wilson",
          "profile_image": "lily_profile_pic",
          "rating": "4.3",
        },
      ];
    });

final filteredSpecificCareServiceProviders =
    StateProvider<List<Map<String, String>>>((ref) {
      final search =
          ref.watch(searchSpecificServiceProviderTextProvider).toLowerCase();
      final allProviders = ref.watch(allSpecificCareServiceProviders);

      if (search.isEmpty) return allProviders;
      return allProviders.where((service) {
        return service["name"]!.toLowerCase().contains(search);
      }).toList();
    });

final selectedServiceProviderNameProvider = StateProvider<String>((ref) => '');
final serviceProviderAvailabilityProvider = StateProvider<bool>((ref) => true);
final ratingProvider = StateProvider<int>((ref) => 0);
final serviceProviderExpandedDescriptionProvider = StateProvider<bool>(
  (ref) => false,
);
