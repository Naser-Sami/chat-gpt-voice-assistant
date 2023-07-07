import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'palette.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descriptionText;
  const FeatureBox(
      {super.key,
      required this.color,
      required this.headerText,
      required this.descriptionText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 35.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h)
            .copyWith(left: 15.w, right: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headerText,
              style: TextStyle(
                color: Palette.blackColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cera Pro',
                height: 1.0.h,
              ),
            ),
            Text(
              descriptionText,
              style: TextStyle(
                color: Palette.blackColor,
                fontSize: 12.sp,
                fontFamily: 'Cera Pro',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
