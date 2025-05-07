import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/providers/auth_provider.dart';
import 'package:nestcare/shared/widgets/loader_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NestForm extends HookConsumerWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> fields;
  final VoidCallback onSubmit;
  final String submitText;
  final int? spacing;

  const NestForm({
    super.key,
    required this.formKey,
    required this.fields,
    required this.onSubmit,
    this.submitText = "Submit",
    this.spacing = 3,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isLoading = ref.watch(loadingProvider);

    return Form(
      key: formKey,
      child: Column(
        children: [
          ...fields,
          SizedBox(height: spacing?.h),
          SizedBox(
            width: double.infinity,
            height: 7.h,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: theme.colorScheme.primary,
                disabledBackgroundColor: theme.colorScheme.secondaryContainer,
              ),
              child:
                  isLoading
                      ? LoaderWidget()
                      : Text(
                        submitText,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

class NestFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? inFormLabelText;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool enabled;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final bool belowSpacing;

  const NestFormField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.inFormLabelText,
    this.obscureText,
    this.validator,
    this.keyboardType,
    this.enabled = true,
    this.maxLines,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.belowSpacing = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText ?? false,
          validator: validator,
          keyboardType: keyboardType,
          enabled: enabled,
          maxLines: maxLines ?? 1,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: inFormLabelText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
        belowSpacing ? SizedBox(height: 2.h) : const SizedBox.shrink(),
      ],
    );
  }
}
