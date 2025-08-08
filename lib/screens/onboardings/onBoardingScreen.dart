import 'package:flutter/material.dart';
import 'package:peto/utils/image.dart';
import 'package:peto/utils/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:peto/screens/auth/loginScreen.dart';
import 'package:peto/screens/components/button.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController1 = PageController(initialPage: 0);
  final PageController _pageController2 = PageController(initialPage: 0);
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kOnBoardingColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Container(
            height: 10,
            width: 10,
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.kPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 5,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: onBoardinglist.length,
              physics: const BouncingScrollPhysics(),
              controller: _pageController1,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return OnBoardingCard(onBoardingModel: onBoardinglist[index]);
              },
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: DotsIndicator(
              dotsCount: onBoardinglist.length,
              position: _currentIndex.toDouble(),
              decorator: DotsDecorator(
                // ignore: deprecated_member_use
                color: AppColor.kPrimary.withOpacity(0.4),
                size: const Size.square(8.0),
                activeSize: const Size(20.0, 8.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                activeColor: AppColor.kPrimary,
              ),
            ),
          ),
          const SizedBox(height: 37),
          Expanded(
            flex: 2,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: onBoardinglist.length,
              physics: const BouncingScrollPhysics(),
              controller: _pageController2,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return OnboardingTextCard(
                  onBoardingModel: onBoardinglist[index],
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 23, bottom: 36),
            child: PrimaryButton(
              elevation: 0,
              onTap: () {
                if (_currentIndex == onBoardinglist.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                } else if (_currentIndex == 0) {
                  _pageController1.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                  );
                  _pageController2.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                  );
                } else {
                  _pageController1.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                  );
                  _pageController2.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                  );
                }
              },
              text:
                  _currentIndex == onBoardinglist.length - 1
                      ? 'Get Started'
                      : 'Next',
              bgColor: AppColor.kPrimary,
              borderRadius: 20,
              height: 46,
              width: 327,
              textColor: AppColor.kWhite,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class OnBoardingCard extends StatefulWidget {
  OnBoarding onBoardingModel;
  OnBoardingCard({super.key, required this.onBoardingModel});

  @override
  State<OnBoardingCard> createState() => _OnBoardingCardState();
}

class _OnBoardingCardState extends State<OnBoardingCard> {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      widget.onBoardingModel.image,
      height: 300,
      width: double.maxFinite,
      fit: BoxFit.fitWidth,
    );
  }
}

class OnboardingTextCard extends StatelessWidget {
  final OnBoarding onBoardingModel;
  const OnboardingTextCard({required this.onBoardingModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Column(
        children: [
          Text(
            onBoardingModel.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColor.kGrayscaleDark100,
            ).copyWith(fontSize: 24),
          ),
          const SizedBox(height: 16),
          Text(
            onBoardingModel.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.kWhite,
            ).copyWith(color: AppColor.kGrayscale40, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class OnBoarding {
  String title;
  String description;
  String image;

  OnBoarding({
    required this.title,
    required this.description,
    required this.image,
  });
}

List<OnBoarding> onBoardinglist = [
  OnBoarding(
    title: ' Can be accessed from anywhere at any time',
    image: ImagesPath.kOnboarding1,
    description:
        'The essential language learning tools and resources you need to seamlessly transition into mastering a new language',
  ),
  OnBoarding(
    title: 'Offers a dynamic and interactive experience',
    image: ImagesPath.kOnboarding2,
    description:
        'Engaging features including test, story telling, and conversations that motivate and inspire language learners to unlock their full potential',
  ),
  OnBoarding(
    title: "Experience the Premium Features with Our App",
    image: ImagesPath.kOnboarding3,
    description:
        'Updated TalkGpt with premium materials and a dedicated following, providing language learners with immersive content for effective learning',
  ),
];
