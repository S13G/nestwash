import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/widgets/menu_subtitle_widget.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:nestcare/shared/widgets/logout_button_widget.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';

class CustomerMenuScreen extends ConsumerWidget {
  const CustomerMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return NestScaffold(
      showBackButton: true,
      title: "menu",
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MenuSubtitleWidget(title: 'communication'),
                  MenuItemWidget(
                    title: 'chat',
                    iconName: 'chat_icon',
                    onTap: () => context.pushNamed("chat-list"),
                  ),
                  MenuSubtitleWidget(title: 'Account settings'),
                  MenuItemWidget(
                    title: 'personal details',
                    iconName: 'account_icon',
                    onTap:
                        () => ref
                            .read(routerProvider)
                            .pushNamed("customer_profile"),
                  ),
                  MenuItemWidget(
                    title: 'transaction history',
                    iconName: 'transactions_icon',
                  ),
                  MenuItemWidget(
                    title: 'addresses',
                    iconName: 'addresses_icon',
                    onTap:
                        () => ref
                            .read(routerProvider)
                            .pushNamed("customer_addresses"),
                  ),
                  MenuItemWidget(
                    title: 'invite friends',
                    iconName: 'invite_icon',
                    onTap: () => context.pushNamed("invites"),
                  ),
                  MenuSubtitleWidget(title: 'help center'),
                  MenuItemWidget(
                    title: 'support',
                    iconName: 'support_icon',
                    onTap: () => context.pushNamed("support"),
                  ),
                  MenuItemWidget(
                    title: 'terms of service',
                    iconName: 'terms_icon',
                  ),
                ],
              ),
            ),
          ),
          LogoutButtonWidget(),
        ],
      ),
    );
  }
}
