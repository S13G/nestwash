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
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? inFormLabelText;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool enabled;
  final InputDecoration? decoration;
  final bool underlinedBorder;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final bool belowSpacing;
  final EdgeInsetsGeometry? contentPadding;

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
    this.decoration,
    this.underlinedBorder = false,
    this.maxLines,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.belowSpacing = true,
    this.contentPadding,
  });

  InputBorder _buildBorder(BuildContext context) {
    final theme = Theme.of(context);
    if (underlinedBorder) {
      return UnderlineInputBorder(
        borderSide: BorderSide(color: theme.colorScheme.primaryContainer),
      );
    } else {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.primaryContainer),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    EdgeInsetsGeometry finalContentPadding;

    if (contentPadding != null) {
      finalContentPadding = contentPadding!;
    } else if (underlinedBorder) {
      finalContentPadding = EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 2.h,
      );
    } else {
      finalContentPadding = EdgeInsets.symmetric(vertical: 2.h);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
          decoration:
              decoration ??
              InputDecoration(
                errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
                hintText: hintText,
                hintStyle: TextStyle(color: theme.colorScheme.primaryContainer),
                labelText: inFormLabelText,
                labelStyle: TextStyle(
                  color: theme.colorScheme.primaryContainer,
                ),
                contentPadding: finalContentPadding,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                enabledBorder: _buildBorder(context),
                focusedBorder: _buildBorder(context),
                border: _buildBorder(context),
              ),
        ),
        belowSpacing ? SizedBox(height: 2.h) : const SizedBox.shrink(),
      ],
    );
  }
}
