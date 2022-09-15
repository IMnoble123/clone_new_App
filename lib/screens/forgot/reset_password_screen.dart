import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/auth_controller.dart';
import 'package:podcast_app/controllers/reset_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/screens/forgot/reset_success_screen.dart';
import 'package:podcast_app/widgets/bg/gradient_bg.dart';
import 'package:podcast_app/widgets/bg/tomtom_title.dart';
import 'package:podcast_app/widgets/btns/stadiumButtons.dart';

class ResetPassword extends GetView<ResetPasswordController> {
  final String mobileNumber;
  final String resetToken;

  const ResetPassword({
    Key? key,
    required this.mobileNumber,
    required this.resetToken,
  }) : super(key: key);

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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'New Password',
                              style: TextStyle(color: Colors.white),
                            ),
                            Obx(
                              () => Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4.0)),
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
                                                controller.showPassWord.value =
                                                    !controller
                                                        .showPassWord.value;
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
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'Confirm New Password',
                              style: TextStyle(color: Colors.white),
                            ),
                            Obx(
                              () => Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4.0)),
                                    child: TextField(
                                      autofocus: false,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      controller:
                                          controller.confirmPasswordController,
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
                                      obscureText:
                                          controller.showConfirmPassWord.value
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
                                                controller.showConfirmPassWord
                                                        .value =
                                                    !controller
                                                        .showConfirmPassWord
                                                        .value;
                                              },
                                              icon: Icon(
                                                controller.showConfirmPassWord
                                                        .value
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
                            const SizedBox(
                              height: 25,
                            ),
                            StadiumButton(
                              callback: () {
                                if (validate(context)) {
                                  resetPassword(context);
                                }
                              },
                              title: 'Reset',
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

  bool validate(BuildContext context) {
    if (controller.passwordController.text.isNotEmpty &&
        controller.passwordController.text.length < 8) {
      AppDialogs.simpleOkDialog(
          context, 'Failed', 'Password must be at least 8 characters long.');
      return false;
    } else if (controller.confirmPasswordController.text.isNotEmpty &&
        controller.confirmPasswordController.text.length < 8) {
      AppDialogs.simpleOkDialog(context, 'Failed',
          'New Password must be at least 8 characters long.');
      return false;
    } else if (controller.passwordController.text !=
        controller.confirmPasswordController.text) {
      AppDialogs.simpleOkDialog(context, 'Failed',
          'New password and confirm passwords should be same.');
      return false;
    }

    return true;
  }

  void resetPassword(BuildContext context) async {
    final res = await ApiService().postData(
        ApiKeys.RESET_PASSWORD_SUFFIX,
        ApiKeys.getResetPasswordQuery(
            mobileNumber, controller.passwordController.text,resetToken));

    try {
      ResponseData responseData = ResponseData.fromJson(res);

      if (responseData.status == "Success") {
        Get.to(const ResetSuccessScreen());
      } else {
        AppDialogs.simpleOkDialog(context, 'Failed',
            responseData.response ?? "unable to process request");
      }
    } catch (e) {
      print(e);
    }
  }
}
