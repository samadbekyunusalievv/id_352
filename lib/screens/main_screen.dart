import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:id_352/data/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/bingo_data.dart';
import '../widgets/remove_movie_dialog.dart';
import 'add_new_movie_screen.dart';
import 'bingo_game_screen.dart';
import 'edit_new_movie_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<MovieBingo> currentMovieList = [];

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? movieJsonList = prefs.getStringList('movieList');

    if (movieJsonList != null) {
      setState(() {
        currentMovieList = movieJsonList
            .map((movieJson) => MovieBingo.fromJson(movieJson))
            .toList();
      });
    } else {
      setState(() {
        currentMovieList = movieBingoList;
      });
    }
  }

  Future<void> _saveMovies() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> movieJsonList =
        currentMovieList.map((movie) => movie.toJson()).toList();
    prefs.setStringList('movieList', movieJsonList);
  }

  void _addNewMovie(MovieBingo newMovie) {
    setState(() {
      currentMovieList.add(newMovie);
      _saveMovies();
    });
  }

  void _editMovie(MovieBingo editedMovie, int index) {
    setState(() {
      currentMovieList[index] = editedMovie;
      _saveMovies();
    });
  }

  void _deleteMovie(int index) {
    setState(() {
      currentMovieList.removeAt(index);
      _saveMovies();
    });
  }

  Future<void> _navigateToAddMovieScreen(BuildContext context) async {
    final MovieBingo? newMovie = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNewMovieScreen()),
    );
    if (newMovie != null) {
      _addNewMovie(newMovie);
    }
  }

  Future<void> _navigateToEditMovieScreen(
      BuildContext context, MovieBingo movie, int index) async {
    final MovieBingo? editedMovie = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditNewMovieScreen(movie: movie)),
    );
    if (editedMovie != null) {
      _editMovie(editedMovie, index);
    }
  }

  void _showCustomPopupMenu(
      BuildContext context, MovieBingo movie, int index, GlobalKey key) {
    final RenderBox button =
        key.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset buttonPosition =
        button.localToGlobal(Offset.zero, ancestor: overlay);

    OverlayEntry? entry;

    entry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          entry?.remove();
        },
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              left: buttonPosition.dx - 65,
              top: buttonPosition.dy + 5.h,
              child: Container(
                width: 70.w,
                decoration: BoxDecoration(
                  color: MyColors.backgroundColor,
                  borderRadius: BorderRadius.circular(15.r),
                  border: const GradientBoxBorder(
                    gradient: LinearGradient(colors: MyColors.gradientColors),
                  ),
                ),
                child: Column(
                  children: [
                    Gap(7.h),
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Image.asset(
                        'assets/edit_icon.png',
                        width: 24.r,
                        height: 24.r,
                      ),
                      onPressed: () {
                        entry?.remove();
                        _navigateToEditMovieScreen(context, movie, index);
                      },
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Image.asset(
                        'assets/delete_icon.png',
                        width: 24.r,
                        height: 24.r,
                      ),
                      onPressed: () {
                        entry?.remove();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return RemoveMovieDialog(
                              movieName: movie.movieName,
                              onConfirm: () {
                                _deleteMovie(index);
                                Navigator.pop(context);
                              },
                              onCancel: () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                    ),
                    Gap(7.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(entry);
  }

  Widget _buildPopupMenu(BuildContext context, MovieBingo movie, int index) {
    final GlobalKey key = GlobalKey();

    return IconButton(
      key: key,
      icon: Icon(
        Icons.more_vert,
        color: Colors.white,
        size: 24.r,
      ),
      onPressed: () {
        _showCustomPopupMenu(context, movie, index, key);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> itemsToDisplay = List.from(currentMovieList);
    itemsToDisplay.add('AddMovieCard');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Bingo Movies',
          style: TextStyle(
            fontFamily: 'Axiforma',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.408,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 16.w),
            icon: Icon(
              Icons.settings_outlined,
              size: 24.r,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  right: 14.w, left: 14.w, top: 13.h, bottom: 5.h),
              child: ListView.builder(
                itemCount: (itemsToDisplay.length / 2).ceil(),
                itemBuilder: (context, index) {
                  int firstItemIndex = index * 2;
                  int secondItemIndex = firstItemIndex + 1;

                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCard(context, itemsToDisplay[firstItemIndex]),
                        SizedBox(width: 1.w),
                        if (secondItemIndex < itemsToDisplay.length)
                          _buildCard(context, itemsToDisplay[secondItemIndex]),
                        if (secondItemIndex >= itemsToDisplay.length)
                          const Spacer(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF18181B),
    );
  }

  Widget _buildCard(BuildContext context, dynamic item) {
    if (item is MovieBingo) {
      int index = currentMovieList.indexOf(item);
      return _buildMovieCard(context, item, index);
    } else if (item == 'AddMovieCard') {
      return GestureDetector(
        onTap: () => _navigateToAddMovieScreen(context),
        child: _buildAddMovieCard(),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildMovieCard(BuildContext context, MovieBingo movie, int index) {
    String imagePath = movie.isAddedMovie
        ? 'assets/added_movie.png'
        : 'assets/${movie.movieName.toLowerCase()}_card.png';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BingoGameScreen(),
            settings: RouteSettings(arguments: movie),
          ),
        );
      },
      child: Container(
        width: 172.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 172.w,
                  height: 101.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                if (movie.isAddedMovie)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: _buildPopupMenu(context, movie, index),
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 7.w),
                Expanded(
                  child: Text(
                    movie.movieName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Axiforma',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.63,
                      color: Colors.white,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 24.r,
                ),
                SizedBox(width: 7.w),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddMovieCard() {
    return Container(
      width: 172.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 172.w,
            height: 101.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/adding_movie.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 7.w),
              Expanded(
                child: Text(
                  'Add your movie',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.408,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.add,
                color: Colors.white,
                size: 24.r,
              ),
              SizedBox(width: 7.w),
            ],
          ),
        ],
      ),
    );
  }
}
