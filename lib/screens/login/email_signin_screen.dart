import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/auth_controller.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/models/response/user_response_data.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/screens/forgot/forgot_password.dart';
import 'package:podcast_app/screens/main_screen.dart';
import 'package:podcast_app/utils/utility.dart';
import 'package:podcast_app/widgets/bg/gradient_bg.dart';
import 'package:podcast_app/widgets/bg/tomtom_title.dart';
import 'package:podcast_app/widgets/btns/stadiumButtons.dart';
import 'package:podcast_app/widgets/btns/wrap_text_btn.dart';

import 'login_screen.dart';

class EmailSignInScreen extends GetView<AuthController> {
  const EmailSignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            Container(
              /*decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: AssetImage('images/ob_bg.png'),
                      fit: BoxFit.cover)),*/
              decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.rectangle,
                  gradient: LinearGradient(
                      colors: [Color.fromARGB(255, 54, 0, 0), Colors.black],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.5])),
            ),
            const LinearGradientBg(),
            Column(
              children: [
                /* ClipPath(
                  clipper: CurvedClipper(),
                  child: Container(
                    height: 250,
                    width: double.infinity,
                    color: const Color.fromARGB(255, 186, 16, 19),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/ob_title.png',
                          width: 100,
                          height: 100,
                          scale: 2,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),*/
                const TomTomTitle(title: 'Login'),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Email Id',
                              style: TextStyle(color: Colors.white),
                            ),
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0)),
                              child: TextField(
                                autofocus: false,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                controller: controller.emailController,
                                style: const TextStyle(
                                    fontSize: 14.0,
                                    color: AppColors.phoneTextColor),
                                decoration: const InputDecoration(
                                  filled: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  border: InputBorder.none,
                                  fillColor: Colors.white,
                                  alignLabelWithHint: true,
                                  hintText: 'emailId',
                                  counterText: "",
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () {
                                  FocusManager.instance.primaryFocus
                                      ?.nextFocus();
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'Password',
                              style: TextStyle(color: Colors.white),
                            ),
                            Obx(
                              () => Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(4.0)),
                                    child: TextField(
                                      autofocus: false,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      controller: controller.passwordController,
                                      style: const TextStyle(
                                          fontSize: 14.0,
                                          color: AppColors.phoneTextColor),
                                      decoration: const InputDecoration(
                                        filled: true,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: InputBorder.none,
                                        fillColor: Colors.white,
                                        alignLabelWithHint: true,
                                        hintText: '******',
                                        counterText: "",
                                      ),
                                      obscureText: controller.showPassWord.value
                                          ? true
                                          : false,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.done,
                                      onEditingComplete: () {
                                        FocusScope.of(context).unfocus();
                                      },
                                    ),
                                  ),
                                  Positioned(
                                      right: 0,
                                      child: Material(
                                          color: Colors.transparent,
                                          child: Focus(
                                            onFocusChange: (hasFocus) {
                                              if (hasFocus) {
                                                FocusScope.of(context)
                                                    .nextFocus();
                                              }
                                            },
                                            child: IconButton(
                                              splashColor: Colors.grey.shade300,
                                              onPressed: () {
                                                // FocusScope.of(context).unfocus();
                                                controller
                                                    .togglePasswordVisibility();
                                              },
                                              icon: Icon(
                                                controller.showPassWord.value
                                                    ? Icons
                                                        .visibility_off_outlined
                                                    : Icons.visibility_outlined,
                                                color: AppColors.phoneTextColor,
                                              ),
                                            ),
                                          )))
                                ],
                              ),
                            ),
                            const SizedBox(height: 15,),
                            WrapTextButton(
                              title: 'Forgot Password',
                              textColor: AppColors.firstColor,
                              callback: () {

                                controller.phoneController.clear();

                                Get.to(const ForgotPasswordScreen());

                              },
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            StadiumButton(
                              callback: () {
                                if (validate(context)) {
                                  singIn(context);
                                }
                              },
                              title: 'SUBMIT',
                            )
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

  bool validate(BuildContext context) {
    if (controller.emailController.text.isEmpty ||
        !Utility.isValidEmail(controller.emailController.text.trim())) {
      AppDialogs.simpleOkDialog(
          context, 'Failed', 'please enter valid email address');
      return false;
    } else if (controller.passwordController.text.isNotEmpty &&
        controller.passwordController.text.length < 8) {
      AppDialogs.simpleOkDialog(
          context, 'Failed', 'Password must be at least 8 characters long.');
      return false;
    }
    /*else if (!Utility.isPasswordCompliant(
        controller.passwordController.text)) {
      AppDialogs.simpleOkDialog(context, 'Failed',
          'Password should have contain uppercase,lowercase, digits and specials characters');
      return false;
    }*/

    return true;
  }

  void singIn(BuildContext context) async {
    Map<String, dynamic> q = {
      "loginid": controller.emailController.text.trim(),
      "password": controller.passwordController.text
    };

    final response = await ApiService().emailSignIn(q);

    AppConstants.navigateToDashBoard(context, response);

    /*ResponseData responseData = ResponseData.fromJson(response);

    if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {


      UserResponseData userResponseData = UserResponseData.fromJson(responseData.response) ;

      print(userResponseData.id);

      Get.offAll(()=>const MainScreen());

    } else {
      AppDialogs.simpleOkDialog(context, 'Failed',
          responseData.response ?? "unable to process request");
    }*/
  }
}
