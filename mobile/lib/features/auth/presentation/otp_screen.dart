import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/auth/provider/auth_provider.dart';
import 'package:nestcare/providers/auth_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OtpScreen extends HookConsumerWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final otpController = useTextEditingController();
    final state = ref.watch(signupProvider);
    final controller = ref.read(signupProvider.notifier);
    final hasError = useState(false);
    final currentText = useState("");
    final isLoading = ref.watch(loadingProvider);

    useToastEffect(context, error: state.error, success: state.success);

    return NestScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 3.h),
                    Text(
                      "Verify Your Email",
                      style: theme.textTheme.titleLarge?.copyWith(
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "Enter the 6-digit code we sent to your email",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    ImageWidget(
                      imageName: "laundry_otp_icon",
                      width: double.infinity,
                      height: 38.h,
                    ),
                    Text(
                      "Enter the code received",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 2.h),

                    // Pin Code Fields
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor:
                            hasError.value ? Colors.red.shade50 : Colors.white,
                        activeColor:
                            hasError.value
                                ? Colors.red
                                : theme.colorScheme.primary.withValues(
                                  alpha: 0.5,
                                ),
                        inactiveFillColor: Colors.white,
                        inactiveColor: Colors.grey.shade300,
                        selectedColor: theme.colorScheme.primary,
                        selectedFillColor: Colors.white.withValues(alpha: 0.5),
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      errorAnimationController: null,
                      controller: otpController,
                      onCompleted: (value) {
                        // Code completed, submit automatically
                        controller.verifyOtp(int.parse(value));
                      },
                      onChanged: (value) {
                        currentText.value = value;
                        if (hasError.value) {
                          hasError.value = false;
                        }
                      },
                      beforeTextPaste: (text) {
                        if (text == null) return false;
                        return RegExp(r'^\d+$').hasMatch(text);
                      },
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 2.h),

                    NestButton(
                      onPressed: () {
                        if (currentText.value.length != 6) {
                          hasError.value = true;
                          ToastUtil.showErrorToast(
                            context,
                            "Please enter all 6 digits",
                          );
                        } else {
                          controller.verifyOtp(int.parse(currentText.value));
                        }
                      },
                      text: 'Verify Code',
                    ),
                  ],
                ),
              ),
            ),
            // Resend code option
            TextButton(
              onPressed:
                  isLoading
                      ? null
                      : () {
                        if (state.data?.email != null) {
                          controller.enterEmail(state.data!.email);
                          otpController.clear();
                          currentText.value = "";
                        }
                      },
              child: Text(
                "Didn't receive code? Resend",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
