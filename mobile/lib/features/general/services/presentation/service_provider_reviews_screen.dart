import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/features/general/services/model/review_model.dart';
import 'package:nestcare/features/general/services/model/service_provider_model.dart';
import 'package:nestcare/features/general/services/presentation/widgets/rating_modal.dart';
import 'package:nestcare/features/general/widgets/search_widget.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:nestcare/providers/reviews_provider.dart';
import 'package:nestcare/shared/util/general_utils.dart';
import 'package:nestcare/shared/widgets/loader_widget.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ServiceProviderReviewsScreen extends HookConsumerWidget {
  final ServiceProvider provider;

  const ServiceProviderReviewsScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final animations = useLaundryAnimations(null);
    final scrollController = useScrollController();

    final selectedFilter = ref.watch(reviewsFilterProvider);
    final selectedSort = ref.watch(reviewsSortProvider);
    final searchText = ref.watch(searchTextProvider);
    final paginatedReviews = ref.watch(paginatedReviewsProvider(searchText));
    final reviewsStats = ref.watch(reviewsStatsProvider);
    final pagination = ref.watch(reviewsPaginationProvider);

    // Pagination scroll listener
    useEffect(() {
      void onScroll() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          _loadMoreReviews(ref);
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    return NestScaffold(
      showBackButton: true,
      title: "Reviews & Ratings",
      body: FadeTransition(
        opacity: animations.fadeAnimation,
        child: Column(
          children: [
            _buildReviewsHeader(theme, reviewsStats),
            SizedBox(height: 3.h),
            _buildSearchAndFilters(ref, theme, selectedFilter, selectedSort),
            SizedBox(height: 2.h),
            Expanded(
              child: _buildReviewsList(
                paginatedReviews,
                animations,
                theme,
                scrollController,
                pagination,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsHeader(ThemeData theme, Map<String, dynamic> stats) {
    final averageRating = stats['averageRating'] as double;
    final totalReviews = stats['totalReviews'] as int;
    final ratingDistribution = stats['ratingDistribution'] as List<int>;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          Icons.star_rounded,
                          color:
                              index < averageRating.floor()
                                  ? Colors.amber
                                  : Colors.grey.withValues(alpha: 0.3),
                          size: 5.w,
                        );
                      }),
                    ),
                    SizedBox(height: 1.w),
                    Text(
                      '$totalReviews reviews',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: List.generate(5, (index) {
                    final starCount = 5 - index;
                    final count = ratingDistribution[4 - index];
                    final percentage =
                        totalReviews > 0 ? count / totalReviews : 0.0;

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.5.w),
                      child: Row(
                        children: [
                          Text(
                            '$starCount',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          Icon(Icons.star, size: 3.w, color: Colors.amber),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: percentage,
                              backgroundColor: Colors.grey.withValues(
                                alpha: 0.2,
                              ),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '$count',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(
    WidgetRef ref,
    ThemeData theme,
    ReviewFilterType selectedFilter,
    ReviewSortType selectedSort,
  ) {
    return Column(
      children: [
        SearchWidget(hintText: 'Search reviews...'),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(child: _buildFilterDropdown(ref, theme, selectedFilter)),
            SizedBox(width: 3.w),
            Expanded(child: _buildSortDropdown(ref, theme, selectedSort)),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(
    WidgetRef ref,
    ThemeData theme,
    ReviewFilterType selectedFilter,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ReviewFilterType>(
          value: selectedFilter,
          isExpanded: true,
          icon: Icon(
            LucideIcons.chevronDown,
            color: theme.colorScheme.onPrimaryContainer,
            size: 4.w,
          ),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSecondary,
          ),
          dropdownColor: theme.colorScheme.onTertiaryContainer,
          onChanged: (ReviewFilterType? newValue) {
            if (newValue != null) {
              HapticFeedback.lightImpact();
              ref.read(reviewsFilterProvider.notifier).state = newValue;
              _resetPagination(ref);
            }
          },
          items: [
            DropdownMenuItem(
              value: ReviewFilterType.all,
              child: Text('All Reviews'),
            ),
            DropdownMenuItem(
              value: ReviewFilterType.fiveStar,
              child: Text('5 Stars'),
            ),
            DropdownMenuItem(
              value: ReviewFilterType.fourStar,
              child: Text('4 Stars'),
            ),
            DropdownMenuItem(
              value: ReviewFilterType.threeStar,
              child: Text('3 Stars'),
            ),
            DropdownMenuItem(
              value: ReviewFilterType.twoStar,
              child: Text('2 Stars'),
            ),
            DropdownMenuItem(
              value: ReviewFilterType.oneStar,
              child: Text('1 Star'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortDropdown(
    WidgetRef ref,
    ThemeData theme,
    ReviewSortType selectedSort,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ReviewSortType>(
          value: selectedSort,
          isExpanded: true,
          icon: Icon(
            LucideIcons.chevronDown,
            color: theme.colorScheme.onPrimaryContainer,
            size: 4.w,
          ),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSecondary,
          ),
          dropdownColor: theme.colorScheme.onTertiaryContainer,
          onChanged: (ReviewSortType? newValue) {
            if (newValue != null) {
              HapticFeedback.lightImpact();
              ref.read(reviewsSortProvider.notifier).state = newValue;
              _resetPagination(ref);
            }
          },
          items: [
            DropdownMenuItem(
              value: ReviewSortType.newest,
              child: Text('Newest First'),
            ),
            DropdownMenuItem(
              value: ReviewSortType.oldest,
              child: Text('Oldest First'),
            ),
            DropdownMenuItem(
              value: ReviewSortType.highestRated,
              child: Text('Highest Rated'),
            ),
            DropdownMenuItem(
              value: ReviewSortType.lowestRated,
              child: Text('Lowest Rated'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsList(
    List<ReviewModel> reviews,
    LaundryAnimations animations,
    ThemeData theme,
    ScrollController scrollController,
    ReviewsPaginationState pagination,
  ) {
    if (reviews.isEmpty) {
      return _buildEmptyState(theme);
    }

    return SlideTransition(
      position: animations.slideAnimation,
      child: ListView.builder(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        itemCount: reviews.length + (pagination.hasReachedEnd ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == reviews.length) {
            return _buildLoadingIndicator(theme, pagination);
          }

          final review = reviews[index];
          return _buildReviewCard(review, theme, index);
        },
      ),
    );
  }

  Widget _buildReviewCard(ReviewModel review, ThemeData theme, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.onTertiary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(LucideIcons.user, color: Colors.white, size: 6.w),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.customerName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),
                    SizedBox(height: 1.w),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              Icons.star_rounded,
                              color:
                                  starIndex < review.rating.floor()
                                      ? Colors.amber
                                      : Colors.grey.withValues(alpha: 0.3),
                              size: 3.5.w,
                            );
                          }),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.w,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            review.serviceType,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                OrderUtils.formatDate(review.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Text(
            review.comment,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(
    ThemeData theme,
    ReviewsPaginationState pagination,
  ) {
    if (pagination.isLoading) {
      return LoaderWidget(color: theme.colorScheme.primary);
    }
    return const SizedBox.shrink();
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.messageSquare,
            size: 20.w,
            color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.5),
          ),
          SizedBox(height: 3.h),
          Text(
            'No Reviews Found',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSecondary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'No reviews match your current filters.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _loadMoreReviews(WidgetRef ref) {
    final pagination = ref.read(reviewsPaginationProvider);

    if (!pagination.isLoading && !pagination.hasReachedEnd) {
      ref.read(reviewsPaginationProvider.notifier).state = pagination.copyWith(
        isLoading: true,
      );

      // Simulate API call delay
      Future.delayed(const Duration(seconds: 1), () {
        final filteredReviews = ref.read(filteredReviewsProvider);
        final currentDisplayed =
            ref
                .read(paginatedReviewsProvider(ref.read(searchTextProvider)))
                .length;

        final hasMore = currentDisplayed < filteredReviews.length;

        ref.read(reviewsPaginationProvider.notifier).state = pagination
            .copyWith(
              currentPage: pagination.currentPage + 1,
              isLoading: false,
              hasReachedEnd: !hasMore,
            );
      });
    }
  }

  void _resetPagination(WidgetRef ref) {
    ref.read(reviewsPaginationProvider.notifier).state =
        ReviewsPaginationState();
  }
}
