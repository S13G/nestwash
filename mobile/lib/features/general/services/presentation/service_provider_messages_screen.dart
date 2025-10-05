import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/model/chat_model.dart';
import 'package:nestcare/features/general/widgets/search_widget.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/providers/chat_provider.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ServiceProviderMessagesScreen extends HookConsumerWidget {
  const ServiceProviderMessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final searchText = ref.watch(searchTextProvider);
    final selectedFilter = ref.watch(selectedChatsCategoriesProvider);
    final filteredChats = ref.watch(filteredChatsProvider(searchText));
    final totalUnreadCount = ref.watch(totalUnreadCountProvider);
    final animations = useLaundryAnimations(null);

    return FadeTransition(
      opacity: animations.fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header section
          _buildHeader(theme),

          SizedBox(height: 2.h),

          // Search Bar
          _buildSearchBar(),
          SizedBox(height: 2.h),

          // Filter Tabs
          _buildFilterTabs(
            theme,
            ref,
            filteredChats: filteredChats.length,
            totalUnreadCount: totalUnreadCount,
            selectedFilter: selectedFilter,
          ),
          SizedBox(height: 2.h),

          // Chat List
          Expanded(
            child: SlideTransition(
              position: animations.slideAnimation,
              child: _buildChatList(
                context,
                theme,
                filteredChats: filteredChats,
                searchText: searchText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// header section
  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Messages', style: theme.textTheme.titleLarge),
        SizedBox(height: 0.5.h),
        Text(
          'Stay connected with your clients',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SearchWidget(hintText: 'Search messages...');
  }

  Widget _buildFilterTabs(
    ThemeData theme,
    WidgetRef ref, {
    required int filteredChats,
    required int totalUnreadCount,
    required ChatMessageFilterType selectedFilter,
  }) {
    return Row(
      children: [
        _buildFilterTab(
          ChatMessageFilterType.all,
          filteredChats,
          theme,
          ref,
          selectedFilter: selectedFilter,
        ),
        SizedBox(width: 2.w),
        _buildFilterTab(
          ChatMessageFilterType.unread,
          totalUnreadCount,
          theme,
          ref,
          selectedFilter: selectedFilter,
        ),
        SizedBox(width: 2.w),
        _buildFilterTab(
          ChatMessageFilterType.favorites,
          filteredChats,
          theme,
          ref,
          selectedFilter: selectedFilter,
        ),
      ],
    );
  }

  Widget _buildFilterTab(
    ChatMessageFilterType title,
    int count,
    ThemeData theme,
    ref, {
    required ChatMessageFilterType selectedFilter,
  }) {
    final isSelected = selectedFilter == title;
    return Expanded(
      child: GestureDetector(
        onTap:
            () =>
                ref.watch(selectedChatsCategoriesProvider.notifier).state =
                    title,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onTertiaryContainer,
            borderRadius: BorderRadius.circular(3.w),
            boxShadow: [
              BoxShadow(
                color:
                    isSelected
                        ? theme.colorScheme.primary.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${title.name[0].toUpperCase()}${title.name.substring(1)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:
                      isSelected ? Colors.white : theme.colorScheme.onSecondary,
                ),
              ),
              if (count > 0) ...[
                SizedBox(width: 1.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Colors.white.withValues(alpha: 0.3)
                            : theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Text(
                    count.toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                          isSelected ? Colors.white : theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatList(
    BuildContext context,
    ThemeData theme, {
    required List<ChatMessage> filteredChats,
    required String searchText,
  }) {
    if (filteredChats.isEmpty) {
      return _buildEmptyState(theme, searchQuery: searchText);
    }

    return ListView.builder(
      itemCount: filteredChats.length,
      itemBuilder: (context, index) {
        final chat = filteredChats[index];
        return _buildChatItem(chat, theme, context);
      },
    );
  }

  Widget _buildChatItem(
    ChatMessage chat,
    ThemeData theme,
    BuildContext context,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => context.pushNamed('chat'),
        contentPadding: EdgeInsets.all(4.w),
        leading: Stack(
          children: [
            Container(
              width: 14.w,
              height: 14.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.onPrimary,
                    theme.colorScheme.onSurface,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(7.w),
              ),
              child: Center(
                child: Text(
                  chat.avatar,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (chat.isOnline)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 4.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: theme.colorScheme.onTertiaryContainer,
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                chat.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: chat.isUnread ? FontWeight.bold : FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0.5.h),
            Text(
              chat.lastMessage,
              style: theme.textTheme.bodySmall?.copyWith(
                color:
                    chat.isUnread
                        ? theme.colorScheme.onSecondary
                        : theme.colorScheme.onPrimaryContainer,
                fontWeight: chat.isUnread ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              chat.time,
              style: theme.textTheme.bodySmall?.copyWith(
                color:
                    chat.isUnread
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onPrimaryContainer,
                fontWeight: chat.isUnread ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (chat.unreadCount > 0) ...[
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.all(1.5.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(3.w),
                ),
                constraints: BoxConstraints(minWidth: 6.w, minHeight: 6.w),
                child: Text(
                  chat.unreadCount > 99 ? '99+' : chat.unreadCount.toString(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, {required String searchQuery}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15.w),
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 15.w,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            searchQuery.isNotEmpty ? 'No messages found' : 'No messages yet',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 1.h),
          Text(
            searchQuery.isNotEmpty
                ? 'Try searching with different keywords'
                : 'Start a conversation with your service providers',
            style: TextStyle(
              fontSize: 14.sp,
              color: theme.colorScheme.onPrimaryContainer,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
