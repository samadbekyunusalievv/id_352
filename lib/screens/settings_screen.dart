import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../data/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotification = false;
  bool isPremium = false;

  @override
  void initState() {
    super.initState();
    _loadPremiumStatus();
  }

  Future<void> _loadPremiumStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isPremium = prefs.getBool('premiumStatus') ?? false;
    });
  }

  Future<void> _setPremiumStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('premiumStatus', status);
    setState(() {
      isPremium = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Settings',
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
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 32.w,
                  vertical: 30.h,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isNotification = !isNotification;
                        });
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
                          border: const GradientBoxBorder(
                            gradient: LinearGradient(
                              colors: MyColors.gradientColors,
                            ),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Notifications',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  height: 25 / 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const CustomSwitch(),
                          ],
                        ),
                      ),
                    ),
                    Gap(30.h),
                    Row(
                      children: [
                        _button(
                          text: 'Privacy Policy',
                          onPressed: () async {
                            await _setPremiumStatus(false);
                          },
                        ),
                        Gap(11.w),
                        _button(
                          text: 'Terms of Use',
                          onPressed: () {},
                        ),
                      ],
                    ),
                    if (!isPremium) ...[
                      Gap(30.h),
                      Text(
                        'NO ADS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          height: 22 / 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Gap(16.h),
                      Text(
                        'FOR \$0.49',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          height: 33 / 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Gap(16.h),
                      GestureDetector(
                        onTap: () async {
                          final result =
                              await Navigator.pushNamed(context, '/premium');
                          if (result == true) {
                            _loadPremiumStatus();
                          }
                        },
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
                            'Premium',
                            style: TextStyle(
                              fontSize: 16.sp,
                              height: 26 / 16,
                              fontWeight: FontWeight.w700,
                            ),
                            colors: MyColors.gradientColors,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _button({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 12.h,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.white),
          ),
          alignment: Alignment.center,
          child: GradientText(
            text,
            colors: MyColors.gradientColors,
            style: TextStyle(
              fontSize: 16.sp,
              height: 25 / 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({super.key});

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool isNotification = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isNotification = !isNotification;
        });
      },
      child: SizedBox(
        width: 40.r,
        height: 24.r,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Positioned(
              child: Container(
                width: 40.r,
                height: 12.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: MyColors.secondColor, width: 1),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: isNotification ? 16.r : 0,
              child: Container(
                width: 24.r,
                height: 24.r,
                decoration: BoxDecoration(
                  color: isNotification ? MyColors.secondColor : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: MyColors.secondColor, width: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
