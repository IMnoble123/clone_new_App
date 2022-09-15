import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/screens/splash_screen.dart';

import 'login/login_screen.dart';
import 'main/main_page.dart';

class DummyScreen extends StatelessWidget {
  final bool userLogin;

  const DummyScreen({Key? key, required this.userLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.height != 0
        ? SplashScreen(callback: () {
            if (userLogin) {
              Get.to(const MainPage());
            } else {
              Get.to(const LoginScreen());
            }
          })
        : const SizedBox.shrink();
  }
}
