import 'package:flutter/material.dart';
import 'package:nestcare/features/general/services/model/service_model.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.service});

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
              child: ImageWidget(
                imageName: service.itemCardImageName!,
                height: 15.3.h,
                width: 15.h,
                fit: BoxFit.fill,
              ),
            ),
            // Info Box
            Expanded(
              child: Container(
                padding: EdgeInsets.all(1.06.h),
                decoration: BoxDecoration(
                  color: service.itemCardBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 1.h),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          service.status!,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      service.serviceTitle!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    // Items: 2 per row
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children:
                          service.items!.map((item) {
                            return SizedBox(
                              width:
                                  (MediaQuery.of(context).size.width -
                                      15.h -
                                      6.w) /
                                  3,
                              child: Text(
                                item.item,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
