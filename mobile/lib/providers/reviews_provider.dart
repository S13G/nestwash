import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/services/model/review_model.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:nestcare/shared/util/general_utils.dart';

// Providers
final reviewsFilterProvider = StateProvider<ReviewFilterType>(
  (ref) => ReviewFilterType.all,
);
final reviewsSortProvider = StateProvider<ReviewSortType>(
  (ref) => ReviewSortType.newest,
);
final reviewsPaginationProvider = StateProvider<ReviewsPaginationState>(
  (ref) => ReviewsPaginationState(),
);
final reviewsListProvider = StateProvider<List<ReviewModel>>((ref) => []);

final mockReviewsProvider = StateProvider<List<ReviewModel>>((ref) {
  return [
    ReviewModel(
      id: '1',
      customerName: 'Sarah Johnson',
      customerAvatar: '',
      rating: 5.0,
      comment:
          'Excellent service! My clothes came back perfectly clean and pressed. The pickup and delivery was right on time. Highly recommend this service provider!',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      serviceType: 'Wash & Iron',
    ),
    ReviewModel(
      id: '2',
      customerName: 'Michael Chen',
      customerAvatar: '',
      rating: 4.0,
      comment:
          'Good quality cleaning service. The staff was professional and my shirts were cleaned well. Only minor issue was a slight delay in delivery.',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      serviceType: 'Dry Cleaning',
    ),
    ReviewModel(
      id: '3',
      customerName: 'Emily Rodriguez',
      customerAvatar: '',
      rating: 5.0,
      comment:
          'Amazing attention to detail! They even fixed a small tear in my dress without me asking. Customer service is top-notch.',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      serviceType: 'Alterations',
    ),
    ReviewModel(
      id: '4',
      customerName: 'David Wilson',
      customerAvatar: '',
      rating: 3.0,
      comment:
          'Service was okay. Cleaning quality was good but the process took longer than expected. Communication could be better.',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      serviceType: 'Wash & Fold',
    ),
    ReviewModel(
      id: '5',
      customerName: 'Lisa Thompson',
      customerAvatar: '',
      rating: 5.0,
      comment:
          'Fantastic service! They handled my delicate fabrics with great care. The eco-friendly cleaning options are a plus.',
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
      serviceType: 'Eco Cleaning',
    ),
    ReviewModel(
      id: '6',
      customerName: 'James Parker',
      customerAvatar: '',
      rating: 4.0,
      comment:
          'Professional service with good results. Pricing is fair and the online booking system is convenient.',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      serviceType: 'Express Cleaning',
    ),
    ReviewModel(
      id: '7',
      customerName: 'Anna Martinez',
      customerAvatar: '',
      rating: 5.0,
      comment:
          'Exceeded my expectations! They removed stains I thought were permanent. Will definitely use again.',
      createdAt: DateTime.now().subtract(const Duration(days: 18)),
      serviceType: 'Stain Removal',
    ),
    ReviewModel(
      id: '8',
      customerName: 'Robert Kim',
      customerAvatar: '',
      rating: 4.0,
      comment:
          'Reliable and consistent quality. The mobile app makes it easy to track orders and communicate.',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      serviceType: 'Regular Cleaning',
    ),
  ];
});

// Filtered and sorted reviews provider
final filteredReviewsProvider = Provider<List<ReviewModel>>((ref) {
  final reviews = ref.watch(mockReviewsProvider);
  final filter = ref.watch(reviewsFilterProvider);
  final sort = ref.watch(reviewsSortProvider);
  final searchQuery = ref.watch(searchTextProvider).toLowerCase();

  // Apply search filter
  var filteredReviews =
      reviews.where((review) {
        if (searchQuery.isEmpty) return true;
        return review.customerName.toLowerCase().contains(searchQuery) ||
            review.comment.toLowerCase().contains(searchQuery) ||
            review.serviceType.toLowerCase().contains(searchQuery);
      }).toList();

  // Apply rating filter
  switch (filter) {
    case ReviewFilterType.fiveStar:
      filteredReviews = filteredReviews.where((r) => r.rating >= 4.5).toList();
      break;
    case ReviewFilterType.fourStar:
      filteredReviews =
          filteredReviews
              .where((r) => r.rating >= 3.5 && r.rating < 4.5)
              .toList();
      break;
    case ReviewFilterType.threeStar:
      filteredReviews =
          filteredReviews
              .where((r) => r.rating >= 2.5 && r.rating < 3.5)
              .toList();
      break;
    case ReviewFilterType.twoStar:
      filteredReviews =
          filteredReviews
              .where((r) => r.rating >= 1.5 && r.rating < 2.5)
              .toList();
      break;
    case ReviewFilterType.oneStar:
      filteredReviews = filteredReviews.where((r) => r.rating < 1.5).toList();
      break;
    case ReviewFilterType.all:
      break;
  }

  // Apply sorting
  switch (sort) {
    case ReviewSortType.newest:
      filteredReviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case ReviewSortType.oldest:
      filteredReviews.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      break;
    case ReviewSortType.highestRated:
      filteredReviews.sort((a, b) => b.rating.compareTo(a.rating));
      break;
    case ReviewSortType.lowestRated:
      filteredReviews.sort((a, b) => a.rating.compareTo(b.rating));
      break;
  }

  return filteredReviews;
});

// Paginated reviews provider
final paginatedReviewsProvider = Provider.family<List<ReviewModel>, String>((
  ref,
  searchQuery,
) {
  final filteredReviews = ref.watch(filteredReviewsProvider);
  final pagination = ref.watch(reviewsPaginationProvider);

  final endIndex = pagination.currentPage * pagination.itemsPerPage;

  if (endIndex >= filteredReviews.length) {
    return filteredReviews;
  }

  return filteredReviews.take(endIndex).toList();
});

// Reviews statistics provider
final reviewsStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final reviews = ref.watch(mockReviewsProvider);

  if (reviews.isEmpty) {
    return {
      'averageRating': 0.0,
      'totalReviews': 0,
      'ratingDistribution': [0, 0, 0, 0, 0],
    };
  }

  final totalRating = reviews.fold(0.0, (sum, review) => sum + review.rating);
  final averageRating = totalRating / reviews.length;

  final ratingDistribution = [0, 0, 0, 0, 0];
  for (final review in reviews) {
    final index = (review.rating - 1).floor().clamp(0, 4);
    ratingDistribution[index]++;
  }

  return {
    'averageRating': averageRating,
    'totalReviews': reviews.length,
    'ratingDistribution': ratingDistribution,
  };
});
