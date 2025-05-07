import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/widgets/address_card_widget.dart';
import 'package:nestcare/providers/user_provider.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomerAddressScreen extends ConsumerWidget {
  const CustomerAddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final addresses = ref.watch(dummyAddressDataProvider);

    return NestScaffold(
      showBackButton: true,
      title: "addresses",
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: addresses.length,
              separatorBuilder: (context, index) => SizedBox(height: 3.h),
              itemBuilder: (context, index) {
                final address = addresses[index];
                return GestureDetector(
                  onTap: () {
                    context.pop(true);
                  },
                  child: AddressCard(
                    street: address["street"] ?? '',
                    houseNumber: address["houseNumber"] ?? '',
                    theme: theme,
                  ),
                );
              },
            ),
            SizedBox(height: 1.h),
            TextButton(
              onPressed: () {
                context.pushNamed("edit_address");
              },
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(
                "+ Add new address",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
