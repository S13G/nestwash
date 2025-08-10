class ClothesItemSelectionModel {
  final int quantity;
  final String gender;

  ClothesItemSelectionModel({this.quantity = 0, this.gender = 'Men'});

  ClothesItemSelectionModel copyWith({int? quantity, String? gender}) {
    return ClothesItemSelectionModel(
      quantity: quantity ?? this.quantity,
      gender: gender ?? this.gender,
    );
  }
}

class ClothingItemModel {
  final String name;
  final double price;
  final String icon;

  ClothingItemModel({
    required this.name,
    required this.price,
    required this.icon,
  });
}