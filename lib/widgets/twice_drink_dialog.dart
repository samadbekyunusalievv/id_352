import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class TwiceDrinkDialog extends StatelessWidget {
  final VoidCallback onDone;

  const TwiceDrinkDialog({Key? key, required this.onDone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/drink2.png',
              width: 258.48.w,
              height: 309.85.h,
              fit: BoxFit.contain,
            ),
            Gap(40.h),
            GestureDetector(
              onTap: onDone,
              child: Container(
                width: 311.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(24, 24, 27, 1),
                  borderRadius: BorderRadius.circular(10.r),
                  border: const GradientBoxBorder(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFC67A7),
                        Color(0xFF5856D6),
                      ],
                    ),
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'It\'s done!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 26.32 / 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
