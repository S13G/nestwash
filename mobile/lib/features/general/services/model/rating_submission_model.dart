class RatingSubmissionState {
  final bool isLoading;
  final String? error;
  final String? success;
  final RatingSubmissionData? data;

  RatingSubmissionState({
    this.isLoading = false,
    this.error,
    this.success,
    this.data,
  });

  RatingSubmissionState copyWith({
    bool? isLoading,
    String? error,
    String? success,
    RatingSubmissionData? data,
  }) {
    return RatingSubmissionState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      success: success ?? this.success,
      data: data ?? this.data,
    );
  }
}

class RatingSubmissionData {
  final String serviceProviderId;
  final double rating;
  final String comment;
  final String serviceType;

  RatingSubmissionData({
    required this.serviceProviderId,
    required this.rating,
    required this.comment,
    required this.serviceType,
  });

  RatingSubmissionData copyWith({
    String? serviceProviderId,
    double? rating,
    String? comment,
    String? serviceType,
  }) {
    return RatingSubmissionData(
      serviceProviderId: serviceProviderId ?? this.serviceProviderId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      serviceType: serviceType ?? this.serviceType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceProviderId': serviceProviderId,
      'rating': rating,
      'comment': comment,
      'serviceType': serviceType,
    };
  }
}