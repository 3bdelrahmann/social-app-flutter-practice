import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/colors.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController onBoardingController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'assets/images/welcoming.svg',
      title: 'diam in arcu',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    ),
    BoardingModel(
      image: 'assets/images/social_interaction.svg',
      title: 'diam in arcu',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    ),
  ];

  bool isLast = false;

  void submit() {
    CacheHelper.saveData(
      key: 'onBoarding',
      value: true,
    ).then((value) {
      if (value) {
        navigateTo(
          context: context,
          newRoute: LoginScreen(),
          backRoute: false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          defaultTextButton(
              onPressed: () {
                submit();
              },
              text: 'skip')
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: onBoardingController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  SmoothPageIndicator(
                    controller: onBoardingController,
                    count: boarding.length,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 10.0,
                      dotWidth: 10.0,
                      spacing: 5.0,
                      activeDotColor: kMainColor,
                    ),
                  ),
                  const Spacer(),
                  roundIconButton(
                    iconColor: Colors.white,
                    icon: Icons.arrow_forward_ios,
                    onPressed: () {
                      if (isLast == true) {
                        submit();
                      } else {
                        onBoardingController.nextPage(
                          duration: const Duration(milliseconds: 750),
                          curve: Curves.fastLinearToSlowEaseIn,
                        );
                      }
                    },
                    color: kMainColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  model.image,
                ),
              ),
            ),
            Text(
              model.title,
              style: const TextStyle(
                fontSize: 24.0,
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Text(
              model.body,
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
          ],
        ),
      );
}
