import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/auth/provider/auth_provider.dart';
import 'package:nestcare/providers/auth_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/nest_form_fields.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:go_router/go_router.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';

class RegistrationScreen extends HookConsumerWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final state = ref.watch(signupProvider);

    // Derive accountType from state or route (fallback: customer)
    final accountType =
        state.data?.accountType ??
        GoRouterState.of(context).uri.queryParameters['accountType'] ??
        'service_provider';

    // Common controllers
    final emailController = useTextEditingController(
      text: state.data?.email ?? '',
    );
    final fullNameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final controller = ref.read(signupProvider.notifier);
    final obscureText = ref.watch(passwordVisibilityProvider);

    // Provider-only controllers
    final businessNameController = useTextEditingController();
    final addressController = useTextEditingController();

    useToastEffect(context, error: state.error, success: state.success);

    return NestScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header based on account type
            Text(
              accountType == 'service_provider'
                  ? "Register Your Business"
                  : "Create Your Account",
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),

            // Customer path: Google + Email form
            if (accountType == 'customer') ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: NestButton(
                  text: "Sign in with Google",
                  prefixIcon: Icon(Icons.login),
                  onPressed: () async {
                    // Google OAuth2 stubbed via controller
                    await ref
                        .read(loginProvider.notifier)
                        .loginWithGoogle('customer');
                  },
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "or",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 2.h),

              NestForm(
                formKey: formKey,
                spacing: 2,
                submitText: "Register",
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
                ],
                onSubmit: () async {
                  if (!formKey.currentState!.validate()) return;
                  await controller.completeSignup(
                    fullNameController.text,
                    passwordController.text,
                    'customer',
                  );
                },
              ),
            ],

            // Provider path: Business + personal + address
            if (accountType == 'service_provider') ...[
              NestForm(
                formKey: formKey,
                spacing: 2,
                submitText: "Register Business",
                fields: [
                  NestFormField(
                    controller: businessNameController,
                    hintText: "Business name",
                    inFormLabelText: "Business name",
                    prefixIcon: Icon(Icons.store),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter business name";
                      }
                      return null;
                    },
                  ),
                  NestFormField(
                    controller: fullNameController,
                    hintText: "Owner/Manager name",
                    inFormLabelText: "Name",
                    prefixIcon: Icon(Icons.person),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a name";
                      }
                      return null;
                    },
                  ),
                  NestFormField(
                    controller: addressController,
                    hintText: "Business address",
                    inFormLabelText: "Address",
                    prefixIcon: Icon(Icons.location_on_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter business address";
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
                ],
                onSubmit: () async {
                  if (!formKey.currentState!.validate()) return;

                  await controller.completeSignup(
                    fullNameController.text,
                    passwordController.text,
                    'service_provider',
                  );

                  // After successful provider registration, show KYC CTA
                  ToastUtil.showSuccessToast(
                    context,
                    "Business registered. Please proceed with KYC verification.",
                  );
                },
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: NestOutlinedButton(
                  text: "Proceed to KYC Verification",
                  prefixIcon: Icon(Icons.verified_user_outlined),
                  onPressed: () {
                    // Stub: No KYC screen required as per instruction.
                    ToastUtil.showSuccessToast(
                      context,
                      "Navigating to KYC verification...",
                    );
                    // If a route exists, this is where we'd navigate.
                    // e.g., ref.read(routerProvider).goNamed('kyc_verification');
                  },
                ),
              ),
            ],

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
