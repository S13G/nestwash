import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/auth/provider/auth_provider.dart';
import 'package:nestcare/providers/auth_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:nestcare/shared/widgets/nest_form_fields.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final signupState = ref.watch(signupProvider);
    final state = ref.watch(loginProvider);
    final emailController = useTextEditingController(
      text: signupState.data?.email ?? '',
    );
    final passwordController = useTextEditingController(
      text: signupState.data?.password ?? '',
    );
    final controller = ref.read(loginProvider.notifier);
    final isLoading = ref.watch(loadingProvider);

    useToastEffect(context, error: state.error, success: state.success);

    return NestScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 3.h),
              Text(
                "Welcome Back!",
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
                submitText: "Login",
                isLoading: isLoading,
                fields: [
                  NestFormField(
                    controller: emailController,
                    hintText: "Email Address",
                    inFormLabelText: "Email Address",
                    prefixIcon: Icon(Icons.email_outlined),
                    belowSpacing: true,
                    validator: (value) {
                      if (value == null || !value.contains("@")) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),

                  // Password
                  NestFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    belowSpacing: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    inFormLabelText: "Password",
                    hintText: "Password",
                    prefixIcon: Icon(Icons.password),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot password?",
                        textAlign: TextAlign.end,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  ImageWidget(
                    imageName: "login_account_image",
                    width: double.infinity,
                    height: 40.h,
                  ),
                ],
                onSubmit: () {
                  if (!formKey.currentState!.validate()) return;
                  controller.login(
                    emailController.text,
                    passwordController.text,
                    signupState.data?.accountType ?? 'customer',
                  );
                },
              ),
              SizedBox(height: 2.h),
              RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                  children: [
                    TextSpan(
                      text: "Register",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              context.goNamed("signup");
                            },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
