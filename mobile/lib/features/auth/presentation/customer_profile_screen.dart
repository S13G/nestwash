import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/providers/auth_provider.dart';
import 'package:nestcare/providers/user_provider.dart';
import 'package:nestcare/shared/widgets/nest_form_fields.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';

class CustomerProfileScreen extends ConsumerWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final fullNameController = ref.watch(fullNameControllerProvider);
    final isLoading = ref.watch(loadingProvider);

    final user = ref.watch(userProvider);

    if (user != null && fullNameController.text.isEmpty) {
      fullNameController.text = user.fullName;
    }

    return NestScaffold(
      showBackButton: true,
      title: 'personal details',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NestForm(
            formKey: formKey,
            isLoading: isLoading,
            spacing: 8,
            fields: [NestFormField(controller: fullNameController)],
            onSubmit: () {},
          ),
        ],
      ),
    );
  }
}
