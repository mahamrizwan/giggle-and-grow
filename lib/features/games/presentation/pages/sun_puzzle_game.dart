import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:finalproject/core/constant/assets.dart';
import 'package:finalproject/core/constant/colors.dart';
import 'package:finalproject/core/utils/size_extension.dart';

// Screen imports
import 'package:finalproject/features/onboarding/presentation/pages/first_screen.dart';
import 'package:finalproject/features/learning/presentation/pages/learning_menu.dart';
import 'package:finalproject/features/drawing/presentation/widgets/canvas_painter.dart';
import 'package:finalproject/features/stories/presentation/pages/stories_list_page.dart';
import '../../../dashboard/presentation/provider/score_provider.dart';

class SunPuzzleGame extends StatefulWidget {
  const SunPuzzleGame({super.key});

  @override
  State<SunPuzzleGame> createState() => _SunPuzzleGameState();
}

class _SunPuzzleGameState extends State<SunPuzzleGame> {
  final String assetPath = 'assets/images/';

  Map<String, String?> score = {
    'target-1': null, 'target-2': null, 'target-3': null, 'target-4': null,
  };

  List<String> trayPieces = [
    'top_left.png', 'top_right.png', 'bottom_left.png', 'bottom_right.png',
  ];

  void resetGame() {
    setState(() {
      score = {'target-1': null, 'target-2': null, 'target-3': null, 'target-4': null};
      trayPieces = ['top_left.png', 'top_right.png', 'bottom_left.png', 'bottom_right.png'];
    });
  }

  void _checkCompletion() {
    int completedCount = score.values.where((v) => v != null).length;
    if (completedCount == 4) {
      // Update score in Firestore (+50 points for puzzle completion)
      context.read<ScoreProvider>().addScore(50, 'puzzle_game');
      _showWinDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    int completedCount = score.values.where((v) => v != null).length;

    return Scaffold(
      backgroundColor: const Color(0xFFE2FFD5),
      body: Column(
        children: [
          // 1. FIXED HEADER
          Padding(
            padding: EdgeInsets.fromLTRB(context.w(24), context.h(50), context.w(24), 0),
            child: _buildPopOutHeader(context),
          ),

          // 2. SCROLLABLE PUZZLE AREA
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: context.h(20)),
                  _buildStars(context, completedCount),
                  SizedBox(height: context.h(20)),
                  _buildPuzzleBoard(context),
                  SizedBox(height: context.h(20)),
                ],
              ),
            ),
          ),

          // 3. THE "CONTROL PANEL" (Hint + Tray + Buttons grouped together)
          _buildCombinedControlPanel(context),

          // 4. INTEGRATED BOTTOM NAVBAR
          _buildIntegratedNavbar(context),
        ],
      ),
    );
  }

  Widget _buildCombinedControlPanel(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.w(20)),
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4), // Fixed precision loss warning
        borderRadius: BorderRadius.circular(context.w(32)),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHintBox(context),
          SizedBox(height: context.h(12)),
          _buildPiecesTray(context),
          SizedBox(height: context.h(12)),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildPiecesTray(BuildContext context) {
    return Container(
      height: context.h(85),
      decoration: BoxDecoration(
        color: const Color(0xFF5BB1FB).withValues(alpha: 0.2), // Fixed precision loss warning
        borderRadius: BorderRadius.circular(context.w(24)),
      ),
      child: trayPieces.isEmpty
          ? Center(child: Text("Sun Complete!", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900, fontSize: context.sp(16))))
          : ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: context.w(10)),
        itemCount: trayPieces.length,
        itemBuilder: (context, index) {
          String piece = trayPieces[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: context.w(8)),
            child: Center(
              child: Draggable<String>(
                data: piece,
                feedback: Material(color: Colors.transparent, child: Image.asset('$assetPath$piece', width: context.w(75))),
                childWhenDragging: Opacity(opacity: 0.3, child: Image.asset('$assetPath$piece', width: context.w(60))),
                child: Image.asset('$assetPath$piece', width: context.w(60)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPuzzleBoard(BuildContext context) {
    return Container(
      width: context.w(320),
      height: context.w(320),
      padding: EdgeInsets.all(context.w(12)),
      decoration: BoxDecoration(
        color: const Color(0xFFCAFFBB),
        borderRadius: BorderRadius.circular(context.w(40)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)], // Fixed precision loss warning
      ),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: context.w(10),
        crossAxisSpacing: context.w(10),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildDragTarget('target-1', 'top_left.png', context),
          _buildDragTarget('target-2', 'top_right.png', context),
          _buildDragTarget('target-3', 'bottom_left.png', context),
          _buildDragTarget('target-4', 'bottom_right.png', context),
        ],
      ),
    );
  }

  Widget _buildDragTarget(String targetId, String correctPiece, BuildContext context) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        bool isFilled = score[targetId] != null;
        return Container(
          decoration: BoxDecoration(
            color: isFilled ? Colors.transparent : Colors.white.withValues(alpha: 0.4), // Fixed
            borderRadius: BorderRadius.circular(context.w(20)),
            border: isFilled ? null : Border.all(color: Colors.white.withValues(alpha: 0.6), width: 2), // Fixed
          ),
          child: isFilled
              ? ClipRRect(
              borderRadius: BorderRadius.circular(context.w(18)),
              child: Image.asset('$assetPath${score[targetId]}', fit: BoxFit.cover))
              : null,
        );
      },
      onWillAcceptWithDetails: (details) => details.data == correctPiece,
      onAcceptWithDetails: (details) {
        setState(() {
          score[targetId] = details.data;
          trayPieces.remove(details.data);
          _checkCompletion();
        });
      },
    );
  }

  Widget _buildHintBox(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: context.w(18),
          backgroundColor: Colors.white,
          child: Icon(Icons.lightbulb_rounded, color: const Color(0xFF5BB1FB), size: context.sp(22)),
        ),
        SizedBox(width: context.w(12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Can you find the spot?",
                  style: TextStyle(fontWeight: FontWeight.w900, color: const Color(0xFF004A86), fontSize: context.sp(14))),
              Text("Drag pieces to finish the sun!",
                  style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xFF004A86), fontSize: context.sp(12))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        _actionBtn(context, "Restart", const Color(0xFF75FF68), 'assets/icons/arrow.svg', true, resetGame),
        SizedBox(width: context.w(10)),
        _actionBtn(context, "Next", const Color(0xFFFFD709), 'assets/icons/backarrow.svg', false, () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FirstScreen()));
        }),
      ],
    );
  }

  Widget _actionBtn(BuildContext context, String text, Color color, String svgPath, bool leading, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: context.h(12)),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(context.w(20)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))], // Fixed
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading) SvgPicture.asset(svgPath, width: context.w(16)),
              if (leading) SizedBox(width: context.w(6)),
              Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: context.sp(14))),
              if (!leading) SizedBox(width: context.w(6)),
              if (!leading) SvgPicture.asset(svgPath, width: context.w(16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopOutHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
                "assets/images/logo_icon.png",
                height: context.h(30),
                errorBuilder: (context, error, stackTrace) => Icon(Icons.face, size: context.sp(30)) // Fixed unused "_"
            ),
            SizedBox(width: context.w(10)),
            Text("Giggle & Grow", style: TextStyle(fontSize: context.sp(20), fontWeight: FontWeight.w900, color: const Color(0xFF453900))),
          ],
        ),
        Consumer<ScoreProvider>(
          builder: (context, scoreProvider, child) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: context.w(12), vertical: context.h(6)),
              decoration: BoxDecoration(color: const Color(0xFFFFD709), borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Text("${scoreProvider.totalScore}", style: TextStyle(fontWeight: FontWeight.w900, fontSize: context.sp(14))),
                  const SizedBox(width: 4),
                  Icon(Icons.star, size: context.sp(16)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStars(BuildContext context, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        double size = (i == 1) ? 50.0 : 35.0;
        bool active = (i == 0 && count >= 1) || (i == 1 && count >= 4) || (i == 2 && count >= 3);
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(8)),
          child: Opacity(opacity: active ? 1.0 : 0.3, child: Icon(Icons.star, color: Colors.amber, size: context.sp(size))),
        );
      }),
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.w(30))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Yaay! 🥳", style: TextStyle(fontSize: context.sp(24), fontWeight: FontWeight.w900)),
            SizedBox(height: context.h(10)),
            Icon(Icons.star, color: Colors.amber, size: context.sp(60)),
            SizedBox(height: context.h(20)),
            ElevatedButton(
              onPressed: () { Navigator.pop(context); resetGame(); },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD709), shape: const StadiumBorder()),
              child: const Text("Play Again", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIntegratedNavbar(BuildContext context) {
    return Container(
      height: context.h(85),
      margin: EdgeInsets.only(top: context.h(10)),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, 0, "GAMES", Assets.gamesBlueIcon, Assets.gamesBrownIcon),
          _navItem(context, 1, "LEARN", Assets.learnBlueIcon, Assets.learnBrownIcon),
          _navItem(context, 2, "DRAW", Assets.drawBlueIcon, Assets.drawBrownIcon),
          _navItem(context, 3, "STORIES", Assets.storiesBlueIcon, Assets.storiesBrownIcon),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, int idx, String label, String bIcon, String brIcon) {
    bool isSel = idx == 0;
    return GestureDetector(
      onTap: () {
        if (isSel) return;
        Widget screen = const FirstScreen();
        if (idx == 1) screen = const LearningMenu();
        if (idx == 2) screen = const DrawingCanvasScreen();
        if (idx == 3) screen = const StoriesListPage();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => screen)); // Fixed unused "_"
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(isSel ? brIcon : bIcon, width: context.w(24)),
          Text(label, style: TextStyle(fontSize: context.sp(10), fontWeight: FontWeight.bold, color: isSel ? AppColors.navBarTextActive : AppColors.navBarIconInactive)),
        ],
      ),
    );
  }
}


