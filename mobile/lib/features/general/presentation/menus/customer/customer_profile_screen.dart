import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/providers/auth_provider.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:nestcare/providers/user_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/nest_form_fields.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomerProfileScreen extends ConsumerWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final fullNameController = ref.watch(fullNameControllerProvider);
    final isLoading = ref.watch(loadingProvider);

    final user = ref.watch(userProvider);
    final emailController = ref.watch(emailControllerProvider);

    if (user != null && fullNameController.text.isEmpty) {
      fullNameController.text = user.fullName;
    }
    if (user != null && emailController.text.isEmpty) {
      emailController.text = user.email;
    }

    void onHandleEditDetailsSubmit(
      GlobalKey<FormState> formKey,
      BuildContext context,
      TextEditingController fullNameController,
      TextEditingController emailController,
      WidgetRef ref,
    ) {
      if (!formKey.currentState!.validate()) {
        ToastUtil.showErrorToast(context, "Please fill in all fields");
        return;
      }
      ref.read(loadingProvider.notifier).state = true;
      ref
          .read(userProvider.notifier)
          .setUser(emailController.text, fullNameController.text, null);
      ref.read(loadingProvider.notifier).state = false;
      ToastUtil.showSuccessToast(context, "Saved successfully");
      ref.read(routerProvider).pop();
    }

    return NestScaffold(
      showBackButton: true,
      title: 'personal details',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NestForm(
              formKey: formKey,
              isLoading: isLoading,
              spacing: 1,
              fields: [
                NestFormField(
                  controller: fullNameController,
                  hintText: "Enter full name",
                  underlinedBorder: true,
                  label: "Name",
                  contentPadding: EdgeInsets.zero,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 4.h),
                NestFormField(
                  controller: emailController,
                  underlinedBorder: true,
                  readOnly: true,
                  label: "Email address",
                  contentPadding: EdgeInsets.zero,
                ),
              ],
              onSubmit:
                  () => onHandleEditDetailsSubmit(
                    formKey,
                    context,
                    fullNameController,
                    emailController,
                    ref,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
