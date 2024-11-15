import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../data/bingo_data.dart';

class AddNewMovieScreen extends StatefulWidget {
  @override
  _AddNewMovieScreenState createState() => _AddNewMovieScreenState();
}

class _AddNewMovieScreenState extends State<AddNewMovieScreen> {
  final _movieNameController = TextEditingController();
  final List<TextEditingController> _bingoControllers =
      List.generate(24, (index) => TextEditingController());
  final FocusNode _movieNameFocusNode = FocusNode();
  final List<FocusNode> _bingoFocusNodes =
      List.generate(24, (index) => FocusNode());
  bool _isAnyFieldFocused = false;

  @override
  void initState() {
    super.initState();
    _movieNameFocusNode.addListener(_onFocusChange);
    for (var focusNode in _bingoFocusNodes) {
      focusNode.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    setState(() {
      _isAnyFieldFocused = _movieNameFocusNode.hasFocus ||
          _bingoFocusNodes.any((node) => node.hasFocus);
    });
  }

  @override
  void dispose() {
    _movieNameController.dispose();
    _bingoControllers.forEach((controller) => controller.dispose());
    _movieNameFocusNode.dispose();
    _bingoFocusNodes.forEach((node) => node.dispose());
    super.dispose();
  }

  bool _isFormValid() {
    return _movieNameController.text.isNotEmpty &&
        _bingoControllers.any((controller) => controller.text.isNotEmpty);
  }

  void _saveNewMovie() {
    final movieName = _movieNameController.text;
    final bingoOptions = _bingoControllers
        .where((controller) => controller.text.isNotEmpty)
        .map((controller) => controller.text)
        .toList();

    if (movieName.isNotEmpty && bingoOptions.isNotEmpty) {
      final newMovie = MovieBingo(
        movieName: movieName,
        bingoOptions: bingoOptions,
        bannerImagePath: 'assets/added_movie_banner.png',
        isAddedMovie: true,
      );
      Navigator.pop(context, newMovie);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Add New Movie',
          style: TextStyle(
            fontFamily: 'Axiforma',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.408,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.r, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg.png',
              fit: BoxFit.fill,
            ),
          ),
          Column(
            children: [
              SizedBox(height: 90.h),
              Container(
                width: 335.w,
                height: 152.h,
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  image: const DecorationImage(
                    image: AssetImage('assets/movie_banner.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15.w),
                        child: Text(
                          'Name of the movie',
                          style: TextStyle(
                            fontFamily: 'Axiforma',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _buildGradientBorderTextField(
                        controller: _movieNameController,
                        hintText: 'Name of the movie',
                        focusNode: _movieNameFocusNode,
                        onChanged: (value) => setState(() {}),
                        maxLength: 55,
                      ),
                      SizedBox(height: 26.h),
                      Padding(
                        padding: EdgeInsets.only(left: 15.w),
                        child: Text(
                          'The terms of bingo on this movie (24)',
                          style: TextStyle(
                            fontFamily: 'Axiforma',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Column(
                        children: List.generate(24, (index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: _buildGradientBorderTextField(
                              controller: _bingoControllers[index],
                              hintText: 'Term',
                              focusNode: _bingoFocusNodes[index],
                              onChanged: (value) => setState(() {}),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              if (!_isAnyFieldFocused) SizedBox(height: 16.h),
              if (!_isAnyFieldFocused)
                Center(
                  child: GestureDetector(
                    onTap: _isFormValid() ? _saveNewMovie : null,
                    child: Container(
                      width: 295.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: const GradientBoxBorder(
                          gradient: LinearGradient(
                            colors: [Color(0xFF19A1BE), Color(0xFF7D4192)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          width: 2.0,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: GradientText(
                        'Save',
                        style: TextStyle(
                          fontFamily: 'Axiforma',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        colors: _isFormValid()
                            ? [const Color(0xFF19A1BE), const Color(0xFF7D4192)]
                            : [
                                const Color(0xFF19A1BE).withOpacity(0.5),
                                const Color(0xFF7D4192).withOpacity(0.5)
                              ],
                      ),
                    ),
                  ),
                ),
              if (!_isAnyFieldFocused) SizedBox(height: 20.h),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGradientBorderTextField({
    required TextEditingController controller,
    required String hintText,
    required FocusNode focusNode,
    required ValueChanged<String> onChanged,
    int? maxLength,
  }) {
    return Container(
      width: 335.w,
      height: 54.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: const GradientBoxBorder(
          gradient: LinearGradient(
            colors: [Color(0xFF19A1BE), Color(0xFF7D4192)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          width: 2.0,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.transparent,
        ),
        child: Center(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            style: TextStyle(
              fontFamily: 'Axiforma',
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            inputFormatters: maxLength != null
                ? [
                    LengthLimitingTextInputFormatter(maxLength),
                  ]
                : [],
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: 'Axiforma',
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.5),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              isCollapsed: true,
              counterText: '',
            ),
          ),
        ),
      ),
    );
  }
}
