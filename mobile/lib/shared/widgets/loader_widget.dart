import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({
    super.key,
    this.height = 3,
    this.width = 3,
    this.color = Colors.white,
  });

  final int height;
  final int width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      width: width.h,
      child: CircularProgressIndicator(color: color),
    );
  }
}
