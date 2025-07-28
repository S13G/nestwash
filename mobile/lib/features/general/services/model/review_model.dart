class ReviewsPaginationState {
  final int currentPage;
  final int itemsPerPage;
  final bool isLoading;
  final bool hasReachedEnd;
  final String? error;

  ReviewsPaginationState({
    this.currentPage = 1,
    this.itemsPerPage = 10,
    this.isLoading = false,
    this.hasReachedEnd = false,
    this.error,
  });

  ReviewsPaginationState copyWith({
    int? currentPage,
    int? itemsPerPage,
    bool? isLoading,
    bool? hasReachedEnd,
    String? error,
  }) {
    return ReviewsPaginationState(
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      isLoading: isLoading ?? this.isLoading,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      error: error ?? this.error,
    );
  }
}

class ReviewModel {
  final String id;
  final String customerName;
  final String customerAvatar;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final String serviceType;

  ReviewModel({
    required this.id,
    required this.customerName,
    required this.customerAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.serviceType,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      customerName: json['customerName'] ?? '',
      customerAvatar: json['customerAvatar'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      serviceType: json['serviceType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'customerAvatar': customerAvatar,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'serviceType': serviceType,
    };
  }
}

class ReviewsResponse {
  final List<ReviewModel> reviews;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  ReviewsResponse({
    required this.reviews,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory ReviewsResponse.fromJson(Map<String, dynamic> json) {
    return ReviewsResponse(
      reviews:
          (json['reviews'] as List<dynamic>)
              .map((review) => ReviewModel.fromJson(review))
              .toList(),
      totalCount: json['totalCount'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }
}
