import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:podcast_app/extras/share_prefs.dart';
import 'package:podcast_app/models/new_otp_response_data.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/models/response/user_response_data.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/screens/login/enter_name_page.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app_dialogs.dart';

class AppConstants {

  static const PAGE_SIZE = 5;
  static const PAGE_SIZE_VERTICAL = 10;

  static const token = 'cab86d0e941f49438c79d2f5f5e42e07';

  static const projectId = '6214e76d0dd5fe9b5150';
  static const endPoint = 'http://54.163.98.147:8080/v1';

  static const FB_PAGE =
      'https://m.facebook.com/profile.php?id=100078650588895';
  static const IG_PAGE = 'https://www.instagram.com/tomtompodcasts/';
  static const WEB_PAGE = 'https://www.tomtompodcast.com/';
  static const TW_PAGE = 'https://mobile.twitter.com/PodcastTomtom';
  static const TG_PAGE = 'https://t.me/s/quote';
  static const EMAIL_TTP = 'Podcast.tomtom@gmail.com';

  static const double collapseBarHeight = 75;

  static const String dummyRjPic =
      "https://static.vecteezy.com/system/resources/thumbnails/002/157/610/small_2x/illustrations-concept-design-podcast-channel-free-vector.jpg";
  static const String dummyFolderPic ="https://icons.iconarchive.com/icons/papirus-team/papirus-places/512/folder-red-music-icon.png";
  static const String dummyProfilePic ="https://struggletownvet.com.au/wp-content/uploads/2019/11/blank-profile-picture-973460_640-300x300.png";
  static const String dummyPic =
      "https://static.vecteezy.com/system/resources/thumbnails/002/157/610/small_2x/illustrations-concept-design-podcast-channel-free-vector.jpg";

  static const DOWNLOADS_FILES_DIRECTORY = "TomTom";

  static const DB_NAME = "TomTom.db";
  static const PODCAST_TABLE_NAME = "Podcast";

  static const ACCEPTED_TC = "TermsConditions";

  static const SUCCESS = "SUCCESS";
  static const COMPLETED = "COMPLETED";
  static const FAILED = "FAILED";
  static const PENDING = "PENDING";
  static const OK = "Okay";
  static const CANCEL = "Cancel";

  static const FCM_BG = "fcm Bg";

  static const SONG_LOOP = "songLoop";
  static const SONG_SHUFFLE = "songShuffle";

  static const FCM_TOKEN = "FcmToken";
  static const API_TOKEN = "ApiToken";

  static const USER_ID = "userId";
  static const USER_Name = "userName";
  static const IS_USER_LOGED_IN = "isUserLogin";
  static const AGE_RESTRICTED = "AgeRestricted";

  static const PROFILE_PIC_PATH = "ProfilePicPath";

  static const TYPE_FAVOURITE = "favourite";
  static const TYPE_LISTEN_LATER = "listenlater";

  // static const url = "https://wa.me/?text=Your Message here";
  //static const url = "https://wa.me/918179860808/?text=Your";

  static bool age_restricted = false;

  static bool isFromBg_Notification = false;



  static UserResponseData? userData;

  static getRandomNumber() {
    int min = 10000; //min and max values act as your 6 digit range
    int max = 99999;
    var randomizer = Random();
    var rNum = min + randomizer.nextInt(max - min);

    return "98765$rNum";
  }

  static Future<bool> launchWhatsApp(
      BuildContext context, String phone, String t) async {
    /*final s = await FlutterSocialContentShare.shareOnWhatsapp(phone, t);
    print(s);
    return true;*/

    var whatsappURl_android =
        "whatsapp://send?phone=" + phone.replaceAll(" ", "") + "&text=$t";
    var whatappURL_ios = "https://wa.me/$phone?text=${Uri.parse(t)}";

    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
        return true;
      } else {
        return false;
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
        return true;
      } else {
        return false;
      }
    }
  }

  /*static String whatsAppUrl(String phone,String message) {
    if (Platform.isAndroid) {
      return "https://wa.me/$phone/?text=${Uri.parse(message)}"; // new line
    } else {
      return "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(message)}"; // new line
    }
  }*/

  static void navigateToDashBoard(
      BuildContext context, dynamic response) async {
    try {
      ResponseData responseData = ResponseData.fromJson(response);

      if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
        userData = UserResponseData.fromJson(responseData.response);

        print(userData?.id);
        CommonNetworkApi().mobileUserId = userData?.id ?? '';

        ApiService().updateApiToken(userData?.token);

        AppSharedPreference().saveBoolData(AppConstants.IS_USER_LOGED_IN, true);
        AppSharedPreference().saveStringData(AppConstants.USER_Name, userData!.name??'Anonymous');
        AppSharedPreference()
            .saveStringData(AppConstants.USER_ID, userData?.id ?? '')
            .then((value) => Get.offAll(() => const MainPage()));
      } else {
        AppDialogs.simpleOkDialog(context, 'Failed',
            responseData.response ?? "unable to process request");
      }
    } catch (e) {
      AppDialogs.simpleOkDialog(context, 'Failed', "unable to process request");
    }
  }

  static void navigateToDashBoardNew(
      BuildContext context,String mobileNumber, dynamic response) async {
    try {
      NewOtpResponseData responseData = NewOtpResponseData.fromJson(response);

      if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {



        if(responseData.response!.usertype!.toUpperCase() == "EXISTING"){

          // userData = responseData.response!.userdata;
          userData = UserResponseData.fromJson(responseData.response!.userdata);

          print(userData?.token);
          ApiService().updateApiToken(userData?.token);

          print(userData?.id);
          CommonNetworkApi().mobileUserId = userData?.id ?? '';


          AppSharedPreference().saveBoolData(AppConstants.IS_USER_LOGED_IN, true);
          AppSharedPreference().saveStringData(AppConstants.USER_Name, userData!.name??'Anonymous');
          AppSharedPreference()
              .saveStringData(AppConstants.USER_ID, userData?.id ?? '')
              .then((value) => Get.offAll(() => const MainPage()));

        }else if(responseData.response!.usertype! == "NEW"){

          Get.to(()=>EnterNameScreen(mobileNumber: mobileNumber, token: responseData.response!.token!));

        }else{

          AppDialogs.simpleOkDialog(context, 'Failed',
               "Something wrong in backend");
          
        }




      } else {
        AppDialogs.simpleOkDialog(context, 'Failed',
            responseData.response!.message ?? "unable to process request");
      }
    } catch (e) {
      print(e.toString());
      AppDialogs.simpleOkDialog(context, 'Failed!', "unable to process request");
    }
  }
}
