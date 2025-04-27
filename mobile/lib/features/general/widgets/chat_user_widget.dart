import 'package:flutter/material.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChatUserWidget extends StatelessWidget {
  const ChatUserWidget({
    super.key,
    required this.imageName,
    required this.personName,
  });

  final String imageName;
  final String personName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 30, child: ImageWidget(imageName: imageName)),
        SizedBox(width: 4.w),
        Text(personName, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
