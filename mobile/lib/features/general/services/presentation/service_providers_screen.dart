import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:nestcare/providers/services_provider.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:nestcare/shared/widgets/nest_form_fields.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ServiceProvidersScreen extends ConsumerWidget {
  const ServiceProvidersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final serviceProviders = ref.watch(filteredSpecificCareServiceProviders);
    final serviceTitle = ref.watch(selectedServiceTitleProvider);

    return NestScaffold(
      showBackButton: true,
      title: serviceTitle.toString(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Only available service providers are shown below.",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          NestFormField(
            controller: ref.watch(
              searchSpecificServiceProviderControllerProvider,
            ),
            hintText: "Search service providers...",
            prefixIcon: Icon(Icons.search),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            itemCount: serviceProviders.length,
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) => SizedBox(height: 4.h),
            itemBuilder: (context, index) {
              final serviceProvider = serviceProviders[index];

              return AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: Container(
                  key: ValueKey(serviceProvider["name"]),
                  padding: EdgeInsets.zero,
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .read(selectedServiceProviderNameProvider.notifier)
                          .state = serviceProvider["name"]!;
                      ref
                          .read(routerProvider)
                          .pushNamed("service_provider_info");
                    },
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            ref
                                .read(
                                  selectedServiceProviderNameProvider.notifier,
                                )
                                .state = serviceProvider["name"]!;
                            ref
                                .read(routerProvider)
                                .pushNamed("service_provider_profile");
                          },
                          child: CircleAvatar(
                            radius: 30,
                            child: ImageWidget(
                              imageName: serviceProvider["profile_image"]!,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        SizedBox(width: 3.h),
                        Text(
                          "${serviceProvider["name"]}",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.star, color: Colors.yellow),
                        Text(serviceProvider["rating"]!),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
