import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/screens/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  final String title;
  final String url;
  const TermsAndConditionsScreen({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title:  Text(
        title,
        style: const TextStyle(
            color: AppColors.firstColor,
            fontSize: 25,
            fontWeight: FontWeight.w600),
      ), backgroundColor: Colors.transparent,),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         /* const Text(
            'Terms & Conditions',
            style: TextStyle(
                color: AppColors.firstColor,
                fontSize: 25,
                fontWeight: FontWeight.w600),
          ),*/
          Expanded(
              child: InAppWebView(
            initialUrlRequest: URLRequest(
                url: Uri.parse(url),),
                // url: Uri.parse("https://www.tomtompodcast.com/mterms.html"),),
                // url: Uri.parse("https://www.tomtompodcast.com/terms.html")),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              /*MaterialButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
                child: const Text(
                  'Deny',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                color: AppColors.firstColor,
                shape: const StadiumBorder(),
              ),*/
              MaterialButton(
                onPressed: () {
                  //userAgreeTC(context);
                  Get.back();
                },
                child: const Text(
                  'Dismiss', //Accept
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                color: AppColors.firstColor,
                shape: const StadiumBorder(),
              ),
            ],
          )
        ],
      ),
    ));
  }

  void userAgreeTC(context) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool(AppConstants.ACCEPTED_TC, true).then((value) {

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (b) => const LoginScreen()),
          (route) => false);

    });
  }
}
