import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ServiceCard extends ConsumerWidget {
  const ServiceCard({super.key});

  // final ServiceModel service;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    throw UnimplementedError();
  }

  // @override
  // Widget build(BuildContext context, WidgetRef ref) {
  //   final theme = Theme.of(context);
  //   final borderRadius = BorderRadius.circular(30);
  //   final accountType = ref.read(userProvider)?.accountType;
  //
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 1.h),
  //     child: GestureDetector(
  //       onTap: () {
  //         if (accountType == 'service_provider') {
  //           context.pushNamed('service_provider_order_details');
  //         } else {
  //           context.pushNamed('order_details');
  //         }
  //       },
  //       child: Container(
  //         decoration: BoxDecoration(
  //           borderRadius: borderRadius,
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withValues(alpha: 0.05),
  //               blurRadius: 4,
  //               offset: const Offset(0, 2),
  //             ),
  //           ],
  //         ),
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Container(
  //               width: 25.w,
  //               height: 13.9.h,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(30),
  //                   bottomLeft: Radius.circular(30),
  //                 ),
  //                 color: service.itemCardBackgroundColor?.withValues(
  //                   alpha: 0.15,
  //                 ),
  //               ),
  //               child: Padding(
  //                 padding: EdgeInsets.all(2.h),
  //                 child: IconImageWidget(iconName: service.itemCardImageName!),
  //               ),
  //             ),
  //
  //             // Info Box - Expanded to take remaining width
  //             Expanded(
  //               child: Container(
  //                 padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
  //                 decoration: BoxDecoration(
  //                   color: service.itemCardBackgroundColor,
  //                   borderRadius: BorderRadius.only(
  //                     topRight: Radius.circular(30),
  //                     bottomRight: Radius.circular(30),
  //                   ),
  //                 ),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     // Status text
  //                     Align(
  //                       alignment: Alignment.topRight,
  //                       child: Text(
  //                         service.status!,
  //                         style: theme.textTheme.bodyMedium?.copyWith(
  //                           color: Colors.white,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(height: 8),
  //
  //                     // Title
  //                     Text(
  //                       service.serviceTitle!,
  //                       style: theme.textTheme.bodyLarge?.copyWith(
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.white,
  //                       ),
  //                       maxLines: 2,
  //                       overflow: TextOverflow.ellipsis,
  //                     ),
  //                     SizedBox(height: 8),
  //
  //                     // Items in a grid - fixed number per row
  //                     Wrap(
  //                       spacing: 8,
  //                       runSpacing: 3,
  //                       children:
  //                           service.items!.map((item) {
  //                             // Calculate a fixed width for 2 items per row with spacing
  //                             return SizedBox(
  //                               width:
  //                                   (MediaQuery.of(context).size.width -
  //                                       15.h -
  //                                       36) /
  //                                   3.35,
  //                               child: Text(
  //                                 item.item,
  //                                 overflow: TextOverflow.ellipsis,
  //                                 maxLines: 1,
  //                                 style: theme.textTheme.bodyMedium?.copyWith(
  //                                   color: Colors.white,
  //                                 ),
  //                               ),
  //                             );
  //                           }).toList(),
  //                     ),
  //                     // Add some bottom padding if needed
  //                     SizedBox(height: 4),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
