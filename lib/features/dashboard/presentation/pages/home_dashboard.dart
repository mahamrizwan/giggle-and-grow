import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../../../../../core/constant/assets.dart';
import '../../../../../core/constant/colors.dart';
import '../../../../../core/utils/size_extension.dart';
import '../../../onboarding/presentation/pages/onboarding_page.dart';
import '../../../stories/presentation/pages/stories_list_page.dart';
import 'package:finalproject/features/onboarding/presentation/pages/first_screen.dart';
import 'package:finalproject/features/drawing/presentation/widgets/canvas_painter.dart';
import 'package:finalproject/features/learning/presentation/pages/learning_menu.dart';
import '../provider/score_provider.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset(Assets.homeBackgroundImage, fit: BoxFit.cover)),
          SafeArea(
            top: false,
            child: Column(
              children: [
                _buildCustomAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: context.h(160)),
                    child: Column(
                      children: [
                        SizedBox(height: context.h(20)),
                        Image.asset(Assets.mascot2Image, height: context.h(140)),
                        _buildMascotGreeting(),
                        SizedBox(height: context.h(30)),
                        _buildButtonGrid(context),
                        SizedBox(height: context.h(40)),
                        _buildAdventureLevelCard(context),
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

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.h(100),
      padding: EdgeInsets.only(left: 24, right: 24, bottom: 16, top: MediaQuery.of(context).padding.top + 10),
      decoration: const BoxDecoration(
        color: AppColors.appBarGreen,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnboardingPage())),
            child: Container(
              width: 40, height: 40,
              decoration: const BoxDecoration(color: AppColors.accentYellow, shape: BoxShape.circle),
              child: Center(child: SvgPicture.asset(Assets.backArrowIcon, width: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Text("Playground", style: TextStyle(fontWeight: FontWeight.w900, fontSize: context.sp(24), color: AppColors.appBarTitleDark, fontFamily: 'Jakarta')),
          const Spacer(),
          Consumer<ScoreProvider>(
            builder: (context, scoreProvider, child) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: AppColors.accentYellow, borderRadius: BorderRadius.circular(24)),
                child: Row(
                  children: [
                    Text("${scoreProvider.totalScore}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
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

  Widget _buildMascotGreeting() {
    return Column(
      children: [
        const Text("Hi there,\nLittle Explorer!", textAlign: TextAlign.center, style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.appBarTitleDark, height: 1.1, fontFamily: 'Jakarta')),
        const SizedBox(height: 4),
        const Text("What do you want to play today?", style: TextStyle(fontSize: 18, color: AppColors.mascotSubText)),
      ],
    );
  }

  Widget _buildButtonGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FirstScreen())),
            child: _build3DButton("GAMES", AppColors.gamesMain, AppColors.gamesShadow, Assets.games1Icon, 2, Colors.white.withValues(alpha: 0.20)),
          ),

          // Navigation to Learning Menu
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LearningMenu())),
            child: _build3DButton("LEARN", AppColors.learnMain, AppColors.learnShadow, Assets.learn1Icon, -2, Colors.white.withValues(alpha: 0.20)),
          ),

          // Navigation to Draw Screen
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DrawingCanvasScreen())),
            child: _build3DButton("DRAW", AppColors.drawMain, AppColors.drawShadow, Assets.draw1Icon, 2, Colors.black.withValues(alpha: 0.10)),
          ),

          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StoriesListPage())),
            child: _build3DButton("STORIES", AppColors.storiesMain, AppColors.storiesShadow, Assets.stories1Icon, -2, Colors.white.withValues(alpha: 0.40)),
          ),
        ],
      ),
    );
  }

  Widget _build3DButton(String title, Color topColor, Color shadowColor, String icon, double rot, Color overlayColor) {
    return Transform.rotate(
      angle: rot * math.pi / 180,
      child: Stack(
        children: [
          Container(decoration: BoxDecoration(color: shadowColor, borderRadius: BorderRadius.circular(32))),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(color: topColor, borderRadius: BorderRadius.circular(32)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(color: overlayColor, shape: BoxShape.circle),
                    child: Center(child: SvgPicture.asset(icon, width: 40)),
                  ),
                ),
                const SizedBox(height: 16),
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 24, letterSpacing: 0.6, fontFamily: 'Jakarta')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdventureLevelCard(BuildContext context) {
    return Container(
      width: context.w(342),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.adventureCardBg, borderRadius: BorderRadius.circular(32)),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("ADVENTURE LEVEL 3", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.adventureProgressDark)),
              Text("1 / 10", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(10, (i) => Container(
              width: 25, height: 25,
              decoration: BoxDecoration(
                color: i == 0 ? AppColors.adventureProgressDark : AppColors.adventureProgressGreen,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black.withValues(alpha: 0.12), width: 0.5),
              ),
            )),
          )
        ],
      ),
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
