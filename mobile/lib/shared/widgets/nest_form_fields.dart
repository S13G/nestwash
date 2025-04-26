import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NestForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> fields;
  final VoidCallback onSubmit;
  final String submitText;
  final int? spacing;
  final bool isLoading;

  const NestForm({
    super.key,
    required this.formKey,
    required this.fields,
    required this.onSubmit,
    this.submitText = "Submit",
    this.spacing = 3,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: formKey,
      child: Column(
        children: [
          ...fields,
          SizedBox(height: spacing?.h),
          SizedBox(
            width: double.infinity,
            height: 7.h,
            child: TextButton(
              onPressed: onSubmit,
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: theme.colorScheme.primary,
              ),
              child:
                  isLoading
                      ? SizedBox(
                        height: 2.h,
                        width: 2.h,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : Text(
                        submitText,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 24,
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
  final String? label;
  final String? hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final InputDecoration? decoration;
  final Function(String)? onChanged;
  final bool belowSpacing;
  final bool underlinedBorder;
  final Widget? prefixIcon;

  const NestFormField({
    super.key,
    this.label,
    required this.controller,
    this.readOnly = false,
    this.validator,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.decoration,
    this.onChanged,
    this.belowSpacing = true,
    this.underlinedBorder = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label == null
            ? SizedBox.shrink()
            : Text(
              label!,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          readOnly: readOnly,
          onChanged: onChanged,
          decoration: decoration ?? _buildInputDecoration(theme),
        ),
        belowSpacing ? SizedBox(height: 2.h) : SizedBox.shrink(),
      ],
    );
  }

  InputDecoration _buildInputDecoration(ThemeData theme) {
    final baseDecoration = InputDecoration(
      errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
      hintText: hintText,
      // <-- use class field, not passed hintText
      prefixIcon: prefixIcon,
      hintStyle: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.primaryContainer,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
    );

    if (underlinedBorder) {
      return baseDecoration.copyWith(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.primaryContainer),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.primaryContainer),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      );
    } else {
      return baseDecoration.copyWith(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primaryContainer),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.primaryContainer),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primaryContainer),
        ),
      );
    }
  }
}
