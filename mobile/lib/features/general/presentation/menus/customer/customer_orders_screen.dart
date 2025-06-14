import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/features/general/model/order_model.dart';
import 'package:nestcare/features/general/widgets/search_widget.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:nestcare/providers/laundry_orders_providers.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomerOrdersScreen extends HookConsumerWidget {
  const CustomerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final selectedFilter = ref.watch(laundryOrderSelectedFilterProvider);
    final searchText = ref.watch(searchTextProvider);
    final filteredLaundryOrders = ref.watch(filteredLaundryOrdersProvider(searchText));
    final animations = useLaundryAnimations(null);

    return NestScaffold(
      showBackButton: true,
      title: 'my orders',
      body: FadeTransition(
        opacity: animations.fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header section
            _buildHeader(theme),

            SizedBox(height: 2.h),

            // search and filter section
            _buildSearchAndFilter(ref, theme, selectedFilter),

            // Orders List or Empty State
            Expanded(
              child: filteredLaundryOrders.isEmpty ? _buildEmptyState(theme, selectedFilter) : _buildOrdersList(filteredLaundryOrders, animations),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My Orders', style: theme.textTheme.titleLarge),
        SizedBox(height: 0.5.h),
        Text('Track your laundry orders', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
      ],
    );
  }

  Widget _buildSearchAndFilter(WidgetRef ref, ThemeData theme, FilterType selectedFilter) {
    return Column(
      children: [
        // Search Bar
        SearchWidget(hintText: 'Search orders...'),
        SizedBox(height: 3.h),

        // Filter Buttons
        Row(
          children: [
            Expanded(child: _buildFilterButton(ref, theme, selectedFilter, 'All Orders', FilterType.all, Icons.list_alt_rounded)),
            SizedBox(width: 3.w),
            Expanded(child: _buildFilterButton(ref, theme, selectedFilter, 'Active', FilterType.active, Icons.schedule_rounded)),
            SizedBox(width: 3.w),
            Expanded(child: _buildFilterButton(ref, theme, selectedFilter, 'Past Orders', FilterType.past, Icons.history_rounded)),
          ],
        ),
        SizedBox(height: 3.h),
      ],
    );
  }

  Widget _buildFilterButton(WidgetRef ref, ThemeData theme, FilterType selectedFilter, String title, FilterType filter, IconData icon) {
    final isSelected = selectedFilter == filter;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        ref.read(laundryOrderSelectedFilterProvider.notifier).state = filter;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onTertiaryContainer,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? theme.colorScheme.primary : theme.colorScheme.primary.withValues(alpha: 0.2), width: 1),
          boxShadow:
              isSelected
                  ? [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 5))]
                  : [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : theme.colorScheme.primary, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected ? Colors.white : theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<Order> filteredLaundryOrders, LaundryAnimations animations) {
    return SlideTransition(
      position: animations.slideAnimation,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: filteredLaundryOrders.length,
        itemBuilder: (context, index) {
          final order = filteredLaundryOrders[index];
          return _buildOrderCard(order, index, context);
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order, int index, BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      margin: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          // Navigate to order details
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.colorScheme.onPrimary.withValues(alpha: 0.3), width: 1),
            boxShadow: [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 5))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('Order ${order.id}', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold))),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: getOrderStatusColor(order.status).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      getOrderStatusText(order.status),
                      style: theme.textTheme.bodySmall?.copyWith(color: getOrderStatusColor(order.status), fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.5.h),

              // Service Type
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(color: theme.colorScheme.onSurface.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                child: Text(order.serviceType, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary)),
              ),
              SizedBox(height: 1.5.h),
              // Items being cleaned
              Text('Items being cleaned:', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
              SizedBox(height: 1.h),
              // Items
              Wrap(spacing: 8, runSpacing: 8, children: order.items.map((item) => _buildItemChip(item, theme)).toList()),
              SizedBox(height: 1.h),

              // Time and Price Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(LucideIcons.clock, color: theme.colorScheme.onPrimaryContainer, size: 16),
                          const SizedBox(width: 5),
                          Text(
                            order.status == OrderStatus.completed
                                ? 'Delivered: ${order.deliveryDate.day} ${DateFormat('MMM, yyyy • h:mm a').format(order.deliveryDate)}'
                                : 'Delivery: ${order.deliveryDate.day} ${DateFormat('MMM, yyyy • h:mm a').format(order.deliveryDate)}',
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    '\$${order.totalPrice.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                  ),
                ],
              ),
              SizedBox(height: 1.5.h),
              LinearProgressIndicator(
                value: getOrderStatusProgressBarValue(order.status),
                backgroundColor: theme.colorScheme.surface,
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.onPrimary),
                borderRadius: BorderRadius.circular(10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemChip(OrderItem item, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(item.name, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary)),
    );
  }

  Widget _buildEmptyState(ThemeData theme, FilterType selectedFilter) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40.w,
              height: 18.5.h,
              decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(30)),
              child: Icon(LucideIcons.washingMachine, size: 80, color: theme.colorScheme.primary.withValues(alpha: 0.5)),
            ),
            SizedBox(height: 4.h),
            Text(_getEmptyStateTitle(selectedFilter), style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
            SizedBox(height: 1.5.h),
            Text(
              _getEmptyStateSubtitle(selectedFilter),
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onPrimaryContainer, height: 1.5),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.5.h),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                // Navigate to create order
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.5.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary, theme.colorScheme.onTertiary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 5))],
                ),
                child: Text(
                  'Schedule Your First Order',
                  style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getEmptyStateTitle(FilterType selectedFilter) {
    switch (selectedFilter) {
      case FilterType.active:
        return 'No Active Orders';
      case FilterType.past:
        return 'No Past Orders';
      default:
        return 'No Orders Yet';
    }
  }

  String _getEmptyStateSubtitle(FilterType selectedFilter) {
    switch (selectedFilter) {
      case FilterType.active:
        return 'You don\'t have any active orders at the moment. Schedule a pickup to get started!';
      case FilterType.past:
        return 'Your completed orders will appear here once you start using our service.';
      default:
        return 'Ready to make your first order?\nSchedule your first pickup today!';
    }
  }
}
