import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/widgets/profile_card_widget.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:nestcare/providers/services_provider.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final services = ref.watch(filteredServiceProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileCardWidget(theme: theme),
        SizedBox(height: 3.h),
        Padding(
          padding: EdgeInsets.only(left: 3.h),
          child: Text('Services', style: theme.textTheme.bodyLarge),
        ),
        SizedBox(height: 3.h),
        Expanded(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: GridView.builder(
              key: ValueKey(
                services.length.toString() +
                    services.map((s) => s.serviceTitle).join(),
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 40,
                crossAxisSpacing: 40,
                childAspectRatio: 0.8,
              ),
              itemCount: services.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    ref.read(selectedServiceTitleProvider.notifier).state =
                        services[index].serviceTitle!;
                    ref.read(routerProvider).pushNamed("service_providers");
                  },
                  child: Container(
                    key: ValueKey(services.length),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: theme.colorScheme.onPrimary,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconImageWidget(
                          iconName: services[index].serviceTitleImageName!,
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
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
