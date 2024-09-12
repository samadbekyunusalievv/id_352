import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  Widget build(BuildContext context) {
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
                itemCount: (currentMovieList.length / 2).ceil() + 1,
                itemBuilder: (context, index) {
                  if (index == (currentMovieList.length / 2).ceil()) {
                    return GestureDetector(
                      onTap: () => _navigateToAddMovieScreen(context),
                      child: Row(
                        children: [
                          _buildAddMovieCard(),
                          Spacer(),
                        ],
                      ),
                    );
                  } else {
                    int firstMovieIndex = index * 2;
                    int secondMovieIndex = firstMovieIndex + 1;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMovieCard(
                              context,
                              currentMovieList[firstMovieIndex],
                              firstMovieIndex),
                          SizedBox(width: 1.w),
                          if (secondMovieIndex < currentMovieList.length)
                            _buildMovieCard(
                                context,
                                currentMovieList[secondMovieIndex],
                                secondMovieIndex),
                          if (secondMovieIndex >= currentMovieList.length)
                            Spacer(),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF18181B),
    );
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

  Widget _buildPopupMenu(BuildContext context, MovieBingo movie, int index) {
    return PopupMenuButton<String>(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      padding: EdgeInsets.zero,
      menuPadding: EdgeInsets.zero,
      onSelected: (String result) {
        if (result == 'edit') {
          _navigateToEditMovieScreen(context, movie, index);
        } else if (result == 'delete') {
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
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          child: Stack(
            children: [
              Image.asset(
                'assets/popup_bg.png',
                width: 77.w,
                height: 112.h,
                fit: BoxFit.contain,
              ),
              Positioned(
                top: 20.h,
                left: 26.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, 'edit');
                      },
                      child: Image.asset(
                        'assets/edit_icon.png',
                        width: 24.w,
                        height: 24.h,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, 'delete');
                      },
                      child: Image.asset(
                        'assets/delete_icon.png',
                        width: 24.w,
                        height: 24.h,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      icon: Icon(
        Icons.more_vert,
        color: Colors.white,
        size: 24.r,
      ),
      offset: Offset(25.w, 5.h),
      elevation: 0,
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
            decoration: BoxDecoration(
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
