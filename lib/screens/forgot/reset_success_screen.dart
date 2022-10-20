import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/screens/login/login_screen.dart';
import 'package:podcast_app/widgets/bg/gradient_bg.dart';
import 'package:podcast_app/widgets/bg/tomtom_title.dart';
import 'package:podcast_app/widgets/btns/stadium_buttons.dart';

class ResetSuccessScreen extends StatelessWidget {
  const ResetSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Stack(
          children: [

            const LinearGradientBg(),
            Column(
              children: [
                const TomTomTitle(title: 'Forgot Password'),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [


                            const Text(
                              'Congratulations!, Password updated.',textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),

                            const SizedBox(
                              height: 50,
                            ),
                            StadiumButton(
                              callback: () {
                                  Get.offAll(const LoginScreen());
                              },
                              title: 'LOGIN',
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
