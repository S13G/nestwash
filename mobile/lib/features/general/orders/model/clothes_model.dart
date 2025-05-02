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
