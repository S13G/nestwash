import 'package:flutter/material.dart';
import 'package:nestcare/core/config/app_constants.dart';

class ImageWidget extends StatelessWidget {
  final String imageName;
  final double width;
  final double height;
  final BoxFit fit;
  final Color? color;

  const ImageWidget({
    super.key,
    required this.imageName,
    this.width = double.infinity,
    this.height = double.infinity,
    this.fit = BoxFit.cover,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final appConstant = AppConstant();

    final imagePath = appConstant.getImagePath(imageName);
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }
}

class IconImageWidget extends StatelessWidget {
  final String iconName;
  final double width;
  final double height;
  final Color? color;

  const IconImageWidget({
    super.key,
    required this.iconName,
    required this.width,
    required this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final appConstant = AppConstant();

    final iconPath = appConstant.getIconPath(iconName);
    return Image.asset(iconPath, width: width, height: height, color: color);
  }
}
