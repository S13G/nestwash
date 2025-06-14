import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/model/address_model.dart';

// Provider for managing the list of addresses
final addressListNotifierProvider = StateNotifierProvider<AddressListNotifier, List<AddressModel>>((ref) {
  return AddressListNotifier();
});

class AddressListNotifier extends StateNotifier<List<AddressModel>> {
  AddressListNotifier() : super(_initialAddresses);

  // Initial dummy data for addresses
  static final List<AddressModel> _initialAddresses = [
    AddressModel(
      id: '1',
      label: 'Home',
      address: '123 Main Street, Apartment 4B',
      city: 'New York',
      state: 'NY',
      instructions: 'Ring doorbell twice',
      isDefault: true,
    ),
    AddressModel(
      id: '2',
      label: 'Office',
      address: '456 Business Ave, Suite 200',
      city: 'New York',
      state: 'NY',
      instructions: 'Leave with security',
      isDefault: false,
    ),
  ];

  void addAddress(AddressModel newAddress) {
    state = [...state, newAddress];
  }

  void updateAddress(String id, AddressModel updatedAddress) {
    state = [
      for (final address in state)
        if (address.id == id) updatedAddress else address,
    ];
  }

  void deleteAddress(String id) {
    state = state.where((address) => address.id != id).toList();
  }

  void setAsDefault(String id) {
    state = [for (final address in state) address.copyWith(isDefault: address.id == id)];
  }
}

final isAddingAddressProvider = StateProvider<bool>((ref) => false);

final editingAddressIdProvider = StateProvider<String?>((ref) => null);

final isEditingExistingAddressProvider = StateProvider<AddressModel?>((ref) {
  final addresses = ref.watch(addressListNotifierProvider);
  final editingAddressId = ref.watch(editingAddressIdProvider);
  return editingAddressId != null ? addresses.firstWhere((address) => address.id == editingAddressId) : null;
});
