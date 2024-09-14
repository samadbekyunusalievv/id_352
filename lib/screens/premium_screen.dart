import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:id_352/data/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});
  Future<void> setPremiumStatus(bool isPremium) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('premiumStatus', isPremium);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: MyColors.appBarColor,
        title: Text(
          'Premium',
          style: TextStyle(
            fontFamily: 'Axiforma',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            height: 26 / 16,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 24.r,
            height: 24.r,
            alignment: Alignment.center,
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
        ),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: Image.asset(
              width: MediaQuery.sizeOf(context).width,
              height: 477.h,
              'assets/banner_movies.png',
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: 316.h,
            child: SafeArea(
              top: true,
              child: Text(
                'Bingogo: \nline up',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  color: Colors.white,
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w600,
                  height: 52 / 40,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: SafeArea(
                top: true, bottom: false, child: _widgetPremium(context)),
          ),
        ],
      ),
    );
  }

  Widget _widgetPremium(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 277.h,
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        border: const GradientBoxBorder(
          gradient: LinearGradient(colors: MyColors.gradientColors),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        border: const GradientBoxBorder(
          gradient: LinearGradient(colors: MyColors.gradientColors),
        ),
        gradient: const LinearGradient(
          colors: MyColors.gradientColors,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 30.h,
            child: Column(
              children: [
                Text(
                  'NO ADS',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    color: Colors.white,
                    fontSize: 16.sp,
                    height: 22 / 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Gap(35.h),
                GestureDetector(
                  onTap: () async {
                    await setPremiumStatus(true);
                    Navigator.pop(context, true);
                  },
                  child: Container(
                    width: 311.w,
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(24, 24, 27, 1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    alignment: Alignment.center,
                    child: GradientText(
                      'Get Purchase For \$0.49',
                      colors: MyColors.gradientColors,
                      style: TextStyle(
                        fontFamily: 'Axiforma',
                        fontSize: 16.sp,
                        height: 25 / 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Gap(35.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Terms of Use',
                        style: TextStyle(
                          fontFamily: 'Axiforma',
                          color: Colors.white,
                          fontSize: 14.sp,
                          height: 22 / 14,
                        ),
                      ),
                    ),
                    Gap(30.w),
                    TextButton(
                      onPressed: () async {
                        await setPremiumStatus(true);
                        Navigator.pop(context, true);
                      },
                      child: Text(
                        'Restore',
                        style: TextStyle(
                          fontFamily: 'Axiforma',
                          color: Colors.white,
                          fontSize: 14.sp,
                          height: 22 / 14,
                        ),
                      ),
                    ),
                    Gap(30.w),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontFamily: 'Axiforma',
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
        ],
      ),
    );
  }
}
