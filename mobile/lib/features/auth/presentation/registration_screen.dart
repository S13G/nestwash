import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/auth/provider/auth_provider.dart';
import 'package:nestcare/providers/auth_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:nestcare/shared/widgets/nest_form_fields.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegistrationScreen extends HookConsumerWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final state = ref.watch(signupProvider);
    final emailController = useTextEditingController(
      text: state.data?.email ?? '',
    );
    final fullNameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final controller = ref.read(signupProvider.notifier);
    final obscureText = ref.watch(passwordVisibilityProvider);
    final isLoading = ref.watch(loadingProvider);

    useToastEffect(context, error: state.error, success: state.success);

    return NestScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 3.h),
              Text(
                "Create Your Account",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              NestForm(
                formKey: formKey,
                spacing: 2,
                submitText: "Register",
                isLoading: isLoading,
                fields: [
                  NestFormField(
                    controller: fullNameController,
                    hintText: "Full name",
                    inFormLabelText: "Full name",
                    prefixIcon: Icon(Icons.person),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a name";
                      }
                      return null;
                    },
                  ),
                  NestFormField(
                    enabled: false,
                    readOnly: true,
                    controller: emailController,
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  // Password
                  NestFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: obscureText,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password should not be less than 6 characters';
                      }
                      return null;
                    },
                    inFormLabelText: "Password",
                    hintText: "Password",
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        ref.read(passwordVisibilityProvider.notifier).state =
                            !obscureText;
                      },
                    ),
                  ),
                  // Drop Down List
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: state.data?.accountType,
                            items: [
                              DropdownMenuItem(
                                value: "customer",
                                child: Row(
                                  children: [
                                    Icon(Icons.person),
                                    SizedBox(width: 2.w),
                                    Text("Customer"),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: "service_provider",
                                child: Row(
                                  children: [
                                    Icon(Icons.support_agent),
                                    SizedBox(width: 2.w),
                                    Text("Service Provider"),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                controller.setAccountType(value);
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please select an account type";
                              }
                              return null;
                            },
                            style: theme.textTheme.bodyLarge,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.category),
                              labelText: "Account Type",
                            ),
                          ),
                          SizedBox(height: 27.h),
                        ],
                      ),
                      Positioned(
                        top: -2.h,
                        left: 20.w,
                        right: 0,
                        child: IgnorePointer(
                          ignoring: true,
                          child: ImageWidget(
                            imageName: "create_account_image",
                            width: double.infinity,
                            height: 45.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                onSubmit: () {
                  if (!formKey.currentState!.validate()) return;
                  controller.completeSignup(
                    fullNameController.text,
                    passwordController.text,
                    state.data?.accountType ?? '',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
