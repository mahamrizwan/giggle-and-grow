import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:finalproject/core/utils/size_extension.dart';

// Navigation Imports
import 'package:finalproject/features/onboarding/presentation/pages/first_screen.dart';
import 'package:finalproject/features/learning/presentation/pages/learning_menu.dart';
import 'package:finalproject/features/drawing/presentation/widgets/canvas_painter.dart';
import 'package:finalproject/features/stories/presentation/pages/stories_list_page.dart';
import 'package:finalproject/features/dashboard/presentation/provider/score_provider.dart';

class AlphabetData {
  final String letter;
  final String word;
  final String imagePath;
  final String audioPath;

  const AlphabetData({
    required this.letter,
    required this.word,
    required this.imagePath,
    required this.audioPath,
  });
}

class AlphabetLearningScreen extends StatefulWidget {
  const AlphabetLearningScreen({super.key});

  @override
  State<AlphabetLearningScreen> createState() => _AlphabetLearningScreenState();
}

class _AlphabetLearningScreenState extends State<AlphabetLearningScreen> {
  int currentIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Color brandColor = const Color(0xFF04647D);

  final List<AlphabetData> alphabetList = const [
    AlphabetData(letter: 'A', word: 'Apple', imagePath: 'assets/images/Apple.png', audioPath: 'audio/A.mp3'),
    AlphabetData(letter: 'B', word: 'Ball', imagePath: 'assets/images/ball.png', audioPath: 'audio/B.mp3'),
    AlphabetData(letter: 'C', word: 'Cat', imagePath: 'assets/images/cat.png', audioPath: 'audio/C.mp3'),
    AlphabetData(letter: 'D', word: 'Dog', imagePath: 'assets/images/dog.jpeg', audioPath: 'audio/D.mp3'),
    AlphabetData(letter: 'E', word: 'Elephant', imagePath: 'assets/images/elephant.jpeg', audioPath: 'audio/E.mp3'),
    AlphabetData(letter: 'F', word: 'Fish', imagePath: 'assets/images/fish.jpeg', audioPath: 'audio/F.mp3'),
    AlphabetData(letter: 'G', word: 'Grapes', imagePath: 'assets/images/grapes.jpeg', audioPath: 'audio/G.mp3'),
    AlphabetData(letter: 'H', word: 'Hat', imagePath: 'assets/images/hat.jpeg', audioPath: 'audio/H.mp3'),
    AlphabetData(letter: 'I', word: 'Ice Cream', imagePath: 'assets/images/icecream.jpeg', audioPath: 'audio/I.mp3'),
    AlphabetData(letter: 'J', word: 'Jellyfish', imagePath: 'assets/images/jellyfish.png', audioPath: 'audio/J.mp3'),
    AlphabetData(letter: 'K', word: 'Kite', imagePath: 'assets/images/kite.jpeg', audioPath: 'audio/K.mp3'),
    AlphabetData(letter: 'L', word: 'Lion', imagePath: 'assets/images/Lion.jpeg', audioPath: 'audio/L.mp3'),
    AlphabetData(letter: 'M', word: 'Monkey', imagePath: 'assets/images/monkey.jpeg', audioPath: 'audio/M.mp3'),
    AlphabetData(letter: 'N', word: 'Nest', imagePath: 'assets/images/nest.png', audioPath: 'audio/N.mp3'),
    AlphabetData(letter: 'O', word: 'Orange', imagePath: 'assets/images/orange.png', audioPath: 'audio/O.mp3'),
    AlphabetData(letter: 'P', word: 'Penguin', imagePath: 'assets/images/penguin.png', audioPath: 'audio/P.mp3'),
    AlphabetData(letter: 'Q', word: 'Queen', imagePath: 'assets/images/Queen.png', audioPath: 'audio/Q.mp3'),
    AlphabetData(letter: 'R', word: 'Rabbit', imagePath: 'assets/images/rabbit.png', audioPath: 'audio/R.mp3'),
    AlphabetData(letter: 'S', word: 'Sun', imagePath: 'assets/images/sun.png', audioPath: 'audio/S.mp3'),
    AlphabetData(letter: 'T', word: 'Tiger', imagePath: 'assets/images/tiger.png', audioPath: 'audio/T.mp3'),
    AlphabetData(letter: 'U', word: 'Umbrella', imagePath: 'assets/images/umbrella.png', audioPath: 'audio/U.mp3'),
    AlphabetData(letter: 'V', word: 'Violin', imagePath: 'assets/images/Violin.png', audioPath: 'audio/V.mp3'),
    AlphabetData(letter: 'W', word: 'Whale', imagePath: 'assets/images/whale.png', audioPath: 'audio/W.mp3'),
    AlphabetData(letter: 'X', word: 'Xylophone', imagePath: 'assets/images/xylophone.png', audioPath: 'audio/X.mp3'),
    AlphabetData(letter: 'Y', word: 'Yak', imagePath: 'assets/images/yak.png', audioPath: 'audio/Y.mp3'),
    AlphabetData(letter: 'Z', word: 'Zebra', imagePath: 'assets/images/zebra.jpeg', audioPath: 'audio/Z.mp3'),
  ];

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio(String path) async {
    try {
      await _audioPlayer.play(AssetSource(path.replaceAll('assets/', '')));
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = alphabetList[currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFE2FFD5),
      body: Column(
        children: [
          _buildElevatedHeader(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: context.h(20)),
              child: Column(
                children: [
                  _buildLetterCard(context, item.letter),
                  SizedBox(height: context.h(25)),
                  _buildImageCard(context, item.imagePath),
                  SizedBox(height: context.h(15)),
                  Text(
                    "${item.word}!",
                    style: TextStyle(
                      fontFamily: 'PlusJakarta',
                      fontSize: context.sp(36),
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF6C5A00),
                      letterSpacing: -0.9,
                    ),
                  ),
                  SizedBox(height: context.h(30)),
                  _buildActionButtons(context, item.audioPath),
                  SizedBox(height: context.h(20)),
                  _buildPaginationDots(context),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context, brandColor),
    );
  }

  Widget _buildElevatedHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(context.w(20), context.h(52), context.w(20), context.h(18)),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FBE4),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(context.w(36))),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible( // Added Flexible to prevent text overflow
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/logo_icon.png',
                    width: context.w(32),
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.face, size: context.sp(30), color: const Color(0xFF5A4800))
                ),
                SizedBox(width: context.w(10)),
                const Flexible( // Allows text to truncate if space is tight
                  child: Text(
                    'Giggle & Grow',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF5A4800),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Consumer<ScoreProvider>(
            builder: (context, scoreProvider, child) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: context.w(14), vertical: context.h(7)),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD600),
                  borderRadius: BorderRadius.circular(context.w(22)),
                ),
                child: Row(
                  children: [
                    Text('${scoreProvider.totalScore}', style: TextStyle(fontWeight: FontWeight.w900, fontSize: context.sp(14))),
                    SizedBox(width: context.w(4)),
                    Icon(Icons.star_rounded, size: context.sp(18)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLetterCard(BuildContext context, String letter) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: context.w(180),
          height: context.h(192),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(context.w(40)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), // Fixed Deprecation
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Center(
            child: Transform.rotate(
              angle: 3 * 3.14159 / 180,
              child: Text(
                letter,
                style: TextStyle(
                  fontFamily: 'PlusJakarta',
                  fontSize: context.sp(160),
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFB32F0B),
                  height: 1.0,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: context.w(-15),
          bottom: context.h(-10),
          child: Container(
            padding: EdgeInsets.all(context.w(12)),
            decoration: const BoxDecoration(
              color: Color(0xFFB02E7A),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
              ],
            ),
            child: SvgPicture.asset(
              'assets/images/brush.svg',
              width: context.w(28),
              height: context.h(28),
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              errorBuilder: (context, error, stackTrace) => Icon(Icons.brush, color: Colors.white, size: context.sp(28)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageCard(BuildContext context, String path) {
    return Container(
      padding: EdgeInsets.all(context.w(12)),
      decoration: BoxDecoration(
        color: const Color(0xFF6BFF4D),
        borderRadius: BorderRadius.circular(context.w(50)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.w(40)),
        child: Container(
          color: Colors.white,
          child: Image.asset(
              path, width: context.w(180), height: context.h(180), fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => SizedBox(width: context.w(180), height: context.h(180), child: Icon(Icons.image, size: context.sp(50)))
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, String audioPath) {
    return Column(
      children: [
        if (currentIndex > 0) ...[
          _navBtn(context, "Back", const Color(0xFFA5E3FF), Icons.arrow_back, () {
            setState(() => currentIndex--);
          }),
          SizedBox(height: context.h(15)),
        ],

        _listenBtn(context, audioPath),

        if (currentIndex < alphabetList.length - 1) ...[
          SizedBox(height: context.h(15)),
          _navBtn(context, "Next", const Color(0xFF1DFF3B), Icons.arrow_forward, () {
            setState(() => currentIndex++);
          }, isTrailing: true),
        ],
      ],
    );
  }

  Widget _navBtn(BuildContext context, String text, Color color, IconData icon, VoidCallback onTap, {bool isTrailing = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.w(300),
        height: context.h(56),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(context.w(35)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 4))], // Fixed Deprecation
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isTrailing) Icon(icon, size: context.sp(22)),
            SizedBox(width: context.w(10)),
            Text(text, style: TextStyle(fontFamily: 'PlusJakarta', fontWeight: FontWeight.w700, fontSize: context.sp(20))),
            SizedBox(width: context.w(10)),
            if (isTrailing) Icon(icon, size: context.sp(22)),
          ],
        ),
      ),
    );
  }

  Widget _listenBtn(BuildContext context, String audioPath) {
    return GestureDetector(
      onTap: () => _playAudio(audioPath),
      child: Container(
        width: context.w(320),
        padding: EdgeInsets.symmetric(vertical: context.h(20)),
        decoration: BoxDecoration(
          color: const Color(0xFFFFD709),
          borderRadius: BorderRadius.circular(context.w(100)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 4))], // Fixed Deprecation
        ),
        child: Column(
          children: [
            CircleAvatar(backgroundColor: Colors.white, radius: context.w(20), child: Icon(Icons.volume_up, color: const Color(0xFF7A6B1C), size: context.sp(20))),
            SizedBox(height: context.h(8)),
            Text(
              "LISTEN!",
              style: TextStyle(
                fontFamily: 'PlusJakarta',
                fontWeight: FontWeight.w900,
                fontSize: context.sp(24),
                color: const Color(0xFF7A6B1C),
                letterSpacing: 2.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationDots(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: context.w(30), height: context.h(10), decoration: BoxDecoration(color: const Color(0xFF5A4D00), borderRadius: BorderRadius.circular(context.w(10)))),
        SizedBox(width: context.w(8)),
        ...List.generate(4, (index) => Container(
          margin: EdgeInsets.only(right: context.w(8)),
          width: context.w(10), height: context.h(10),
          decoration: const BoxDecoration(color: Color(0xFFB4F59D), shape: BoxShape.circle),
        )),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context, Color brandColor) {
    return Container(
      height: context.h(85),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(context.w(32)))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(context, Icons.videogame_asset_outlined, "GAMES", 0, brandColor),
          _navItem(context, Icons.school, "LEARN", 1, brandColor),
          _navItem(context, Icons.palette_outlined, "DRAW", 2, brandColor),
          _navItem(context, Icons.menu_book_outlined, "STORIES", 3, brandColor),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, int index, Color brandColor) {
    bool isActive = index == 1;

    return GestureDetector(
      onTap: () {
        if (isActive) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LearningMenu()));
          return;
        }
        Widget nextScreen;
        switch (index) {
          case 0: nextScreen = const FirstScreen(); break;
          case 2: nextScreen = const DrawingCanvasScreen(); break;
          case 3: nextScreen = const StoriesListPage(); break;
          default: return;
        }
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => nextScreen));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isActive)
            Container(
              padding: EdgeInsets.all(context.w(10)),
              decoration: const BoxDecoration(color: Color(0xFFFFD709), shape: BoxShape.circle),
              child: Icon(icon, color: brandColor, size: context.sp(24)),
            )
          else
            Icon(icon, color: brandColor.withValues(alpha: 0.6), size: context.sp(24)), // Fixed Deprecation
          SizedBox(height: context.h(4)),
          Text(label, style: TextStyle(fontSize: context.sp(10), color: brandColor, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}