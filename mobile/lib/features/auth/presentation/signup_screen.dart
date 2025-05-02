import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/providers/auth_provider.dart';
import 'package:nestcare/providers/user_provider.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:nestcare/shared/widgets/nest_form_fields.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Get the initial page from router extra or default to 0
    final Object? extra = GoRouterState.of(context).extra;
    final initialPage = extra ?? 0;

    final pageController = PageController(initialPage: initialPage as int);
    final currentPage = ref.watch(pageIndexProvider);

    final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
    final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
    final GlobalKey<FormState> accountFormKey = GlobalKey<FormState>();
    final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

    final emailController = ref.watch(emailControllerProvider);
    final fullNameController = ref.watch(fullNameControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);
    final accountType = ref.watch(accountTypeProvider);
    final otpController = ref.watch(otpControllerProvider);

    // Get current loading state
    final isLoading = ref.watch(loadingProvider);
    // Get current password visibility state
    final obscureText = ref.watch(passwordVisibilityProvider);

    void handleRegisterSubmit(
      WidgetRef ref,
      GlobalKey<FormState> accountFormKey,
      TextEditingController fullNameController,
      TextEditingController emailController,
      TextEditingController passwordController,
      PageController pageController,
    ) {
      if (!accountFormKey.currentState!.validate()) return;
      ref.read(loadingProvider.notifier).state = true;
      ref
          .read(userProvider.notifier)
          .setUser(emailController.text, fullNameController.text, accountType);
      ref.read(loadingProvider.notifier).state = false;

      // Navigate to Login Screen
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }

    void handleLoginSubmit(
      WidgetRef ref,
      GlobalKey<FormState> loginFormKey,
      TextEditingController emailController,
      TextEditingController passwordController,
      PageController pageController,
    ) {
      if (!loginFormKey.currentState!.validate()) return;
      ref.read(loadingProvider.notifier).state = true;
      ref
          .read(userProvider.notifier)
          .setUser(emailController.text, fullNameController.text, null);
      ref.read(loadingProvider.notifier).state = false;

      // Navigate to home screen
      context.goNamed("bottom_nav");
    }

    void handleSubmit(
      WidgetRef ref,
      GlobalKey<FormState> emailFormKey,
      TextEditingController emailController,
      PageController pageController,
    ) {
      if (!emailFormKey.currentState!.validate()) return;
      ref.read(loadingProvider.notifier).state = true;
      ref.read(emailProvider.notifier).state = emailController.text;
      ref.read(loadingProvider.notifier).state = false;

      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }

    void handleOTPSubmit(
      WidgetRef ref,
      GlobalKey<FormState> otpFormKey,
      TextEditingController otpController,
      PageController pageController,
    ) {
      if (!otpFormKey.currentState!.validate()) return;
      ref.read(loadingProvider.notifier).state = true;
      ref.read(loadingProvider.notifier).state = false;

      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }

    return NestScaffold(
      appBar: null,
      padding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(160),
                ),
                child: ImageWidget(
                  width: double.infinity,
                  height: 52.h,
                  fit: BoxFit.cover,
                  imageName:
                      currentPage == 0 || currentPage == 3
                          ? 'signup'
                          : 'otp_image',
                ),
              ),

              Positioned(
                top: 10.h,
                left: 21.h,
                child: Container(
                  width: 24.h,
                  padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: theme.colorScheme.onPrimary.withAlpha(
                      (255 * 0.2).round(),
                    ),
                  ),
                  child: RichText(
                    text: TextSpan(
                      text:
                          currentPage == 0 || currentPage == 1
                              ? "Enter "
                              : currentPage == 2
                              ? "Create "
                              : "Sign in ",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                      children: [
                        TextSpan(
                          text:
                              currentPage == 0
                                  ? "email address.."
                                  : currentPage == 1
                                  ? "otp code.."
                                  : currentPage == 2
                                  ? "your Account.."
                                  : "to your Account..",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.h),
              child: PageView(
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  ref.read(pageIndexProvider.notifier).state = index;
                },
                children: [
                  // Register email screen
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NestForm(
                        formKey: emailFormKey,
                        spacing: 8,
                        isLoading: isLoading,
                        fields: [
                          NestFormField(
                            label: "Email address",
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email address';
                              }
                              if (!value.contains('@')) {
                                return 'Invalid email address';
                              }
                              return null;
                            },
                            underlinedBorder: true,
                            hintText: "Enter email address",
                            prefixIcon: Icon(Icons.email),
                          ),
                        ],
                        onSubmit: () {
                          handleSubmit(
                            ref,
                            emailFormKey,
                            emailController,
                            pageController,
                          );
                        },
                        submitText: "Send Code",
                      ),
                      Spacer(),
                      Center(
                        child: InkWell(
                          onTap: () {
                            // Go to login screen page at index 3
                            pageController.jumpToPage(3);
                          },
                          child: RichText(
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h),
                    ],
                  ),

                  // OTP Screen
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NestForm(
                        formKey: otpFormKey,
                        spacing: 8,
                        isLoading: isLoading,
                        fields: [
                          NestFormField(
                            label:
                                "Enter the 6-digit code sent to your email address",
                            controller: otpController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the code';
                              }
                              // Make sure the characters are digits
                              if (!RegExp(r'^\d+$').hasMatch(value)) {
                                return 'Only digits are allowed';
                              }

                              if (value.length < 6) {
                                return 'Invalid code';
                              }
                              return null;
                            },
                            underlinedBorder: true,
                            hintText: "Enter code",
                            prefixIcon: Icon(Icons.lock),
                          ),
                        ],
                        onSubmit: () {
                          handleOTPSubmit(
                            ref,
                            otpFormKey,
                            otpController,
                            pageController,
                          );
                        },
                        submitText: "Verify OTP",
                      ),
                    ],
                  ),

                  // Create Account Screen
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          child: NestForm(
                            formKey: accountFormKey,
                            spacing: 0,
                            isLoading: isLoading,
                            fields: [
                              // Full name
                              NestFormField(
                                controller: fullNameController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your full name';
                                  }
                                  return null;
                                },
                                prefixIcon: Icon(Icons.person),
                                hintText: "Enter full name",
                                inFormLabelText: "Name",
                              ),

                              // Email
                              NestFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                readOnly: true,
                                prefixIcon: Icon(Icons.email),
                                inFormLabelText: "Email",
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
                                    obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    ref
                                        .read(
                                          passwordVisibilityProvider.notifier,
                                        )
                                        .state = !obscureText;
                                  },
                                ),
                              ),
                              // Drop Down List
                              DropdownButtonFormField<String>(
                                value: ref.watch(accountTypeProvider),
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
                                  ref.read(accountTypeProvider.notifier).state =
                                      value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please select an account type";
                                  }
                                  return null;
                                },

                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.category),
                                  labelText: "Account Type",
                                  labelStyle: theme.textTheme.bodyLarge
                                      ?.copyWith(color: Colors.grey),
                                  hintStyle: theme.textTheme.bodyLarge
                                      ?.copyWith(color: Colors.grey),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 2.h,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.primaryContainer,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.primaryContainer,
                                    ),
                                  ),
                                  focusColor:
                                      theme.colorScheme.primaryContainer,
                                ),
                              ),
                              SizedBox(height: 2.h),
                            ],
                            onSubmit: () {
                              handleRegisterSubmit(
                                ref,
                                accountFormKey,
                                fullNameController,
                                emailController,
                                passwordController,
                                pageController,
                              );
                            },
                            submitText: "Register",
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Center(
                        child: InkWell(
                          onTap: () {
                            // Go to login screen page at index 3
                            pageController.jumpToPage(3);
                          },
                          child: RichText(
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h),
                    ],
                  ),

                  // Login Screen
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NestForm(
                        formKey: loginFormKey,
                        spacing: 0,
                        isLoading: isLoading,
                        fields: [
                          // Email
                          Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: NestFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email address';
                                }
                                if (!value.contains('@')) {
                                  return 'Invalid email address';
                                }
                                return null;
                              },
                              prefixIcon: Icon(Icons.email),
                              inFormLabelText: "Email address",
                              hintText: "Enter email address",
                            ),
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
                                obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                ref
                                    .read(passwordVisibilityProvider.notifier)
                                    .state = !obscureText;
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Navigate to forgot password screen
                                pageController.jumpToPage(0);
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
                        ],
                        onSubmit: () {
                          handleLoginSubmit(
                            ref,
                            loginFormKey,
                            emailController,
                            passwordController,
                            pageController,
                          );
                        },
                        submitText: "Login",
                      ),
                      Spacer(),
                      Center(
                        child: InkWell(
                          onTap: () {
                            pageController.jumpToPage(0);
                          },
                          child: RichText(
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
