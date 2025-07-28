import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/model/order_model.dart';
import 'package:nestcare/shared/util/general_utils.dart';

final laundryOrderSelectedFilterProvider = StateProvider<FilterType>((ref) => FilterType.all);
final allLaundryOrdersProvider = Provider<List<Order>>((ref) => Order.sampleOrder());

final filteredLaundryOrdersProvider = Provider.family<List<Order>, String>((ref, searchQuery) {
  final filter = ref.watch(laundryOrderSelectedFilterProvider);
  final allOrders = ref.watch(allLaundryOrdersProvider);
  final search = searchQuery.toLowerCase();

  List<Order> filtered = allOrders;

  // Apply filter
  if (filter == FilterType.active) {
    filtered = filtered.where((order) => order.status != OrderStatus.cancelled).toList();
  } else if (filter == FilterType.past) {
    filtered = filtered.where((order) => order.status == OrderStatus.completed || order.status == OrderStatus.cancelled).toList();
  }

  // Apply search
  if (search.isNotEmpty) {
    filtered =
        filtered
            .where((order) => order.id.toLowerCase().contains(search) || order.items.any((item) => item.name.toLowerCase().contains(search)))
            .toList();
  }

  return filtered;
});
