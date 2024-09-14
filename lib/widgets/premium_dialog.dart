import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:id_352/data/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

Color lighten(Color color, [double amount = 0.3]) {
  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
  return hslLight.toColor();
}

class PremiumDialog extends StatelessWidget {
  final VoidCallback onDone;

  const PremiumDialog({Key? key, required this.onDone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double dialogWidth = MediaQuery.of(context).size.width - 40;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: dialogWidth,
        height: 242.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF19A1BE),
              Color(0xFF7D4192),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: const GradientBoxBorder(
            gradient: LinearGradient(
              colors: MyColors.gradientColors,
            ),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: -24.w,
              child: Transform.rotate(
                angle: 15 * pi / 180,
                child: Image.asset(
                  'assets/premium_bottle.png',
                  width: 100.w,
                  height: 130.h,
                ),
              ),
            ),
            Positioned(
              top: 146.h,
              right: -27.w,
              child: Transform.rotate(
                angle: -30 * pi / 180,
                child: Image.asset(
                  'assets/premium_cocktail.png',
                  width: 63.w,
                  height: 97.h,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'NO ADS',
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
                Text(
                  'FOR \$0.49',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    height: 33.6 / 24,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gap(20.h),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/premium');
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF18181B),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      alignment: Alignment.center,
                      child: GradientText(
                        'Premium',
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
                ),
                Gap(20.h),
                GestureDetector(
                  onTap: onDone,
                  child: GradientText(
                    'Restore',
                    gradientDirection: GradientDirection.ltr,
                    style: TextStyle(
                      fontFamily: 'Axiforma',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      height: 25.66 / 16,
                    ),
                    colors: MyColors.gradientColors
                        .map((color) => lighten(color))
                        .toList(),
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
