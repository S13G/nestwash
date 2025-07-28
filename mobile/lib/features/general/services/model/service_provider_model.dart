class ServiceProvider {
  final String id;
  final String name;
  final String profileImage;
  final double rating;
  final int reviewCount;
  final double price;
  final bool isVerified;
  final bool isAvailable;
  final String responseTime;
  final String distance;
  final String? city;
  final List<String> services;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.isVerified,
    required this.isAvailable,
    required this.responseTime,
    required this.distance,
    required this.services,
    this.city = 'Unknown location',
  });
}
