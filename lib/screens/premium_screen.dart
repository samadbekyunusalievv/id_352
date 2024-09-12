import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../data/colors.dart';

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
            top: 316.h,
            child: SafeArea(
              top: true,
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
          ),
          Positioned(
            bottom: 0,
            child: SafeArea(
              top: true,
              bottom: false,
              child: _widgetPremium(context),
            ),
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
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 14.w,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(24, 24, 27, 1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    alignment: Alignment.center,
                    child: GradientText(
                      'Get Purchase For \$0.49',
                      colors: MyColors.gradientColors,
                      style: TextStyle(
                        fontSize: 16.sp,
                        height: 25 / 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Gap(35.h),
                GestureDetector(
                  onTap: () async {
                    await setPremiumStatus(true);
                    Navigator.pop(context, true);
                  },
                  child: TextButton(
                    onPressed: () async {
                      await setPremiumStatus(true);
                      Navigator.pop(context, true);
                    },
                    child: Text(
                      'Restore',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        height: 22 / 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}