import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/services/model/rating_submission_model.dart';
import 'package:nestcare/features/general/services/model/review_model.dart';
import 'package:nestcare/providers/auth_provider.dart';
import 'package:nestcare/providers/reviews_provider.dart';

class RatingController extends StateNotifier<RatingSubmissionState> {
  final Ref _ref;

  RatingController(this._ref) : super(RatingSubmissionState());

  Future<void> submitRating({
    required String serviceProviderId,
    required double rating,
    required String comment,
    required String serviceType,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    _ref.watch(loadingProvider.notifier).state = true;

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      final submissionData = RatingSubmissionData(
        serviceProviderId: serviceProviderId,
        rating: rating,
        comment: comment,
        serviceType: serviceType,
      );

      // Create new review and add to existing reviews
      final newReview = ReviewModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        customerName: 'You',
        customerAvatar: '',
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
        serviceType: serviceType,
      );

      // Add the new review to the mock reviews
      _ref.read(mockReviewsProvider.notifier).state = [
        newReview,
        ..._ref.read(mockReviewsProvider),
      ];

      _ref.watch(loadingProvider.notifier).state = false;

      state = state.copyWith(
        isLoading: false,
        success: 'Rating submitted successfully!',
        data: submissionData,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to submit rating: ${e.toString()}',
      );
    }
  }

  void clearState() {
    state = RatingSubmissionState();
  }
}

final ratingControllerProvider =
    StateNotifierProvider<RatingController, RatingSubmissionState>(
      (ref) => RatingController(ref),
    );
