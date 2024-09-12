import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:id_352/data/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ExitGameDialog extends StatelessWidget {
  final VoidCallback onPlayAgain;
  final VoidCallback onFinish;

  const ExitGameDialog({
    Key? key,
    required this.onPlayAgain,
    required this.onFinish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 335.w,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(50, 45, 96, 1),
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
            Text(
              'The game is over!',
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
            Image.asset(
              'assets/game_over.png',
              width: 67.39.w,
              height: 101.23.h,
              fit: BoxFit.contain,
            ),
            Gap(20.h),
            GestureDetector(
              onTap: onPlayAgain,
              child: Container(
                width: 311.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(24, 24, 27, 1),
                  borderRadius: BorderRadius.circular(10.r),
                  border: const GradientBoxBorder(
                    gradient: LinearGradient(
                      colors: MyColors.gradientColors,
                    ),
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: GradientText(
                  'Play Again',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    height: 26.32 / 16,
                  ),
                  colors: MyColors.gradientColors,
                ),
              ),
            ),
            Gap(20.h),
            GestureDetector(
              onTap: onFinish,
              child: Container(
                width: 311.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: GradientText(
                  'Finish',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    height: 25.66 / 16,
                  ),
                  colors: MyColors.gradientColors,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
