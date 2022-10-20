import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/share_prefs.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/models/response/user_response_data.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/screens/profile/edit_profile_screen.dart';
import 'package:podcast_app/utils/utility.dart';

class ProfileController extends GetxController {
  RxBool isAgetRestrictionOff = false.obs;
  RxBool isDeviceLockOff = false.obs;

  RxBool isPodcastPushOff = false.obs;
  RxBool isRjPushOff = false.obs;

  RxBool isPodcastEmailOff = false.obs;
  RxBool isRjEmailOff = false.obs;

  RxString profilePicPath = "".obs;

  RxDouble totalSize = 0.0.obs;

  Rx<Gender> gender = Gender.Male.obs;

  final inputController = TextEditingController();


  DateTime? selectedDateTime;
  String? selectedDate;

  int minimumAge = 13;
  int maximumAge = 100;

  final DateFormat dateFormat = DateFormat('dd MM yyyy');
  String? selectedDob = '';



  Rx<UserResponseData> userData = UserResponseData(
          id: "",
          createdDate: "",
          dob: "",
          email: "",
          gender: "",
          mobile: "",
          modifiedDate: "",
          name: "",
          prefLanguage: "",
          profileImage: "",
          source: "")
      .obs;

  @override
  void onInit() {
    super.onInit();

    AppSharedPreference()
        .getStringData(AppConstants.PROFILE_PIC_PATH)
        .then((value) {
      print(value);
      profilePicPath.value = value;
    });
  }

  void fetchProfileInfo() async {
    final response = await ApiService()
        .postData(ApiKeys.FETCH_RPOFILE_SUFFIX, ApiKeys.getMobileUserQuery());

    ResponseData responseData = ResponseData.fromJson(response);

    if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
      userData.value = UserResponseData.fromJson(responseData.response);
      userData.refresh();
    } else {
      userData.value = UserResponseData(
          id: "",
          createdDate: "",
          dob: "",
          email: "",
          gender: "",
          mobile: "",
          modifiedDate: "",
          name: "",
          prefLanguage: "",
          profileImage: "",
          source: "");
      userData.refresh();
    }
  }

  fetchTotalSize() async{

    Utility.dirStatSync(AppConstants.DOWNLOADS_FILES_DIRECTORY).then((value) => totalSize.value = value);

  }

  updateAgeRestriction(bool b) {
    isAgetRestrictionOff.value = b;
    update();
  }

  updateDeviceLock(bool b) {
    isDeviceLockOff.value = b;
    update();
  }

  updatePodcastPush(bool b) {
    isPodcastPushOff.value = b;
    update();
    
  }

  updateRjPush(bool b) {
    isRjPushOff.value = b;
    update();
  }

  updatePodcastEmail(bool b) {
    isPodcastEmailOff.value = b;
    update();
  }

  updateRjEmail(bool b) {
    isRjEmailOff.value = b;
    update();
  }
}
