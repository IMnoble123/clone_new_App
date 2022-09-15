import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/chat_list_data.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/utils/utility.dart';
import 'package:record/record.dart';

class ChartController extends GetxController {
  final messageController = TextEditingController();

  ScrollController listScrollController = ScrollController();

  RxList<ChatItem> chatItems = <ChatItem>[].obs;

  RxString rjId = "".obs;

  String? localDirectory;

  Timer? timer;

  RxBool isLoading = false.obs;
  RxBool isRecording = false.obs;
  RxBool isRecordingCompleted = false.obs;
  RxBool enableAudioView = false.obs;
  RxBool isPlayRecodedAudio = false.obs;
  RxBool isNewAudio = false.obs;
  Duration racDuration = Duration.zero; //recordedAudioCurrentDuration

  RxInt count = 0.obs;
  RxInt recordDuration = 0.obs;
  Timer? recordTimer;
  final recorder = Record();

  RxString recordPath = ''.obs;

  RxString message = ''.obs;

  String playingAudio ='';
  Duration playingDuration = Duration.zero;
  Duration playingTotalDuration = Duration.zero;

  AudioPlayer? audioPlayer;



  @override
  void onInit() {

    messageController.addListener(() {
      message.value = messageController.text;
    });

    timer =
        Timer.periodic(const Duration(seconds: 5), (timer) => fetchChatList());

    Future.delayed(const Duration(seconds: 2), () {
      scrollToBottom();
      audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    });

    Utility.createFolderInAppDocDir(AppConstants.DOWNLOADS_FILES_DIRECTORY).then((value) => localDirectory=value);

    super.onInit();
  }

  void fetchChatList() async {
    if (rjId.value.trim().isEmpty) return;

    final responseData = await ApiService().postData(
        ApiKeys.CHAT_LIST_SUFFIX, ApiKeys.getChatListQuery(rjId.value),ageNeeded: false);

    ChatListData chatListData = ChatListData.fromJson(responseData as dynamic);

    if (chatListData.status == "Success") {

      if(chatItems.value.length != chatListData.chatList){
        chatItems.value = chatListData.chatList!;
      }

    } else {
      chatItems.clear();
    }

    if (count.value != chatItems.length) {
      scrollToBottom();
    }

    count.value = chatItems.length;
  }

  void scrollToBottom() {
    if (listScrollController.hasClients) {
      final position = listScrollController.position.maxScrollExtent;
      // listScrollController.jumpTo(position);

      listScrollController.animateTo(
        position+50,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }


  void sendMessage() async {
    if (rjId.value.trim().isEmpty) return;

    String message = messageController.text.trim();

    ChatItem chatItem = ChatItem(
        senderId: rjId.value,
        senderType: "Mobuser",
        rjName: null,
        profileImage: null,
        message: message,
        createdDate: Utility.getCurrentTime());

    chatItems.add(chatItem);

    messageController.clear();

    scrollToBottom();

    final responseData = await ApiService().postData(
        ApiKeys.CREATE_CHAT_SUFFIX, prepareChatItem(rjId.value, message), ageNeeded: false);

    ResponseData response = ResponseData.fromJson(responseData as dynamic);

    if (response.status == "Success") {
      fetchChatList();
    }
  }

  void sendHtmlMessage(String htmlData) async {
    if (rjId.value.trim().isEmpty) return;

    if (htmlData.isEmpty) return;

    print(htmlData);

    ChatItem chatItem = ChatItem(
        senderId: rjId.value,
        senderType: "Mobuser",
        rjName: null,
        profileImage: null,
        message: htmlData,
        createdDate: Utility.getCurrentTime());

    chatItems.add(chatItem);

    messageController.clear();

    scrollToBottom();

    final responseData = await ApiService().postData(
        ApiKeys.CREATE_CHAT_SUFFIX, prepareChatItem(rjId.value, htmlData),ageNeeded: false);

    ResponseData response = ResponseData.fromJson(responseData as dynamic);

    if (response.status == "Success") {
      fetchChatList();
    }
  }

  Map<String, dynamic> prepareChatItem(rjId, message) {
    return {
      "sender_id": CommonNetworkApi().mobileUserId,
      "sender_type": "Mobuser",
      "receiver_id": rjId,
      "receiver_type": "RJ",
      "message": message
    };
  }

  @override
  void dispose() {
    print('ChartController disposed');
    Get.delete<ChartController>();
    super.dispose();
  }

  @override
  void onClose() {
    print('ChartController disposed');

    super.onClose();
  }
}
