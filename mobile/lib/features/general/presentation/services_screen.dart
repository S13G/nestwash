import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/providers/profile_card_provider.dart';
import 'package:nestcare/providers/services_provider.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:nestcare/shared/widgets/profile_card_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController searchController = TextEditingController();

    final services = ref.watch(filteredServiceProvider);

    final searchFocusNode = ref.read(searchFocusNodeProvider);
    searchFocusNode.addListener(() {
      if (!searchFocusNode.hasFocus) {
        // When user taps outside, clear search
        ref.read(searchTextProvider.notifier).state = '';
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileCardWidget(
          theme: theme,
          formKey: formKey,
          searchController: searchController,
          searchFocusNode: searchFocusNode,
        ),
        SizedBox(height: 3.h),
        Padding(
          padding: EdgeInsets.only(left: 3.h),
          child: Text('Services', style: theme.textTheme.bodyLarge),
        ),
        SizedBox(height: 3.h),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 40,
              crossAxisSpacing: 40,
              childAspectRatio: 0.8,
            ),
            itemCount: services.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: theme.colorScheme.onPrimary,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImageWidget(
                      imageName: services[index].serviceTitleImageName!,
                      height: 9.h,
                      width: 9.h,
                    ),
                    Text(
                      services[index].serviceTitle!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
