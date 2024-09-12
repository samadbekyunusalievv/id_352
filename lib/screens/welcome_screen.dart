import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:id_352/data/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: Container(
              height: 477.h,
              alignment: Alignment.center,
              child: Image.asset(
                'assets/banner_movies.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 477.h,
            child: Text(
              'Bingogo: \nline up',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.sp,
                fontWeight: FontWeight.w600,
                height: 52 / 40,
              ),
            ),
          ),
          Positioned(
            top: 440.h,
            right: -44.w,
            child: Transform.rotate(
              angle: -15 * pi / 180,
              child: Image.asset(
                'assets/wine_bottle_welcome.png',
                width: 109.w,
                height: 211.h,
              ),
            ),
          ),
          Positioned(
            bottom: 24.h,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => _showNotificationDialog(context),
                  child: Container(
                    width: 311.w,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(24, 24, 27, 1),
                      borderRadius: BorderRadius.circular(10.r),
                      border: const GradientBoxBorder(
                        gradient: LinearGradient(
                          colors: MyColors.gradientColors,
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: GradientText(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16.sp,
                        height: 26 / 16,
                        fontWeight: FontWeight.w700,
                      ),
                      colors: MyColors.gradientColors,
                    ),
                  ),
                ),
                Gap(30.h),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Terms of Use',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          height: 22 / 14,
                        ),
                      ),
                    ),
                    Gap(40.w),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Privacy Police',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          height: 22 / 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showNotificationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            backgroundColor: const Color.fromRGBO(48, 48, 48, 1),
            child: Container(
              padding: EdgeInsets.zero,
              width: 270.w,
              height: 166.h,
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 16.h),
                      Text(
                        "“Bingogo: line up” Would Like \n to Send You Notifications",
                        style: TextStyle(
                          fontSize: 17.r,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: -0.41,
                          height: 22.h / 17.r,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Notifications can include alerts,\n sounds, and icons. You can customize\n them in Settings.",
                        style: TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontSize: 13.r,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.08,
                          color: Colors.white,
                          height: 16.h / 13.r,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.r),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 20.w),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/main');
                              },
                              child: Text(
                                "Don't allow",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 17.r,
                                  height: 22.h / 17.r,
                                ),
                              ),
                            ),
                            SizedBox(width: 54.w),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/main');
                              },
                              child: Text(
                                "OK",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 17.r,
                                  height: 22.h / 17.r,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 122.h,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 1.h,
                      color: const Color.fromRGBO(255, 255, 255, 0.2),
                    ),
                  ),
                  Positioned(
                    top: 122.h,
                    left: 135.w,
                    bottom: 0,
                    child: Container(
                      width: 1.w,
                      color: const Color.fromRGBO(255, 255, 255, 0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
