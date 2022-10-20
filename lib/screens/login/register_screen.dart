import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:podcast_app/controllers/auth_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/request/user_data.dart';
import 'package:podcast_app/models/response/countries_data.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/screens/tc/terms_conditions.dart';
import 'package:podcast_app/utils/utility.dart';
import 'package:podcast_app/widgets/bg/gradient_bg.dart';
import 'package:podcast_app/widgets/bg/tomtom_title.dart';
import 'package:podcast_app/widgets/btns/stadium_buttons.dart';
import 'package:podcast_app/widgets/btns/wrap_text_btn.dart';

import '../../controllers/countries_controller.dart';
import 'countries_list.dart';
import 'login_screen.dart';
import 'otp_screen.dart';

class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({Key? key}) : super(key: key);

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
            /*Container(
              decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: AssetImage('images/ob_bg.png'),
                      fit: BoxFit.cover)),
            ),*/
            const LinearGradientBg(),
            Column(
              children: [
                const TomTomTitle(title: 'Sign up'),
                /*ClipPath(
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
                            'Register',
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
                              'Name',
                              style: TextStyle(color: Colors.white),
                            ),
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0)),
                              child: TextField(
                                autofocus: false,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                controller: controller.nameController,
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
                                  hintText: 'Your Name',
                                  counterText: "",
                                ),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () {
                                  FocusManager.instance.primaryFocus
                                      ?.nextFocus();
                                },
                              ),
                            ),
                            /* TextField(
                              autofocus: false,
                              controller: controller.nameController,
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  color: AppColors.phoneTextColor),
                              decoration: InputDecoration(
                                filled: true,
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                hintText: 'Username',
                                contentPadding: const EdgeInsets.all(8.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                FocusManager.instance.primaryFocus?.nextFocus();
                              },
                            ),*/
                            const SizedBox(
                              height: 15,
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
                                  hintText: 'Email',
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
                            /*TextField(
                              autofocus: false,
                              controller: controller.emailController,
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  color: AppColors.phoneTextColor),
                              decoration: InputDecoration(
                                filled: true,
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                hintText: 'emailId',
                                contentPadding: const EdgeInsets.all(8.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                FocusManager.instance.primaryFocus?.nextFocus();
                              },
                            ),*/
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'Phone Number',
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
                                    hintText: 'Mobile number',
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
                                              /*showDialog(
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
                                              });*/

                                              Get.put(CountriesController());

                                              Get.find<CountriesController>().clearSearch();
                                              Get.find<CountriesController>().fetchCountries();

                                              Get.to(const CountriesList())!.then((value) {
                                                if (value != null) {
                                                  controller.selectedContryCode
                                                      .value = value;
                                                };
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
                              height: 15,
                            ),
                            const Text(
                              'DOB',
                              style: TextStyle(color: Colors.white),
                            ),
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0)),
                              child: TextField(
                                autofocus: false,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                controller: controller.dobController,
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                      mask: "## ## #### ",
                                      filter: {"#": RegExp(r'[0-9]')})
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
                                    hintText: 'DD MM YYYY',
                                    counterText: "",

                                    //contentPadding: const EdgeInsets.all(8.0),

                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          _showDatePicker(context);
                                        },
                                        icon: const Icon(
                                          Icons.calendar_today_rounded,
                                          color: AppColors.phoneTextColor,
                                        ))),
                                keyboardType: Platform.isAndroid
                                    ? TextInputType.number
                                    : const TextInputType.numberWithOptions(
                                        signed: true, decimal: true),
                                maxLength: 10,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () {
                                  FocusManager.instance.primaryFocus
                                      ?.nextFocus();
                                  /*SystemChrome.setEnabledSystemUIMode(
                                      SystemUiMode.immersiveSticky);*/
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
                            const SizedBox(
                              height: 5,
                            ),
                            Transform.translate(
                              offset: const Offset(-10, 0),
                              child: Row(
                                children: [
                                  Obx(() => Theme(
                                        data: Theme.of(context).copyWith(
                                          unselectedWidgetColor: Colors.white,
                                        ),
                                        child: Checkbox(
                                          value: controller.agreeChecked.value,
                                          onChanged: (b) {
                                            controller.agreeChecked.value = b!;
                                          },
                                        ),
                                      )),
                                  Flexible(
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'I agree to the ',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.white),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Terms & Conditions',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.firstColor),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Get.to(
                                                    const TermsAndConditionsScreen(
                                                  title: 'Terms & Conditions',
                                                  url:
                                                      'https://www.tomtompodcast.com/mterms.html',
                                                ));
                                              },
                                          ),
                                          const TextSpan(text: ' and '),
                                          TextSpan(
                                            text: 'Privacy Policies',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.firstColor),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Get.to(
                                                    const TermsAndConditionsScreen(
                                                  title: 'Privacy Policies',
                                                  url:
                                                      'https://www.tomtompodcast.com/mprivacy.html',
                                                ));
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  /*Flexible(
                                    child: Wrap(

                                      children: [
                                        const Text(
                                          "I agree to the ", textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        const WrapTextButton(
                                            title: 'Terms & Conditions'),
                                        const Text(
                                          " and ",  textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        const WrapTextButton(
                                            title: 'Terms & Conditions'),
                                      ],
                                    ),
                                  ),*/
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Obx(
                              () => MaterialButton(
                                onPressed: () {
                                  if (!controller.agreeChecked.value) return;

                                  if (validate(context)) {
                                    register(context);
                                  }
                                },
                                color: controller.agreeChecked.value
                                    ? AppColors.firstColor
                                    : AppColors.disableColor,
                                shape: const StadiumBorder(),
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),

                            /*Obx(
                              ()=> StadiumButton(
                                callback: () {
                                  if (validate(context)) {
                                    register(context);
                                  }
                                },
                                title: 'Register',
                              ),
                            ),*/
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
    if (controller.nameController.text.isEmpty) {
      AppDialogs.simpleOkDialog(context, 'Failed', 'please enter username');
      return false;
    } else if (controller.emailController.text.isEmpty ||
        !Utility.isValidEmail(controller.emailController.text)) {
      AppDialogs.simpleOkDialog(
          context, 'Failed', 'please enter valid email address');
      return false;
    } else if (controller.phoneController.text.isEmpty ||
        controller.phoneController.text.length < 8) {
      AppDialogs.simpleOkDialog(
          context, 'Failed', 'please enter valid mobile number.');
      return false;
    } else if (controller.dobController.text.isEmpty ||
        controller.dobController.text.length != 10 ||
        !Utility.isValidDob(controller.dobController.text, " ")) {
      AppDialogs.simpleOkDialog(
          context, 'Failed', 'please enter proper date of birth');
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

  void register(BuildContext context) async {
    UserData userData = UserData(
        name: controller.nameController.text,
        email: controller.emailController.text,
        mobile: controller.selectedContryCode.value +
            controller.phoneController.text,
        dob: getServerDate(controller.dobController.text),
        password: controller.passwordController.text);

    final response = await ApiService().registerUser(userData.toJson());

    print(response);

    ResponseData responseData = ResponseData.fromJson(response);

    if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
      /* CommonNetworkApi()
          .sendOtp(context, controller.phoneController.text,
              isDialogRequired: false)
          .then((value) => showAppDialog(context));*/

      //Get.to(OtpScreen(mobileNumber: controller.phoneController.text));

      try {
        FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: controller.emailController.text.trim(),
            password: controller.passwordController.text);
      } catch (e) {
        print(e);
      }

      AppDialogs.simpleOkDialog(context, 'Success',
              "Congratulations, Your account has been successfully created")
          .then((value) {
        controller.emailController.clear();
        controller.passwordController.clear();
        controller.phoneController.clear();
        controller.dobController.clear();
        controller.nameController.clear();

        Get.back();
      });
    } else {
      AppDialogs.simpleOkDialog(context, 'Failed',
          responseData.response ?? "unable to process request");
    }
  }

  String getServerDate(String input) {
    var inputFormat = DateFormat('dd MM yyyy');
    var inputDate = inputFormat.parse(input); // <-- dd/MM 24H format

    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  showAppDialog(BuildContext context) {
    AppDialogs.simpleOkDialog(context, 'Success',
            'Otp has been sent to registered mobile number.')
        .then((value) =>
            Get.to(OtpScreen(mobileNumber: controller.phoneController.text)));
  }

  void _showDatePicker(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context);
    }
  }

  buildMaterialDatePicker(BuildContext context) async {
    DateTime today = DateTime.now();

    final DateTime? dateTime = await showDatePicker(
        context: context,
        //firstDate: DateTime(1950),
        firstDate: DateTime(today.year - controller.maximumAge),
        initialDate: DateTime(
            today.year - controller.minimumAge, today.month, today.day),
        // initialDate: DateTime.now(),
        //initialDatePickerMode: DatePickerMode.year,
        lastDate: DateTime(
            today.year - controller.minimumAge, today.month, today.day),
        helpText: 'Date of Birth',
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.highContrastLight(
                      primary: AppColors.firstColor),
                  dialogBackgroundColor: Colors.white),
              child: child!);
        });

    controller.dobController.text = controller.dateFormat.format(dateTime!);
    print(controller.selectedDate);
  }

  buildCupertinoDatePicker(BuildContext context) async {
    DateTime today = DateTime.now();

    DateTime pickedDate = await showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          DateTime tempPickedDate = controller.selectedDateTime ??
              DateTime(
                  today.year - controller.minimumAge, today.month, today.day);
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.firstColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: const Text(
                        'Done',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.firstColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(tempPickedDate);
                      },
                    ),
                  ],
                ),
                const Divider(
                  height: 0,
                  thickness: 1,
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (picked) {
                      tempPickedDate = picked;
                    },
                    initialDateTime: DateTime(
                        today.year - controller.minimumAge,
                        today.month,
                        today.day),
                    // minimumYear: 1950,
                    minimumYear: today.year - controller.maximumAge,
                    maximumYear: today.year - controller.minimumAge,
                  ),
                ),
              ],
            ),
          );
        });

    if (pickedDate != null && pickedDate != controller.selectedDateTime) {
      controller.selectedDateTime = pickedDate;
      controller.selectedDate = controller.dateFormat.format(pickedDate);
      controller.dobController.text = controller.selectedDate!;
    }
  }

  Widget setupAlertDialoadContainer(BuildContext context) {
    List<Country> countries = controller.countriesList.value;
    return Container(
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
}
