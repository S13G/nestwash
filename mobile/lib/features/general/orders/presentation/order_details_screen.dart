import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';

class OrderDetailsScreen extends ConsumerWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NestScaffold(
      showBackButton: true,
      backButtonOnPressed: () {
        ref.read(bottomNavigationProvider.notifier).state = 1;
        context.goNamed('bottom_nav');
      },
      title: 'order details',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NestButton(
              text: 'Check status',
              onPressed: () => context.pushNamed("track_order"),
            ),
          ],
        ),
      ),
    );
  }
}
