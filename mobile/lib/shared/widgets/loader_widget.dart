import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoaderWidget extends StatelessWidget {
  final Color color;

  const LoaderWidget({super.key, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Center(
        child: SpinKitDualRing(color: color, size: 20, lineWidth: 3),
      ),
    );
  }
}
