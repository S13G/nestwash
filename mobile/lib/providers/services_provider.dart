import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/services/model/service_model.dart';
import 'package:nestcare/providers/profile_card_provider.dart';

final allServicesProvider = StateProvider<List<ServiceModel>>((ref) {
  return [
    ServiceModel(
      serviceTitle: 'Wash & Iron',
      serviceTitleImageName: 'wash_and_iron_icon',
    ),
    ServiceModel(
      serviceTitle: 'Dry Cleaning',
      serviceTitleImageName: 'dry_cleaning_icon',
    ),
    ServiceModel(
      serviceTitle: 'Ironing',
      serviceTitleImageName: 'ironing_icon',
    ),
    ServiceModel(
      serviceTitle: 'Ironing & Fold',
      serviceTitleImageName: 'ironing_and_fold_icon',
    ),
    ServiceModel(serviceTitle: 'Wash', serviceTitleImageName: 'wash_icon'),
    ServiceModel(
      serviceTitle: 'Home Care',
      serviceTitleImageName: 'home_care_icon',
    ),
  ];
});

final allActiveOrdersProvider = StateProvider<List<ServiceModel>>((ref) {
  return [
    ServiceModel(
      serviceTitle: 'Wash & Iron',
      itemCardImageName: 'wash_and_iron',
      status: 'In Progress',
      itemCardBackgroundColor: Color(0xFF8FD7C7),
      items: [
        ServiceItemModel(item: '1. jeans'),
        ServiceItemModel(item: '2. Shorts with really long name'),
        ServiceItemModel(item: '3. wrappers'),
        ServiceItemModel(item: '4. boxers'),
      ],
    ),
    ServiceModel(
      serviceTitle: 'Wash',
      itemCardImageName: 'wash',
      status: 'Ready',
      itemCardBackgroundColor: Color(0xFF5597FF),
      items: [
        ServiceItemModel(item: '1. jeans'),
        ServiceItemModel(item: '2. Shorts with really long name'),
        ServiceItemModel(item: '3. wrappers'),
        ServiceItemModel(item: '4. boxers'),
      ],
    ),
  ];
});

final filteredServiceProvider = StateProvider<List<ServiceModel>>((ref) {
  final search = ref.watch(searchTextProvider).toLowerCase();
  final allServices = ref.watch(allServicesProvider);

  if (search.isEmpty) return allServices;

  return allServices.where((service) {
    return service.serviceTitle!.toLowerCase().contains(search);
  }).toList();
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

final serviceProviderExpandedDescriptionProvider = StateProvider<bool>(
  (ref) => false,
);
