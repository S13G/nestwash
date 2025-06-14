class AddressModel {
  final String id;
  final String label;
  final String address;
  final String city;
  final String state;
  final String instructions;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.label,
    required this.address,
    required this.city,
    required this.state,
    required this.instructions,
    required this.isDefault,
  });

  AddressModel copyWith({
    String? id,
    String? label,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? instructions,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      label: label ?? this.label,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      instructions: instructions ?? this.instructions,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
