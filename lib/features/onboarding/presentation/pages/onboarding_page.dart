import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/constant/assets.dart';
import '../../../../core/constant/colors.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../dashboard/presentation/pages/home_dashboard.dart';
import '../onboarding_model.dart';
import '../widgets/onboarding_body.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentIndex = 0;

  // Navigation logic: Replaces onboarding with dashboard
  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeDashboard()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.bgLightBlue, AppColors.bgSoftBlue],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // SKIP Button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: context.w(20), top: context.h(10)),
                  child: TextButton(
                    onPressed: _navigateToDashboard, // Logic added here
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.skipButtonBg,
                      padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                      shape: const StadiumBorder(),
                    ),
                    child: Text("SKIP",
                        style: TextStyle(
                            color: AppColors.skipText,
                            fontSize: context.sp(14),
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),

              // Content Body
              Expanded(
                child: OnboardingBody(
                  content: onboardingSteps[currentIndex],
                  currentIndex: currentIndex,
                ),
              ),

              // NEXT Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(40)),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (currentIndex < 2) {
                        currentIndex++;
                      } else {
                        _navigateToDashboard(); // Logic added here for 3rd click
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.nextButtonGreen,
                    minimumSize: Size(double.infinity, context.h(60)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.w(30))),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          currentIndex == 2 ? "GET STARTED" : "NEXT", // Dynamic text
                          style: TextStyle(
                              fontSize: context.sp(24),
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      SizedBox(width: context.w(10)),
                      SvgPicture.asset(
                        Assets.halfArrowIcon,
                        width: 25,
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ),

              // Step Text
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.h(20)),
                child: Text(
                  "STEP ${currentIndex + 1} OF 3",
                  style: TextStyle(
                      color: const Color(0XFF00576E),
                      fontWeight: FontWeight.normal,
                      fontSize: context.sp(14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}