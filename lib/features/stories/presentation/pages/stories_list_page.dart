import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/assets.dart';
import '../../../../core/constant/colors.dart';
import 'package:finalproject/features/drawing/presentation/widgets/canvas_painter.dart';
import 'package:finalproject/features/onboarding/presentation/pages/first_screen.dart';
import 'package:finalproject/features/learning/presentation/pages/learning_menu.dart';
import '../../../dashboard/presentation/provider/score_provider.dart';
import 'story_reader_page.dart';

class StoriesListPage extends StatefulWidget {
  const StoriesListPage({super.key});

  @override
  State<StoriesListPage> createState() => _StoriesListPageState();
}

class _StoriesListPageState extends State<StoriesListPage> {
  int _selectedIndex = 3;

  final List<Map<String, dynamic>> _stories = [
    {"title": "The Brave Little Fox", "time": "8 MINS", "tag": "ADVENTURE", "img": Assets.story1Image, "id": 0},
    {"title": "A Day at the Beach", "time": "5 MINS", "tag": "FUN", "img": Assets.story2Image, "id": 1},
    {"title": "The Star's Best Friend", "time": "12 MINS", "tag": "BEDTIME", "img": Assets.story3Image, "id": 2},
    {"title": "The Silly Rainbow", "time": "6 MINS", "tag": "FUNNY", "img": Assets.story4Image, "id": 3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBarGreen,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        _buildHeaderContainer(),
                        const SizedBox(height: 30),
                        ..._stories.map((story) => _buildStoryCard(story)),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomNavBar()),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.appBarGreen,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: const BoxDecoration(color: AppColors.accentYellow, shape: BoxShape.circle),
            child: Center(child: SvgPicture.asset(Assets.logoIcon, width: 22, height: 22)),
          ),
          const SizedBox(width: 12),
          const Text("Giggle & Grow", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: AppColors.navBarTextActive, fontFamily: 'Jakarta')),
          const Spacer(),
          Consumer<ScoreProvider>(
            builder: (context, scoreProvider, child) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                child: Row(
                  children: [
                    Text("${scoreProvider.totalScore}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black)),
                    const SizedBox(width: 4),
                    SvgPicture.asset(Assets.goldIcon, width: 20),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderContainer() {
    return const Column(
      children: [
        Text("Magical Stories", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.navBarTextActive, fontFamily: 'Jakarta')),
        SizedBox(height: 4),
        Text("Pick an adventure and start", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: AppColors.tagGreenText, fontFamily: 'Jakarta', fontWeight: FontWeight.w600)),
        Text("listening!", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: AppColors.tagGreenText, fontFamily: 'Jakarta', fontWeight: FontWeight.w600))
      ],
    );
  }

  Widget _buildStoryCard(Map<String, dynamic> story) {
    return Container(
      width: 342,
      margin: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(34), border: Border.all(color: Colors.black, width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: SizedBox(
              width: 310, height: 193.75,
              child: Stack(
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.asset(story['img'], width: 310, height: 193.75, fit: BoxFit.cover)),
                  Positioned(
                    left: 230, top: 113.75,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => StoryReaderPage(storyId: story['id'])));
                      },
                      child: Container(
                        width: 64, height: 64,
                        decoration: const BoxDecoration(color: AppColors.accentYellow, shape: BoxShape.circle),
                        child: Center(child: SvgPicture.asset(Assets.playButtonIcon, width: 16.5, height: 21)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(story['title'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF04647D), fontFamily: 'Jakarta', height: 1.33)),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 24),
            child: Row(
              children: [
                _buildTag(story['time'], AppColors.tagBlueBg, const Color(0xFF04647D)),
                const SizedBox(width: 8),
                _buildTag(story['tag'], const Color(0xFF9EFF9A).withValues(alpha: 0.5), const Color(0xFF006B0A)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'BeVietnam', letterSpacing: 0.6)),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 100,
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(0, "GAMES", Assets.gamesBlueIcon, Assets.gamesBrownIcon),
          _navItem(1, "LEARN", Assets.learnBlueIcon, Assets.learnBrownIcon),
          _navItem(2, "DRAW", Assets.drawBlueIcon, Assets.drawBrownIcon),
          _navItem(3, "STORIES", Assets.storiesBlueIcon, Assets.storiesBrownIcon),
        ],
      ),
    );
  }

  Widget _navItem(int idx, String label, String blueIcon, String brownIcon) {
    bool isSel = _selectedIndex == idx;
    return GestureDetector(
      onTap: () {
        if (idx == 0) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FirstScreen()));
        } else if (idx == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LearningMenu()));
        } else if (idx == 2) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const DrawingCanvasScreen()));
        } else if (idx == 3) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const StoriesListPage()));
        } else {
          setState(() => _selectedIndex = idx);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSel ? BoxDecoration(color: AppColors.accentYellow, borderRadius: BorderRadius.circular(20)) : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(isSel ? brownIcon : blueIcon, width: 24),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isSel ? AppColors.navBarTextActive : AppColors.navBarIconInactive)),
          ],
        ),
      ),
    );
  }
}