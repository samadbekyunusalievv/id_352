import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:id_352/data/colors.dart';

class LeaveGameDialog extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;
  final String movieName;

  const LeaveGameDialog({
    Key? key,
    required this.onYes,
    required this.onNo,
    required this.movieName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF322D60),
          borderRadius: BorderRadius.circular(20.r),
          border: const GradientBoxBorder(
            gradient: LinearGradient(
              colors: MyColors.gradientColors,
            ),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(20.h),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              child: Text(
                'Are you sure you want to leave from “$movieName”?',
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  height: 22.4 / 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Gap(20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onYes,
                  child: Container(
                    width: 130.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Yes',
                      style: TextStyle(
                        fontFamily: 'Axiforma',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                        height: 26.32 / 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Gap(10.w),
                GestureDetector(
                  onTap: onNo,
                  child: Container(
                    width: 130.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'No',
                      style: TextStyle(
                        fontFamily: 'Axiforma',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 26.32 / 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            Gap(20.h),
          ],
        ),
      ),
    );
  }
}
