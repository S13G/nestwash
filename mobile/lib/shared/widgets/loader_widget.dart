import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 3.h,
      width: 3.h,
      child: CircularProgressIndicator(color: Colors.white),
    );
  }
}
