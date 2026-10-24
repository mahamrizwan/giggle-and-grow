import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/size_extension.dart';
import '../../../drawing/presentation/widgets/canvas_painter.dart';
import '../../../learning/presentation/pages/learning_menu.dart';
import '../../../onboarding/presentation/pages/first_screen.dart';
import '../../../stories/presentation/pages/stories_list_page.dart';
import '../../../dashboard/presentation/provider/score_provider.dart';

class MemoryGameBoard extends StatefulWidget {
  const MemoryGameBoard({super.key});

  @override
  State<MemoryGameBoard> createState() => _MemoryGameBoardState();
}

class _MemoryGameBoardState extends State<MemoryGameBoard> {
  final List<String> _icons = [
    '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼',
    '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼',
  ]..shuffle();

  final List<bool> _cardFlipped = List.generate(16, (index) => false);
  final List<int> _selectedIndices = [];
  bool _isProcessing = false;
  final int _selectedIndex = 0;

  Timer? _timer;
  int _secondsRemaining = 45;
  bool _gameEnded = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
        _endGame(false);
      }
    });
  }

  void _endGame(bool won) {
    if (_gameEnded) return;
    setState(() => _gameEnded = true);

    if (won) {
      // Update score in Firestore (+50 points)
      context.read<ScoreProvider>().addScore(50, 'memory_match');
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(won ? "You Win! 🎉" : "Time's Up! ⏰"),
        content: Text(won ? "Great job matching the pairs!" : "Better luck next time!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _handleTap(int index) {
    if (_isProcessing || _cardFlipped[index] || _gameEnded) return;

    setState(() {
      _cardFlipped[index] = true;
      _selectedIndices.add(index);
    });

    if (_selectedIndices.length == 2) {
      _isProcessing = true;

      if (_icons[_selectedIndices[0]] != _icons[_selectedIndices[1]]) {
        Timer(const Duration(milliseconds: 600), () {
          if (mounted) {
            setState(() {
              _cardFlipped[_selectedIndices[0]] = false;
              _cardFlipped[_selectedIndices[1]] = false;
              _selectedIndices.clear();
              _isProcessing = false;
            });
          }
        });
      } else {
        _selectedIndices.clear();
        _isProcessing = false;

        if (_cardFlipped.every((flipped) => flipped)) {
          _timer?.cancel();
          _endGame(true);
        }
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FCE4),
      body: Column(
        children: [
          _buildPartnerAppBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: context.h(16)),
                  _buildLevelLabel(),
                  SizedBox(height: context.h(12)),
                  _buildMainTitle(),
                  SizedBox(height: context.h(4)),
                  _build4x4Grid(),
                  SizedBox(height: context.h(16)),
                  _buildTimerSection(),
                  SizedBox(height: context.h(40)),
                ],
              ),
            ),
          ),
          _buildPartnerBottomNav(),
        ],
      ),
    );
  }

  Widget _buildPartnerAppBar() {
    return Container(
      width: double.infinity,
      height: context.h(140),
      padding: EdgeInsets.only(
        left: context.w(20),
        right: context.w(20),
        bottom: context.h(20),
        top: MediaQuery.of(context).padding.top + context.h(5),
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFE2FFD5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: context.w(45), height: context.w(45),
              decoration: const BoxDecoration(color: Color(0xFF21FF31), shape: BoxShape.circle),
              child: Icon(Icons.arrow_back, color: Colors.black, size: context.sp(28)),
            ),
          ),
          SizedBox(width: context.w(12)),
          SvgPicture.asset(
            'assets/icons/smileIcon.svg',
            width: context.w(35), height: context.w(35),
            colorFilter: const ColorFilter.mode(Color(0xFF6C5A00), BlendMode.srcIn),
          ),
          SizedBox(width: context.w(10)),
          Expanded(
            child: Text(
              "Giggle &\nGrow",
              style: TextStyle(height: 1.1, fontWeight: FontWeight.w900, fontSize: context.sp(24), color: const Color(0xFF6C5A00)),
            ),
          ),
          Consumer<ScoreProvider>(
            builder: (context, scoreProvider, child) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: context.w(18), vertical: context.h(8)),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD709),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${scoreProvider.totalScore}", style: TextStyle(fontWeight: FontWeight.w900, fontSize: context.sp(20), color: const Color(0xFF6C5A00))),
                    Text("⭐", style: TextStyle(fontSize: context.sp(14))),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimerSection() {
    String minutes = (_secondsRemaining ~/ 60).toString();
    String seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');

    return Container(
      width: context.w(320),
      height: context.h(55),
      padding: EdgeInsets.symmetric(horizontal: context.w(16)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF9EFF8D), width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.timer_outlined, color: const Color(0xFF04647D), size: context.sp(24)),
          SizedBox(width: context.w(8)),
          Text(
            "$minutes:$seconds",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: context.sp(16), color: const Color(0xFF04647D)),
          ),
          const Spacer(),
          Row(
            children: List.generate(5, (i) => Container(
              margin: EdgeInsets.only(left: context.w(4)),
              width: context.w(12), height: context.w(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < (5 - (_secondsRemaining / 9).floor()) ? const Color(0xFF04647D) : const Color(0xFF21FF31),
              ),
            )),
          )
        ],
      ),
    );
  }

  Widget _buildLevelLabel() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.w(24), vertical: context.h(8)),
      decoration: BoxDecoration(color: const Color(0xFF9AE1FF), borderRadius: BorderRadius.circular(48)),
      child: Text("LEVEL 1: ANIMAL FRIENDS", style: TextStyle(fontWeight: FontWeight.w700, fontSize: context.sp(12), color: const Color(0xFF005267))),
    );
  }

  Widget _buildMainTitle() => Text("Match the Pairs!", style: TextStyle(fontWeight: FontWeight.w800, fontSize: context.sp(32), color: const Color(0xFF6C5A00)));

  Widget _build4x4Grid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(24)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: context.h(10),
          crossAxisSpacing: context.w(10),
          mainAxisExtent: context.h(75),
        ),
        itemCount: 16,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => _handleTap(index),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFCAFFBB), width: 3),
            ),
            child: Center(
              child: Text(
                _cardFlipped[index] ? _icons[index] : "?",
                style: TextStyle(fontSize: context.sp(28), fontWeight: FontWeight.bold, color: const Color(0xFF04647D)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPartnerBottomNav() {
    return Container(
      height: context.h(100),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(0, "GAMES", Icons.extension),
          _navItem(1, "LEARN", Icons.school),
          _navItem(2, "DRAW", Icons.palette),
          _navItem(3, "STORIES", Icons.menu_book),
        ],
      ),
    );
  }

  Widget _navItem(int idx, String label, IconData icon) {
    bool isSel = _selectedIndex == idx;
    return GestureDetector(
      onTap: () {
        if (isSel) return;
        _timer?.cancel();
        Widget nextScreen;
        switch (idx) {
          case 0: nextScreen = const FirstScreen(); break;
          case 1: nextScreen = const LearningMenu(); break;
          case 2: nextScreen = const DrawingCanvasScreen(); break;
          case 3: nextScreen = const StoriesListPage(); break;
          default: nextScreen = const FirstScreen();
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextScreen),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: context.w(20), vertical: context.h(8)),
            decoration: BoxDecoration(color: isSel ? const Color(0xFFFFD709) : Colors.transparent, borderRadius: BorderRadius.circular(25)),
            child: Icon(icon, color: isSel ? const Color(0xFF6C5A00) : const Color(0xFF04647D), size: context.sp(26)),
          ),
          SizedBox(height: context.h(4)),
          Text(label, style: TextStyle(fontSize: context.sp(10), fontWeight: FontWeight.w800, color: isSel ? const Color(0xFF6C5A00) : const Color(0xFF04647D))),
        ],
      ),
    );
  }
}
