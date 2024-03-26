import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mytime/constants/assets.dart';
import 'package:mytime/features/authentication/landing/landing_page.dart';
import 'package:mytime/theme/colours.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // Ensures content stays within usable screen area, avoids notches/system UI
      child: IntroductionScreen(
        globalBackgroundColor: Pallete.secondaryColour,
        // Sets background color for screens
        pages: [
          // Each PageViewModel represents a screen in the onboarding sequence
          PageViewModel(
            title: 'Welcome to myTime',
            body:
                'Your hub for connecting with like-minded people who care about the planet. Share eco-friendly tips, find local sustainability events, and build a community dedicated to a greener future.',
            // Welcome message
            image: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Image.asset(Assets.appLogo) // Displays app logo
                ),
          ),
          PageViewModel(
            title: 'Find Your Eco-Tribe',
            body:
                'Connect with individuals who share your passion for sustainability. Discuss ideas, get support, and build meaningful relationships.',
            // Community-related message
            image: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Image.asset(Assets.onBoardingImage1)),
          ),
          PageViewModel(
            title: 'Your Sustainability Toolkit',
            body:
                'Explore tips, resources, and the latest news in sustainable living. Get inspired to make positive changes in your daily life.',
            // Resources-related message
            image: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Image.asset(Assets.onBoardingImage2)),
          ),
        ],
        onDone: () {
          //  Called when the 'Done' button is tapped
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) =>
                  const LandingPage())); // Navigates to LandingPage
        },
        showSkipButton: true,
        // Displays a 'Skip' button
        skip: const Text("Skip"),
        // Customises the 'Skip' button text
        next: const Icon(Icons.arrow_forward),
        // Icon for 'Next' button
        done: const Text("Done",
            style: TextStyle(
                fontWeight: FontWeight.bold)), // Customizes 'Done' button
      ),
    );
  }
}
