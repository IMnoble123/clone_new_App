import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/share_prefs.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/screens/login/login_screen.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/widgets/btns/stadium_buttons.dart';

class LogOutScreen extends StatelessWidget {
  const LogOutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(
                width: 150,
                child: Divider(
                  color: AppColors.disableColor,
                )),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Are  you sure you want to logout of the TOMTOM?',
              style:
                  TextStyle(color: AppColors.textSecondaryColor, fontSize: 14),
            ),
            const SizedBox(
              height: 10,
            ),
            StadiumButton(
              callback: () {
                AppSharedPreference().saveStringData(AppConstants.USER_ID, "");
                AppSharedPreference()
                    .saveBoolData(AppConstants.IS_USER_LOGED_IN, false)
                    .then((value) async {
                  /* Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (c) => const LoginScreen()),
                      (route) => false);*/

                  // TomTomApp.restartApp(context);

                  /*Navigator.pushAndRemoveUntil(
                      context,
                      ModalRoute.withName("/Home")
                  );*/

                  // Get.offAll(const LoginScreen());

                  //Get.off(const LoginScreen());
                  //Get.clearRouteTree();

                  try {
                    final GoogleSignIn googleSignIn = GoogleSignIn();
                    bool isSignIn = await googleSignIn.isSignedIn();
                    if (isSignIn) {
                      await googleSignIn.signOut();
                    }

                    await FirebaseAuth.instance.signOut();
                  } catch (e) {
                    print(e.toString());
                  }

                  CommonNetworkApi().mobileUserId = "";

                  // await Get.find<MainController>().player.stop();
                  // await Get.find<MainController>().player.dispose();
                  Get.find<MainController>().tomtomPlayer.dispose();
                  MainPage.isFirstBuild = true;
                  await Get.delete<MainController>(force: true)
                      .then((value) => Get.offAll(const LoginScreen()));

                  // Get.find<AuthController>().allowUserToSignOut();

                  //Get.reset();

                  /*Get.deleteAll(force: true).then((value) => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (c) => const LoginScreen()),
                          (route) => false));*/

                  //TomTomApp.restartApp(context);
                  //Get.to(const LoginScreen());
                  //Get.offUntil(  MaterialPageRoute(builder: (c) => const LoginScreen()), (route) => false);
                });
              },
              title: CommonNetworkApi().mobileUserId != "-1"
                  ? 'Logout'
                  : "Register",
              bgColor: AppColors.firstColor,
            ),
            /*MaterialButton(
              onPressed: () {},
              shape: const StadiumBorder(),
              color: AppColors.firstColor,
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
