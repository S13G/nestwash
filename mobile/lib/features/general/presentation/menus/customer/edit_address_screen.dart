import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/providers/auth_provider.dart';
import 'package:nestcare/providers/user_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/nest_form_fields.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditAddressScreen extends ConsumerWidget {
  const EditAddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final addressController = ref.watch(addressControllerProvider);
    final cityController = ref.watch(cityControllerProvider);

    return NestScaffold(
      showBackButton: true,
      title: "address",
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NestForm(
              formKey: formKey,
              spacing: 1,
              fields: [
                NestFormField(
                  controller: addressController,
                  hintText: "Enter address",
                  label: "Address",
                  belowSpacing: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 4.h),
                NestFormField(
                  controller: cityController,
                  hintText: "Enter city",
                  label: "City",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a city';
                    }
                    return null;
                  },
                ),
              ],
              onSubmit:
                  () => onHandleSubmit(
                    formKey,
                    context,
                    addressController,
                    cityController,
                    ref,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void onHandleSubmit(
    GlobalKey<FormState> formKey,
    BuildContext context,
    TextEditingController addressController,
    TextEditingController cityController,
    WidgetRef ref,
  ) {
    if (!formKey.currentState!.validate()) {
      ToastUtil.showErrorToast(context, "Please fill in all fields");
      return;
    }
    ref.read(loadingProvider.notifier).state = true;
    // ref.read(userProvider.notifier).addAddress(addressController.text);
    ref.read(loadingProvider.notifier).state = false;
    ToastUtil.showSuccessToast(context, "Saved successfully");
    context.pop();
  }
}
