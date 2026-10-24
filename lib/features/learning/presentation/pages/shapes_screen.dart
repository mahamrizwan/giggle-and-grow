import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// --- Confirmed Paths ---
import '../../../../core/utils/size_extension.dart';
import '../../../drawing/presentation/widgets/canvas_painter.dart';
import '../../../onboarding/presentation/pages/first_screen.dart';
import '../../../stories/presentation/pages/stories_list_page.dart';
import '../../../dashboard/presentation/provider/score_provider.dart';
import 'learning_menu.dart';

class ShapesScreen extends StatefulWidget {
  const ShapesScreen({super.key});

  @override
  State<ShapesScreen> createState() => _ShapesScreenState();
}

class _ShapesScreenState extends State<ShapesScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final int _selectedIndex = 1; // LEARN is the active tab

  void _playShapeSound(String shapeName) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/${shapeName.toLowerCase()}.mpeg'));
    } catch (e) {
      debugPrint("Audio Playback Error: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FCE4),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                  context.w(24),
                  context.h(160),
                  context.w(24),
                  context.h(120)
              ),
              child: Column(
                children: [
                  _buildInstructionHeader(),
                  SizedBox(height: context.h(24)),
                  _buildShapeCard("TRIANGLE", const Color(0xFFFFD709), Icons.change_history_rounded),
                  SizedBox(height: context.h(20)),
                  _buildShapeCard("SQUARE", const Color(0xFF9AE1FF), Icons.square_rounded),
                  SizedBox(height: context.h(20)),
                  _buildShapeCard("CIRCLE", const Color(0xFFFF9ECD), Icons.circle),
                  SizedBox(height: context.h(20)),
                  _buildShapeCard("STAR", const Color(0xFF21FF31), Icons.star_rounded),
                ],
              ),
            ),
          ),
          Positioned(top: 0, left: 0, right: 0, child: _buildTopBar()),
          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomNav()),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: context.h(140),
      padding: EdgeInsets.only(
        left: context.w(20),
        right: context.w(20),
        bottom: context.h(20),
        top: MediaQuery.of(context).padding.top + 5,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFE2FFD5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: context.w(45),
              height: context.w(45),
              decoration: const BoxDecoration(color: Color(0xFF21FF31), shape: BoxShape.circle),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/smileIcon.svg',
                  width: context.w(25),
                  colorFilter: const ColorFilter.mode(Color(0xFF6C5A00), BlendMode.srcIn),
                ),
              ),
            ),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: Text(
              "Giggle &\nGrow",
              style: TextStyle(
                  height: 1.1,
                  fontWeight: FontWeight.w900,
                  fontSize: context.sp(24),
                  color: const Color(0xFF6C5A00)
              ),
            ),
          ),
          Consumer<ScoreProvider>(
            builder: (context, scoreProvider, child) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: context.w(18), vertical: context.h(8)),
                decoration: BoxDecoration(color: const Color(0xFFFFD709), borderRadius: BorderRadius.circular(25)),
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

  Widget _buildShapeCard(String label, Color color, IconData icon) {
    return GestureDetector(
      onTap: () => _playShapeSound(label),
      child: Container(
        width: double.infinity,
        height: context.h(300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: context.sp(160), color: color),
            SizedBox(height: context.h(20)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: context.w(40), vertical: context.h(12)),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(25)),
              child: Text(
                "$label!",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: context.sp(18), color: const Color(0xFF6C5A00)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: context.h(100),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(0, "GAMES"),
          _navItem(1, "LEARN"),
          _navItem(2, "DRAW"),
          _navItem(3, "STORIES"),
        ],
      ),
    );
  }

  Widget _navItem(int idx, String label) {
    bool isSel = _selectedIndex == idx;
    return GestureDetector(
      onTap: () {
        if (isSel) return;

        Widget? nextScreen;
        if (idx == 0) {
          nextScreen = const FirstScreen();
        } else if (idx == 1) {
          nextScreen = const LearningMenu();
        } else if (idx == 2) {
          nextScreen = const DrawingCanvasScreen();
        } else if (idx == 3) {
          nextScreen = const StoriesListPage();
        }

        if (nextScreen != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => nextScreen!),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(8)),
        decoration: isSel ? BoxDecoration(color: const Color(0xFFFFD709), borderRadius: BorderRadius.circular(20)) : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              idx == 0 ? Icons.extension : idx == 1 ? Icons.school : idx == 2 ? Icons.palette : Icons.menu_book,
              color: isSel ? const Color(0xFF6C5A00) : Colors.blueGrey,
              size: context.sp(24),
            ),
            Text(
                label,
                style: TextStyle(
                    fontSize: context.sp(10),
                    fontWeight: FontWeight.bold,
                    color: isSel ? const Color(0xFF6C5A00) : Colors.blueGrey
                )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionHeader() {
    return Container(
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        "Tap a shape to hear its name!",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: context.sp(20), color: const Color(0xFF04647D)),
      ),
    );
  }
}
