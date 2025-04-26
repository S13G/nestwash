import 'dart:ui';

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
