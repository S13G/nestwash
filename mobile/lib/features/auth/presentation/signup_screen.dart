import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/auth/provider/auth_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:nestcare/shared/widgets/nest_form_fields.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignupScreen extends HookConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final state = ref.watch(signupProvider);
    final controller = ref.read(signupProvider.notifier);

    useToastEffect(context, error: state.error, success: state.success);

    return NestScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to NestWash",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Sign up to experience premium laundry services",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 1.h),
                    ImageWidget(
                      imageName: "email_icon",
                      width: double.infinity,
                      height: 32.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Enter your email to get started",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 2.h),
                    NestForm(
                      formKey: formKey,
                      spacing: 2,
                      submitText: "Submit Code",
                      fields: [
                        NestFormField(
                          controller: emailController,
                          hintText: "Email Address",
                          prefixIcon: Icon(Icons.email_outlined),
                          belowSpacing: false,
                          validator: (value) {
                            if (value == null || !value.contains("@")) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                        ),
                      ],
                      onSubmit: () {
                        if (!formKey.currentState!.validate()) return;
                        controller.enterEmail(emailController.text);
                      },
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
            // Footer section with login link
            RichText(
              text: TextSpan(
                text: "I have an account? ",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                ),
                children: [
                  TextSpan(
                    text: "Log in",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            context.goNamed("login");
                          },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
