import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchWidget extends HookConsumerWidget {
  final String hintText;

  const SearchWidget({super.key, required this.hintText});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchText = ref.watch(searchTextProvider);
    final searchController = useTextEditingController();

    final theme = Theme.of(context);

    useEffect(() {
      if (searchController.text != searchText) {
        searchController.text = searchText;
        searchController.selection = TextSelection.fromPosition(TextPosition(offset: searchController.text.length));
      }
      return null;
    }, [searchText]);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: theme.colorScheme.primary.withAlpha(0.08 * 255 ~/ 1), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: TextFormField(
        controller: searchController,
        onChanged: (value) {
          ref.read(searchTextProvider.notifier).state = value;
        },
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          hintText: hintText,
          hintStyle: TextStyle(color: theme.colorScheme.onPrimaryContainer),
          prefixIcon: Icon(LucideIcons.search, color: theme.colorScheme.onPrimaryContainer),
          suffixIcon:
              searchText.isNotEmpty
                  ? GestureDetector(
                    onTap: () {
                      ref.read(searchTextProvider.notifier).state = '';
                    },
                    child: Icon(Icons.clear_rounded, color: theme.colorScheme.onPrimaryContainer),
                  )
                  : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }
}
