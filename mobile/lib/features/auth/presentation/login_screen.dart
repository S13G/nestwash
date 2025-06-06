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
    final formKey = useRef(GlobalKey<FormState>()).value;

    // Get the signup state once and memoize the initial values
    final signupState = ref.read(signupProvider);
    final initialEmail = useMemoized(() => signupState.data?.email ?? '', [
      signupState,
    ]);
    final initialPassword = useMemoized(
      () => signupState.data?.password ?? '',
      [signupState],
    );

    final state = ref.watch(loginProvider);
    final emailController = useTextEditingController(text: initialEmail);
    final passwordController = useTextEditingController(text: initialPassword);
    final controller = ref.read(loginProvider.notifier);
    final obscureText = ref.watch(passwordVisibilityProvider);

    useToastEffect(context, error: state.error, success: state.success);

    return NestScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
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
              spacing: 1,
              submitText: "Login",
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
                  obscureText: obscureText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
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
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.goNamed("forgot_password");
                    },
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

                final email = emailController.text;
                final password = passwordController.text;
                // Read the signup state again when submitting to get current account type
                final currentSignupState = ref.read(signupProvider);
                final accountType =
                    currentSignupState.data?.accountType ?? 'customer';

                controller.login(email, password, accountType);
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
    );
  }
}
