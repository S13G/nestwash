import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/providers/chat_provider.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:nestcare/providers/services_provider.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChatUserWidget extends StatelessWidget {
  const ChatUserWidget({
    super.key,
    required this.imageName,
    required this.personName,
    required this.ref,
  });

  final String imageName;
  final String personName;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ref.read(chattingPartnerNameProvider.notifier).state = personName;
        ref.read(routerProvider).pushNamed("chat");
      },
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              ref.read(selectedServiceProviderNameProvider.notifier).state =
                  personName;
              ref.read(routerProvider).pushNamed("service_provider_profile");
            },
            child: CircleAvatar(
              radius: 30,
              child: ImageWidget(imageName: imageName),
            ),
          ),
          SizedBox(width: 4.w),
          Text(personName, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
