import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:podcast_app/controllers/reset_controller.dart';
import 'package:podcast_app/models/response/validate_otp_reset.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/keys.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/screens/forgot/reset_password_screen.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/utils/utility.dart';
import 'package:podcast_app/widgets/bg/gradient_bg.dart';
import 'package:podcast_app/widgets/bg/tomtom_title.dart';
import 'package:podcast_app/widgets/btns/stadiumButtons.dart';
import 'package:podcast_app/widgets/btns/wrap_text_btn.dart';

import 'login_screen.dart';
import '../main_screen.dart';

class OtpScreen extends StatefulWidget {
  final String mobileNumber;
  final bool isFromForgot;
  const OtpScreen({Key? key, required this.mobileNumber, this.isFromForgot=false}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otp = "";

  bool showProgress = false;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 45,
      height: 45,
      textStyle: const TextStyle(
          fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(4),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(4),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

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
            /*Container(
              decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: AssetImage('images/ob_bg.png'),
                      fit: BoxFit.cover)),
            ),*/
            Column(
              children: [
                 TomTomTitle(title: widget.isFromForgot?"Forgot Password":'Sign in' ,hideTitle: true,width: 125,height: 125,),
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
                            'LOG IN',
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Pinput(
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                            submittedPinTheme: submittedPinTheme,
                            obscureText: true,
                            length: 6,
                            /*validator: (s) {
                              return s == '2222' ? null : 'Pin is incorrect';
                            },
                            pinputAutovalidateMode:
                                PinputAutovalidateMode.onSubmit,*/
                            showCursor: true,
                            onCompleted: (pin) {
                              Utility.hideKeyword(context);
                              otp = pin;
                              print(pin);
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'We sent an sms with a 6-digit code to ${widget.mobileNumber}.',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          StadiumButton(
                            title: 'SUBMIT',
                            callback: () {
                              validateOtp();

                              //Get.offAll( const MainScreen());
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          WrapTextButton(
                            callback: ()  {

                              CommonNetworkApi().sendNewOtp(context, widget.mobileNumber);

                            },
                            title: 'Resend SMS',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          WrapTextButton(
                            callback: () {
                              Get.back();
                            },
                            title: 'Edit phone number',
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            if (showProgress)
              const Center(
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }

  void validateOtp() async {
    setState(() {
      showProgress = true;
    });

    Map<String, dynamic> q = {"mobile": widget.mobileNumber, "otp": otp};



   // ResponseData responseData = ResponseData.fromJson(res);



    if(widget.isFromForgot){

      final res = await ApiService().validResetOtp(q);

      setState(() {
        showProgress = false;
      });


      ValidateOtpReset responseData = ValidateOtpReset.fromJson(res);

      if(responseData.status!.toUpperCase() == AppConstants.SUCCESS && responseData.response!.isvalid!){

        Get.put(ResetPasswordController());
        Get.to( ResetPassword(mobileNumber: widget.mobileNumber,resetToken: responseData.response!.token!,));

      }else{
        AppDialogs.simpleOkDialog(context, 'Warning', 'Please enter valid OTP.');
      }



    }else{

      // final res = await ApiService().validOtp(q);
      final res = await ApiService().validNewOtp(q);

      setState(() {
        showProgress = false;
      });

      print(res);


      //AppConstants.navigateToDashBoard(context, res);

      AppConstants.navigateToDashBoardNew(context,widget.mobileNumber, res);

    }


    /*if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
      Get.offAll(()=>const MainPage());
    } else {
      AppDialogs.simpleOkDialog(context, 'Failed',
          responseData.response ?? "unable to process request");
    }*/
  }
}
