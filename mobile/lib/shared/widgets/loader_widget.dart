import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoaderWidget extends StatelessWidget {
  final double height;
  final double width;
  final Color color;

  const LoaderWidget({
    super.key,
    this.height = 2.5,
    this.width = 2.5,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      width: width.h,
      child: CircularProgressIndicator(color: color),
    );
  }
}
