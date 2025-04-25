import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/model/service_model.dart';
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

final filteredServiceProvider = StateProvider<List<ServiceModel>>((ref) {
  final search = ref.watch(searchTextProvider).toLowerCase();
  final allServices = ref.watch(allServicesProvider);

  if (search.isEmpty) return allServices;

  return allServices.where((service) {
    return service.serviceTitle!.toLowerCase().contains(search);
  }).toList();
});
