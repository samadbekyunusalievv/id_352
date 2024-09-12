import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:id_352/data/colors.dart';

class RemoveMovieDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String movieName;

  const RemoveMovieDialog({
    Key? key,
    required this.onConfirm,
    required this.onCancel,
    required this.movieName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        padding: EdgeInsets.all(20.w),
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
            Text(
              'Are you sure you want to remove “$movieName”?',
              style: TextStyle(
                fontFamily: 'Axiforma',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                height: 22.4 / 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onConfirm,
                  child: Container(
                    width: 120.w,
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
                Gap(20.w),
                GestureDetector(
                  onTap: onCancel,
                  child: Container(
                    width: 120.w,
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
          ],
        ),
      ),
    );
  }
}
