import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constant/assets.dart';
import '../../../../core/constant/colors.dart';
import '../../../../core/utils/size_extension.dart';
import '../onboarding_model.dart';

class OnboardingBody extends StatelessWidget {
  final OnboardingContent content;
  final int currentIndex;

  const OnboardingBody({
    super.key,
    required this.content,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. BACKGROUND BLURS
          Positioned(
            top: context.h(-100),
            right: context.w(-86),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
              child: Container(
                width: context.w(384),
                height: context.h(384),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFD709).withValues(alpha: 0.2),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: context.h(-200),
            left: context.w(-60),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                width: context.w(350),
                height: context.h(350),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFF8BC0).withValues(alpha: 0.25),
                ),
              ),
            ),
          ),

          // 2. TOP GROUP (STATIC FRAME + DYNAMIC IMAGE)
          Positioned(
            top: context.h(25),
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // YELLOW STAR (Static Position)
                  Positioned(
                    right: context.w(-34),
                    bottom: context.h(-25),
                    child: Container(
                      width: context.w(75),
                      height: context.h(75),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFD709),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          Assets.starIcon,
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  ),

                  // THE WHITE BOX (Size locked: 308x300)
                  Container(
                    width: context.w(308),
                    height: context.h(300),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(context.w(48)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(context.w(32)),
                      child: Image.asset(
                        content.image, // DYNAMIC IMAGE
                        width: context.w(280),
                        height: context.h(280),
                        fit: BoxFit.cover,
                        // GaplessPlayback prevents the "disappearing" blink when changing images
                        gaplessPlayback: true,
                      ),
                    ),
                  ),

                  // PINK MASCOT (Static Position)
                  Positioned(
                    left: context.w(5),
                    top: context.h(62),
                    child: Transform.rotate(
                      angle: -8 * math.pi / 180,
                      child: Container(
                        width: context.w(80),
                        height: context.h(80),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF8BC0),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Image.asset("assets/images/mascot1.png", width: 65, height: 65),
                        ),
                      ),
                    ),
                  ),

                  // LET'S GO BUBBLE (Static Position)
                  Positioned(
                    top: context.h(2),
                    left: context.w(2),
                    child: Transform.rotate(
                      angle: -6 * math.pi / 180,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.w(13),
                            vertical: context.h(15)
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                        ),
                        child: const Text(
                          "Let's go!",
                          style: TextStyle(
                            color: Color(0xFFA8216E),
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Jakarta',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. BOTTOM GROUP (DYNAMIC TEXT)
          Positioned(
            bottom: context.h(39),
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  content.title, // DYNAMIC TITLE
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: context.sp(45),
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Jakarta',
                    color: AppColors.primaryDark,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: context.h(10)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(40)),
                  child: Text(
                    content.description, // DYNAMIC DESCRIPTION
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.sp(16),
                      color: AppColors.secondaryText,
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(height: context.h(30)),
                // INDICATORS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    bool isCurrent = currentIndex == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 13,
                      width: isCurrent ? 40 : 10,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppColors.indicatorYellow
                            : Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}