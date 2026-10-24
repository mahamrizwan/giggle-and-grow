import '../../../../core/constant/assets.dart';

class OnboardingContent {
  final String image;
  final String title;
  final String description;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

// This list contains the data for all 3 steps
List<OnboardingContent> onboardingSteps = [
  OnboardingContent(
    image: Assets.step1Image,
    title: "Play Fun\nGames!",
    description: "Explore a world of wonder where\nevery tap leads to a new discovery.",
  ),
  OnboardingContent(
    image: Assets.step2Image,
    title: "Enjoy Magical\nStories!",
    description: "Dive into adventures that spark\nimagination and creativity.",
  ),
  OnboardingContent(
    image: Assets.step3Image,
    title: "Draw & Color Fun",
    description: "Dive into adventures that spark\nimagination and creativity.",
  ),
];