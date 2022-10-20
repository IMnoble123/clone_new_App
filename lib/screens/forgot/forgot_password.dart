import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/auth_controller.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/countries_data.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/screens/login/otp_screen.dart';
import 'package:podcast_app/widgets/bg/gradient_bg.dart';
import 'package:podcast_app/widgets/btns/stadium_buttons.dart';
import '../../extras/app_colors.dart';
import '../../widgets/bg/tomtom_title.dart';

class ForgotPasswordScreen extends GetView<AuthController> {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

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
                            const Text(
                              'Mobile Number',
                              style: TextStyle(color: Colors.white),
                            ),
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0)),
                              child: TextField(
                                autofocus: false,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                controller: controller.phoneController,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                style: const TextStyle(
                                    fontSize: 14.0,
                                    color: AppColors.phoneTextColor),
                                decoration: InputDecoration(
                                    filled: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    border: InputBorder.none,
                                    fillColor: Colors.white,
                                    alignLabelWithHint: true,
                                    hintText: 'phoneNumber',
                                    counterText: "",
                                    prefixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        const Icon(
                                          Icons.phone_android,
                                          color: AppColors.phoneTextColor,
                                          size: 20,
                                        ),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        'Countries List',
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .firstColor),
                                                      ),
                                                      content:
                                                          setupAlertDialoadContainer(
                                                              context),
                                                    );
                                                  }).then((value) {
                                                if (value != null) {
                                                  controller.selectedContryCode
                                                      .value = value;
                                                }
                                              });
                                            },
                                            child: Obx(
                                              () => Text(
                                                controller
                                                    .selectedContryCode.value,
                                                style: const TextStyle(
                                                    color: AppColors
                                                        .phoneTextColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          height: 20,
                                          width: 1,
                                          color: AppColors.phoneTextColor,
                                        )
                                      ],
                                    )),
                                keyboardType: Platform.isAndroid
                                    ? TextInputType.number
                                    : const TextInputType.numberWithOptions(
                                        signed: true, decimal: true),
                                maxLength: 10,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () {
                                  FocusManager.instance.primaryFocus
                                      ?.nextFocus();
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            StadiumButton(
                              callback: () {
                                if (validate(context)) {
                                  sendOtp(context);
                                }
                              },
                              title: 'Send OTP',
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

  Widget setupAlertDialoadContainer(BuildContext context) {
    List<Country> countries = controller.countriesList;
    return SizedBox(
      height: MediaQuery.of(context).size.width /
          2, // Change as per your requirement
      width: MediaQuery.of(context).size.height /
          2, // Change as per your requirement
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: countries.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title:
                Text('${countries[index].dialcode}  ${countries[index].name}'),
            onTap: () {
              Navigator.of(context).pop(countries[index].dialcode);
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 1,
            color: Colors.black45.withOpacity(0.5),
          );
        },
      ),
    );
  }

  void sendOtp(BuildContext context) async {
    String mobileNumber =
        controller.selectedContryCode + controller.phoneController.text;

    Map<String, String> q = {"mobile": mobileNumber};

    final res = await ApiService().sendOtp(q);

    try {
      ResponseData responseData = ResponseData.fromJson(res);

      print(responseData.toJson());

      if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
        Get.to(OtpScreen(
          mobileNumber: mobileNumber,
          isFromForgot: true,
        ));
      } else {
        AppDialogs.simpleOkDialog(context, 'Failed',
            responseData.response ?? "unable to process request");
      }
    } catch (e) {
      print(e);
    }
  }

  bool validate(BuildContext context) {
    if (controller.phoneController.text.isEmpty ||
        controller.phoneController.text.length < 8) {
      AppDialogs.simpleOkDialog(
          context, 'Failed', 'please enter valid mobile number.');
      return false;
    }

    return true;
  }
}
