import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/chat_controller.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/chat_list_data.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/utils/utility.dart';
import 'package:record/record.dart';

import '../screens/login/login_screen.dart';
import '../screens/main/main_page.dart';

class ChatTextFieldController extends GetxController {
  final messageController = TextEditingController();

  RxString message = ''.obs;

  RxBool isLoading = false.obs;
  RxBool isRecording = false.obs;
  RxBool isRecordingCompleted = false.obs;
  RxBool enableAudioView = false.obs;
  RxBool isPlayRecodedAudio = false.obs;
  RxBool isNewAudio = false.obs;
  Duration racDuration = Duration.zero;

  RxString recordPath = ''.obs;
  RxInt recordDuration = 0.obs;

  Timer? recordTimer;
  final recorder = Record();

  AudioPlayer? audioPlayer;

  String? localDirectory;

  @override
  void onInit() {
    messageController.addListener(() {
      message.value = messageController.text;
    });

    Future.delayed(const Duration(seconds: 2), () {
      audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    });

    Utility.createFolderInAppDocDir(AppConstants.DOWNLOADS_FILES_DIRECTORY)
        .then((value) => localDirectory = value);

    super.onInit();
  }

  void sendMessage(context) async {

    if(message.value.isEmpty) return;

    Get.find<MainController>().commentsLoad.value = true;

    String podcastId = Get.find<MainController>().podcastId.value;

    try {
      final data = await ApiService().postData(ApiKeys.POST_COMMENT,
          ApiKeys.getCommentQuery(podcastId, message.value),ageNeeded: false);

      ResponseData responseData = ResponseData.fromJson(data);

      if (responseData.status == 'Success') {

        Get.find<MainController>().fetchComments(podcastId);

      } else if (responseData.status == 'Error') {
        AppDialogs.simpleOkDialog(context, "Blocked",
                "Your account has been blocked, please contact to support@tomtompodcast.com")
            .then((value) {

          gotoLoginScreen();

        });
      } else {
        Get.find<MainController>().commentsLoad.value = false;
      }
    } catch (err, str) {
      print('Add Comment Error $err');
      Get.find<MainController>().commentsLoad.value = false;
      print(str);
    }

    messageController.clear();
  }

  void sendHtmlMessage(context,String htmlData) async {
    Get.find<MainController>().commentsLoad.value = true;

    String podcastId = Get.find<MainController>().podcastId.value;

    try {
      final data = await ApiService().postData(
          ApiKeys.POST_COMMENT, ApiKeys.getCommentQuery(podcastId, htmlData),ageNeeded: false);

      ResponseData responseData = ResponseData.fromJson(data);

      if (responseData.status == 'Success') {
        Get.find<MainController>().fetchComments(podcastId);
      } else if (responseData.status == 'Error') {
        AppDialogs.simpleOkDialog(context, "Blocked",
            "Your account has been blocked, please contact to support@tomtompodcast.com")
            .then((value) {

          gotoLoginScreen();

        });
      } else {
        Get.find<MainController>().commentsLoad.value = false;
      }
    } catch (err, str) {
      print('Add Comment Error $err');
      Get.find<MainController>().commentsLoad.value = false;
      print(str);
    }
  }

  void gotoLoginScreen() async {
    Get
        .find<MainController>()
        .tomtomPlayer
        .dispose();
    MainPage.isFirstBuild = true;
    await Get.delete<MainController>(force: true)
        .then((value) => Get.offAll(const LoginScreen()));
  }

  void clearText(){
    message.value ='';
    messageController.text = '';
  }

}
