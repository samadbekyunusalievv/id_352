import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/bingo_data.dart';
import '../widgets/exit_game_dialog.dart';
import '../widgets/leave_game_dialog.dart';
import '../widgets/once_drink_dialog.dart';
import '../widgets/premium_dialog.dart';
import '../widgets/twice_drink_dialog.dart';

class BingoGameScreen extends StatefulWidget {
  @override
  _BingoGameScreenState createState() => _BingoGameScreenState();
}

class _BingoGameScreenState extends State<BingoGameScreen> {
  List<bool> _markedGrid = [];
  late MovieBingo movie;
  bool _isGameOver = false;
  Set<int> _completedRows = {};
  Set<int> _completedColumns = {};
  String? _lineDirection;
  double cellSize = 0;
  bool lineCompleted = false;
  int drinkDialogCount = 0;
  bool gameOverDialogShown = false;
  bool isPremiumUser = false;

  static const int maxRows = 6;
  static const int maxColumns = 4;
  static const int maxGridSize = maxRows * maxColumns;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    movie = ModalRoute.of(context)!.settings.arguments as MovieBingo;
    _initializeGridState();
    _loadPremiumStatus();
  }

  Future<void> _loadPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isPremiumUser = prefs.getBool('premiumStatus') ?? false;
    });
  }

  Future<void> _initializeGridState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedGrid = prefs.getStringList('${movie.movieName}_grid');

    setState(() {
      int gridLength = min(movie.bingoOptions.length, maxGridSize);
      _markedGrid = savedGrid?.map((e) => e == 'true').toList() ??
          List<bool>.filled(gridLength, false);
    });

    final savedRows = prefs.getStringList('${movie.movieName}_rows') ?? [];
    _completedRows = savedRows.map((e) => int.parse(e)).toSet();

    final savedColumns =
        prefs.getStringList('${movie.movieName}_columns') ?? [];
    _completedColumns = savedColumns.map((e) => int.parse(e)).toSet();
  }

  Future<void> _saveGridState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedGrid = _markedGrid.map((marked) => marked.toString()).toList();
    await prefs.setStringList('${movie.movieName}_grid', savedGrid);

    final savedRows = _completedRows.map((row) => row.toString()).toList();
    await prefs.setStringList('${movie.movieName}_rows', savedRows);

    final savedColumns =
        _completedColumns.map((col) => col.toString()).toList();
    await prefs.setStringList('${movie.movieName}_columns', savedColumns);

    await prefs.remove('${movie.movieName}_direction');
  }

  void _toggleMark(int index) {
    if (_isGameOver) return;

    bool wasMarked = _markedGrid[index];
    bool previousLineCompleted = lineCompleted;

    setState(() {
      _markedGrid[index] = !_markedGrid[index];
      lineCompleted = false;
      _checkCompletedLines();
      _checkGameOver();
      _saveGridState();
    });

    if (!_markedGrid[index] && wasMarked) return;

    if (lineCompleted) {
      if (!previousLineCompleted) {
        _showTwiceDrinkDialog();
      }
    } else {
      _showOnceDrinkDialog();
    }
  }

  void _showOnceDrinkDialog() {
    drinkDialogCount++;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return OnceDrinkDialog(
          onDone: () {
            Navigator.pop(context);
            _checkForPremiumOrGameOverDialog();
          },
        );
      },
    );
  }

  void _showTwiceDrinkDialog() {
    drinkDialogCount++;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return TwiceDrinkDialog(
          onDone: () {
            Navigator.pop(context);
            _checkForPremiumOrGameOverDialog();
          },
        );
      },
    );
  }

  void _checkForPremiumOrGameOverDialog() {
    if (drinkDialogCount >= 3) {
      drinkDialogCount = 0;
      if (!isPremiumUser) {
        _showPremiumDialog();
      }
    } else if (_isGameOver && !gameOverDialogShown) {
      _showGameOverDialog();
    }
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return PremiumDialog(
          onDone: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _checkCompletedLines() {
    int rowCount = (_markedGrid.length / maxColumns).ceil();
    bool foundCompletion = false;

    if (_lineDirection == null || _lineDirection == "horizontal") {
      for (int row = 0; row < rowCount && !foundCompletion; row++) {
        bool isRowComplete = true;
        for (int col = 0; col < maxColumns; col++) {
          int index = row * maxColumns + col;
          if (index >= _markedGrid.length || !_markedGrid[index]) {
            isRowComplete = false;
            break;
          }
        }

        if (isRowComplete && !_completedRows.contains(row)) {
          _completedRows.add(row);
          lineCompleted = true;
          foundCompletion = true;
          if (_lineDirection == null) {
            _lineDirection = "horizontal";
          }
        }
      }
    }

    if ((_lineDirection == null || _lineDirection == "vertical") &&
        !foundCompletion) {
      for (int col = 0; col < maxColumns && !foundCompletion; col++) {
        bool isColumnComplete = true;
        for (int row = 0; row < rowCount; row++) {
          int index = col + row * maxColumns;
          if (index >= _markedGrid.length || !_markedGrid[index]) {
            isColumnComplete = false;
            break;
          }
        }

        if (isColumnComplete && !_completedColumns.contains(col)) {
          _completedColumns.add(col);
          lineCompleted = true;
          foundCompletion = true;
          if (_lineDirection == null) {
            _lineDirection = "vertical";
          }
        }
      }
    }
  }

  void _checkGameOver() {
    if (_markedGrid.every((marked) => marked)) {
      _isGameOver = true;
      if (drinkDialogCount == 0) {
        _showGameOverDialog();
      }
    }
  }

  void _showGameOverDialog() {
    gameOverDialogShown = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ExitGameDialog(
          onPlayAgain: () {
            Navigator.pop(context);
            _restartGame();
          },
          onFinish: () {
            Navigator.pop(context);
            Navigator.pop(context);
            _restartGame();
          },
        );
      },
    );
  }

  void _restartGame() {
    setState(() {
      _markedGrid =
          List<bool>.filled(min(movie.bingoOptions.length, maxGridSize), false);

      _completedRows.clear();
      _completedColumns.clear();
      gameOverDialogShown = false;
      _lineDirection = null;
      _isGameOver = false;

      _saveGridState();
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => LeaveGameDialog(
            onYes: () {
              Navigator.pop(context, true);
            },
            onNo: () {
              Navigator.pop(context, false);
            },
            movieName: movie.movieName,
          ),
        )) ??
        false;
  }

  Widget _buildGridItem(int index) {
    if (index >= movie.bingoOptions.length) {
      return SizedBox.shrink();
    }

    String displayText = movie.bingoOptions[index];

    return GestureDetector(
      onTap: () => _toggleMark(index),
      child: Container(
        width: cellSize,
        height: cellSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(
            width: 1.0,
            color: Colors.transparent,
          ),
        ),
        child: Stack(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Color(0xFF19A1BE), Color(0xFF7D4192)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(
                      displayText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Axiforma',
                        fontSize: 12.r,
                        fontWeight: FontWeight.w600,
                        height: 1.25.h,
                        letterSpacing: -0.408,
                        color: _markedGrid[index]
                            ? Colors.white.withOpacity(0.5)
                            : Colors.white,
                      ),
                    ),
                  ),
                  if (_markedGrid[index])
                    Image.asset(
                      'assets/marked.png',
                      width: 57.w,
                      height: 57.h,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineOverlay(double gridTop, double gridLeft) {
    double lineThickness = 4.0.w;
    double linePadding = 16.0.w;

    List<Widget> lines = [];

    if (_lineDirection == "horizontal" || _lineDirection == null) {
      for (int row in _completedRows) {
        int rowLength =
            min(maxColumns, _markedGrid.length - (row * maxColumns));
        if (rowLength == maxColumns) {
          double yPos = gridTop + (row * cellSize) + (cellSize / 2) + 10.h;
          lines.add(
            Positioned(
              top: yPos - (lineThickness / 2),
              left: gridLeft + linePadding,
              right: gridLeft + linePadding,
              child: Container(
                height: lineThickness,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
          );
        }
      }
    }

    if (_lineDirection == "vertical" || _lineDirection == null) {
      for (int col in _completedColumns) {
        int rowCount = (_markedGrid.length / maxColumns).ceil();
        if (rowCount >= maxRows) {
          double xPos = gridLeft + (col * cellSize) + (cellSize / 2);
          lines.add(
            Positioned(
              top: gridTop + 25.h,
              bottom: 25.h,
              left: xPos - (lineThickness / 2),
              child: Container(
                width: lineThickness,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
          );
        }
      }
    }

    return Stack(children: lines);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Color(0xFF18181B),
        appBar: AppBar(
          backgroundColor: Color(0xFF18181B),
          automaticallyImplyLeading: false,
          leading: IconButton(
            padding: EdgeInsets.only(left: 16.w),
            icon: Icon(Icons.arrow_back_ios, size: 20.r, color: Colors.white),
            onPressed: () async {
              bool shouldLeave = await _onWillPop();
              if (shouldLeave) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(
            movie.movieName,
            style: TextStyle(
              fontFamily: 'Axiforma',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.408,
              color: Colors.white,
              height: 1.25.h,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              padding: EdgeInsets.only(right: 16.w),
              icon: Icon(Icons.settings_outlined,
                  size: 24.r, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            double availableHeight = constraints.maxHeight - 180.h - 20.h;
            double availableWidth = constraints.maxWidth - 20.w;
            cellSize =
                min(availableHeight / maxRows, availableWidth / maxColumns);

            double gridHeight = cellSize * maxRows;
            double gridWidth = cellSize * maxColumns;
            double gridTop = 180.h;
            double gridLeft = (constraints.maxWidth - gridWidth) / 2;

            return Stack(
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20.w, right: 20.w, bottom: 0.h),
                          child: Container(
                            width: double.infinity,
                            height: 180.h,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(movie.bannerImagePath),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          width: gridWidth,
                          height: gridHeight,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: maxColumns,
                              crossAxisSpacing: 1.0,
                              mainAxisSpacing: 1.0,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: _markedGrid.length,
                            itemBuilder: (context, index) {
                              return _buildGridItem(index);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _buildLineOverlay(gridTop, gridLeft),
              ],
            );
          },
        ),
      ),
    );
  }
}
