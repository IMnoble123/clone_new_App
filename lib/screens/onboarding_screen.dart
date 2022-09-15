import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:podcast_app/extras/keys.dart';
import 'package:podcast_app/screens/home_screen.dart';
import 'package:podcast_app/screens/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final pageController = PageController();

  var currentPage = 0;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=> Future<bool>.value(false),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              PageView(
                controller: pageController,
                onPageChanged: (i){
                  currentPage = i;
                  setState(() {

                  });
                },
                /*children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 50),
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: AssetImage('images/ob_bg.png'),
                            fit: BoxFit.cover)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'images/ob_title.png',
                          scale: 2,
                        ),
                        Image.asset(
                          'images/ob_pic_1.png',
                          scale: 2,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: const Color.fromARGB(255, 186, 16, 19),
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'images/ob_title.png',
                          scale: 2,
                        ),
                        Image.asset(
                          'images/ob_pic_2.png',
                          scale: 2,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 100,
                                height: 0.5,
                                child: Divider(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                'మేమ్ కతల్ పడం, చెప్తం!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 222, 208, 208)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: const Color.fromARGB(255, 186, 16, 19),
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'images/ob_title.png',
                          scale: 2,
                        ),
                        Image.asset(
                          'images/ob_pic_3.png',
                          scale: 2,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 100,
                                height: 0.5,
                                child: Divider(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                'Cheers to learning something new today!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 222, 208, 208)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],*/

                children: [
                  Image.asset('images/ob_new_1.png',fit: BoxFit.cover,),
                  Image.asset('images/ob_new_2.png',fit: BoxFit.cover,),
                  Image.asset('images/ob_new_3.png',fit: BoxFit.cover,),
                ],
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () async{

                              final prefs = await SharedPreferences.getInstance();
                              prefs.setBool(AppKeys.SHOW_ON_BOARD, true);

                              //pageController.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
                              Get.to(const LoginScreen());
                            },
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w500),
                            )),
                        Center(
                            child: SmoothPageIndicator(
                                effect: SlideEffect(
                                    activeDotColor: Colors.white,
                                    dotColor: Colors.white.withOpacity(0.3),
                                    dotWidth: 10,
                                    dotHeight: 10),
                                controller: pageController,
                                onDotClicked: (index){
                                  pageController.jumpToPage(index);
                                },
                                count: 3)),
                        TextButton(
                            onPressed: currentPage==2?() async{
                              // Get.to(LoginScreen());
                              final prefs = await SharedPreferences.getInstance();
                              prefs.setBool(AppKeys.SHOW_ON_BOARD, true);

                              Get.to(const LoginScreen());
                              // Get.to(const HomeScreen());

                            }:() {
                              pageController.nextPage(duration: const Duration(milliseconds: 100), curve: Curves.ease);
                            },
                            child: Text(
                              currentPage==2?'Done':'Next',
                              style: const TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w500),
                            )),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
