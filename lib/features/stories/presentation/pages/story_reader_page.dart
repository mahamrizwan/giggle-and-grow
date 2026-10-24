import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/assets.dart';
import '../../../../core/constant/colors.dart';
import '../../../dashboard/presentation/provider/score_provider.dart';
class StoryReaderPage extends StatefulWidget {
  final int storyId;
  const StoryReaderPage({super.key, required this.storyId});

  @override
  State<StoryReaderPage> createState() => _StoryReaderPageState();
}

class _StoryReaderPageState extends State<StoryReaderPage> {
  int _currentSlide = 0;

  final Map<int, List<Map<String, String>>> _storyContent = {
    0: [
      {"img": Assets.fox1, "text": "A little fox wanted to explore the big forest."},
      {"img": Assets.fox2, "text": "He walked far and saw tall trees and rivers."},
      {"img": Assets.fox3, "text": "Suddenly, he heard a loud scary sound!"},
      {"img": Assets.fox4, "text": "He stayed brave and followed the sound."},
      {"img": Assets.fox5, "text": "It was just friendly birds—he smiled happily!"},
    ],
    1: [
      {"img": Assets.beach1, "text": "A boy went to the beach on a sunny day."},
      {"img": Assets.beach2, "text": "He built a big sandcastle by the shore."},
      {"img": Assets.beach3, "text": "Waves came and splashed water everywhere!"},
      {"img": Assets.beach4, "text": "He played with shells and chased tiny crabs."},
      {"img": Assets.beach5, "text": "He went home tired but very happy."},
    ],
    2: [
      {"img": Assets.sky1, "text": "A little star felt lonely in the sky."},
      {"img": Assets.sky2, "text": "It looked down and saw a small child."},
      {"img": Assets.sky3, "text": "Every night, they smiled at each other."},
      {"img": Assets.sky4, "text": "They became best friends forever."},
      {"img": Assets.sky5, "text": "The child slept peacefully under the star."},
    ],
    3: [
      {"img": Assets.rain1, "text": "A rainbow loved to play funny tricks."},
      {"img": Assets.rain2, "text": "It changed colors again and again!"},
      {"img": Assets.rain3, "text": "It made the clouds laugh loudly."},
      {"img": Assets.rain4, "text": "Rain turned into colorful drops!"},
      {"img": Assets.rain5, "text": "Everyone laughed at the silly rainbow."},
    ],
  };

  @override
  Widget build(BuildContext context) {
    var slides = _storyContent[widget.storyId] ?? _storyContent[0]!;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Full Page Background Image
          Positioned.fill(
            child: Image.asset(
              slides[_currentSlide]['img']!,
              fit: BoxFit.cover,
            ),
          ),

          // 2. Custom AppBar (Matches exactly with list page style)
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              height: 125,
              padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
              decoration: BoxDecoration(
                color: AppColors.appBarGreen,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [
                  // Logo Circle
                  Container(
                    width: 44, height: 44,
                    decoration: const BoxDecoration(color: AppColors.accentYellow, shape: BoxShape.circle),
                    child: Center(child: SvgPicture.asset(Assets.logoIcon, width: 24)),
                  ),
                  const SizedBox(width: 12),
                  // Title: Same size and color as List Page
                  const Text(
                      "Giggle &\nGrow",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        color: AppColors.navBarTextActive,
                        fontFamily: 'Jakarta',
                        height: 1.1,
                      )
                  ),
                  const Spacer(),
                  // Real-time Star Count Container
                  Consumer<ScoreProvider>(
                    builder: (context, scoreProvider, child) {
                      return Container(
                        width: 65, height: 65, // Circular pill shape
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${scoreProvider.totalScore}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black)),
                            const SizedBox(width: 4),
                            SvgPicture.asset(Assets.goldIcon, width: 20),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  // Exit Cross Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 48, height: 48,
                      decoration: const BoxDecoration(color: AppColors.exitCircleRed, shape: BoxShape.circle),
                      child: Center(child: SvgPicture.asset(Assets.crossButtonIcon, width: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Middle Navigation Buttons
          _buildNavButton(left: 20, isForward: false),
          _buildNavButton(right: 20, isForward: true),

          // 4. Transparent Text Container & Indicators
          Positioned(
            bottom: 40, left: 24, right: 24,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1),
                  ),
                  child: Text(
                    slides[_currentSlide]['text']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Jakarta',
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: AppColors.storyTextDark,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildWaveIndicators(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({double? left, double? right, required bool isForward}) {
    bool canMove = isForward ? _currentSlide < 4 : _currentSlide > 0;
    return Positioned(
      left: left, right: right, top: 410,
      child: GestureDetector(
        onTap: () {
          if (canMove) setState(() => isForward ? _currentSlide++ : _currentSlide--);
        },
        child: Opacity(
          opacity: canMove ? 1.0 : 0.4,
          child: Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: isForward ? AppColors.accentYellow : const Color(0xFF04647D),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: Icon(
              isForward ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWaveIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        bool isCurrent = _currentSlide == index;
        bool isPast = index < _currentSlide;
        double yOffset = (index == 3) ? -8.0 : 0.0; // Creating the Wave Peak at the 4th dot

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Transform.translate(
            offset: Offset(0, yOffset),
            child: Container(
              width: isCurrent ? 20 : 14,
              height: isCurrent ? 20 : 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCurrent
                    ? const Color(0xFF00FF00) // Bright Active Green
                    : (isPast ? const Color(0xFF04647D) : const Color(0xFFAED59E)),
                border: isCurrent ? Border.all(color: Colors.white, width: 2) : null,
              ),
            ),
          ),
        );
      }),
    );
  }
}