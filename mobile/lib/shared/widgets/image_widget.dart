import 'package:flutter/material.dart';
import 'package:nestcare/core/config/app_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ImageWidget extends StatelessWidget {
  final String imageName;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;

  ImageWidget({
    super.key,
    required this.imageName,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final appConstant = AppConstant();

    final imagePath = appConstant.getImagePath(imageName);
    final double displayWidth = width ?? 10.w;
    final double displayHeight = height ?? 10.h;

    return Image.asset(
      imagePath,
      width: displayWidth,
      height: displayHeight,
      fit: fit,
      color: color,
    );
  }
}

class IconImageWidget extends StatelessWidget {
  final String iconName;
  final double? width;
  final double? height;
  final Color? color;

  const IconImageWidget({
    super.key,
    required this.iconName,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appConstant = AppConstant();

    final iconPath = appConstant.getIconPath(iconName);
    return Image.asset(
      iconPath,
      width: width ?? 50.w,
      height: height ?? 50.w,
      color: color ?? theme.colorScheme.primary,
    );
  }
}
