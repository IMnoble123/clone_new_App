import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:podcast_app/controllers/chat_textfield_controller.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/helper/image_picker_helper.dart';
import 'package:podcast_app/models/response/add_comment_response.dart';
import 'package:podcast_app/models/response/category_response.dart';
import 'package:podcast_app/models/response/comment_response.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/models/response/rj_categories_data.dart';
import 'package:podcast_app/models/response/unread_chat_response_data.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/player/progress_bar_state.dart';
import 'package:podcast_app/player/tomtom_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../extras/app_dialogs.dart';
import '../screens/login/login_screen.dart';
import '../screens/main/main_page.dart';

class MainController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxInt chipSelectedIndex = 0.obs;
  RxInt rjChipSelectedIndex = 0.obs;
  RxInt filterChipSelectedIndex = 0.obs;
  RxInt like = 0.obs;
  RxInt showsCount = 0.obs;

  final ScrollController scrollController = ScrollController();

  RxList<Category> categories = <Category>[].obs;

  Rx<ProgressBarState> progressNotifier = const ProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  ).obs;

  final messageController = TextEditingController();
  RxString message = ''.obs;

  RxDouble showSocialBtns = 0.0.obs;

  RxBool showProgress = false.obs;

  RxBool isFirstPodcast = false.obs;
  RxBool isLastPodcast = false.obs;
  RxBool isShuffleModeEnabled = false.obs;

  RxDouble seekPosition = 0.0.obs;
  RxDouble currentPosition = 0.0.obs;
  RxDouble maxDuration = 0.0.obs;

  RxBool isPlaying = false.obs;
  RxBool isLoadingPodcast = false.obs;
  RxBool isSearchOpened = false.obs;

  RxBool isSeekbarTouched = false.obs;

  RxBool isLikeClicked = false.obs;

  RxBool isSongLooped = false.obs;
  RxBool isSongShuffle = false.obs;

  final panelController = PanelController();

  //final player = AudioPlayer();

  RxBool hideTopSection = false.obs;

  RxBool downloadInProgress = false.obs;
  RxBool enableCommentEditField = false.obs;
  RxBool enableReplayEditField = false.obs;
  RxString commentId = "".obs;
  RxString coverPic = "".obs;
  RxString podcastId = "".obs;
  RxString podcastName = "".obs;
  RxString podcastBy = "".obs;
  RxString podcastDate = "".obs;

  RxString tabName = 'home'.obs;
  RxString unReadChatCount = ''.obs;

  Podcast? currentPodcast;

  RxInt downloadProgress = 0.obs;

  final TextEditingController _commentController = TextEditingController();

  get commentController => _commentController;

  RxList<Comment> comments = <Comment>[].obs;
  RxBool commentsLoad = false.obs;

  List<AudioPlayer> audioplayers = [];

//***************************Add comment ************************************** *///

  Future<void> addComment({required String comment, bool file = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // CommonNetworkApi().mobileUserId = prefs.getString(AppConstants.USER_ID) ?? '';
      // String id = prefs.getString(AppConstants.USER_ID) ?? "2032";
      String id = CommonNetworkApi().mobileUserId;

      var data = await ApiService().postComment({
        "podcast_id": podcastId.value,
        "mob_user_id": id, //add user id
        "description": file ? '' : comment,
        "filepath": file ? comment : '',
        "created_by": "" //add user name
      });

      AddCommentResponse addResponse = AddCommentResponse.fromJson(data);
      print('cmtRes => ${addResponse.toJson()}');
      if (addResponse.status == 'Success') {
        _commentController.text = '';
        fetchComments(podcastId.value);
      } else {
        _commentController.text = 'error';
      }
      update();
    } catch (err, str) {
      print('Add Comment Error $err');
      print(str);
    }
  }

  final tomtomPlayer = TomTomPlayer();

  @override
  void onInit() {
    super.onInit();

    messageController.addListener(() {
      message.value = messageController.text;
    });

    /*player.setUrl(
        'https://tttp-s3-storage.s3.amazonaws.com/1646926452_file_example_MP3_700KB.mp3');*/
  }

  increaseLikes() {
    like.value += 1;
    update();
  }

  updateSelectedIndex(int i) {
    selectedIndex.value = i;
    // selectedIndex.value == i;

    tabName.value = '';
    switch (i) {
      case 0:
        tabName.value = 'home';
        break;
      case 1:
        tabName.value = 'playList';
        break;
      case 2:
        /* tabName.value = 'tomTom';
        break;
      case 3:*/
        tabName.value = 'profile';
        break;
    }

    if (panelController.isPanelOpen) {
      panelController.close();
    }

    showSocialBtns.value = 0.0;

    /*if (selectedIndex.value == 0 || selectedIndex.value == 1) {
      if (!panelController.isPanelShown) {
        panelController.show();
      }
    } else {
      panelController.hide();
    }*/

    update();
  }

  updateChipSelectedIndex(int i) {
    chipSelectedIndex.value = i;
    update();
  }

  updateFilterChipSelectedIndex(int i) {
    filterChipSelectedIndex.value = i;
    update();
  }

  togglePanel() async {
    if (!panelController.isPanelShown) {
      await panelController.show();
    }

    if (panelController.isPanelOpen) {
      panelController.close();
    } else {
      panelController.show();
      panelController.open();
    }

    update();
  }

  updateSearchToggle(bool b) {
    isSearchOpened.value = b;
    update();
  }

  updateSeekPosition(double value) async {
    seekPosition.value = value;

    //tomtomPlayer.seek(Duration(seconds: value.toInt()));
  }

  updateSeekPositionEnd(double value) async {
    tomtomPlayer.seek(Duration(seconds: value.toInt()));
  }

  /*updateSeekPosition(double value) async {
    seekPosition.value = value;

    await player.seek(Duration(seconds: value.toInt()));

    print('seek move by finger');
    updatePlayingState(true);

    update();
  }*/

  previousPodcast() {
    tomtomPlayer.onPreviousSongButtonPressed();
  }

  nextPodcast() async {
    for (var element in audioplayers) {
      await element.stop();
    }

    tomtomPlayer.onNextSongButtonPressed();
  }

  pausePodcast() {
    tomtomPlayer.pause();
  }

  playPodcast() {
    tomtomPlayer.play();
  }

  updatePlayingState(bool b) {
    isPlaying.value = b;
    isLoadingPodcast.value = false;

    /*if (b) {
      tomtomPlayer.play();
    } else {
      tomtomPlayer.pause();
    }*/

    update();
  }

  /*updatePlayingState(bool b) {
    isPlaying.value = b;

    if (b) {
      player.play();
    } else {
      player.pause();
    }

    update();
  }*/

  updateHideTop(bool b) {
    hideTopSection.value = b;
    update();
  }

  void updatePodcast(Podcast podcast) async {
    if (currentPodcast != null &&
        currentPodcast!.podcastId == podcast.podcastId!) return;

    seekPosition.value = 0.0;

    try {
      Get.find<ChatTextFieldController>().clearText();
    } catch (e) {
      log(e.toString());
    }

    if (!podcast.imagepath!.contains(".jfif")) {
      coverPic.value = podcast.imagepath!;
    } else {
      coverPic.value = AppConstants.dummyPic;
    }
    podcastName.value = podcast.podcastName ?? '';
    podcastId.value = podcast.podcastId ?? '';
    podcastBy.value = podcast.rjname ?? '';
    podcastDate.value = podcast.broadcastDate ?? '';

    currentPodcast = podcast;

    // isLoadingPodcast.value = true;

    isLikeClicked.value = podcast.youLiked == "1" ? true : false;

    print('updated TOMTOM');
    like.value = int.parse(podcast.likeCount ?? "0");

    update();

    fetchComments(podcast.podcastId!);

    /*final duration = await player.setAudioSource(AudioSource.uri(
      Uri.parse(podcast.audiopath!),
      tag: MediaItem(
        // Specify a unique ID for each media item:
        id: podcast.podcastId!,
        // Metadata to display in the notification:
        album: 'BY ${podcast.rjname}',
        title: podcast.podcastName!,
        artUri: Uri.parse(podcast.imagepath ?? AppConstants.dummyPic),
      ),
    ));

    //final duration = await player.setUrl(podcast.audiopath!);
    await player.setLoopMode(isSongLooped.value ? LoopMode.one : LoopMode.off);

    maxDuration.value = duration!.inSeconds.toDouble();
    print(maxDuration.value);

    updatePlayerListeners();

    updatePlayingState(true);
    update();*/
  }

  void updateIsFirstPage(bool b) {
    isFirstPodcast.value = b;
    update();
  }

  void updateIsLastPage(bool b) {
    isLastPodcast.value = b;
    update();
  }

  void updateCoverPic(String s) {
    coverPic.value = s;
    update();
  }

  /*void updatePlayerListeners() {
    player.positionStream.listen((event) {
      seekPosition.value = event.inSeconds.toDouble();
      currentPosition.value = event.inSeconds.toDouble();
    });

    player.playingStream.listen((b) {
      isPlaying.value = b;
      update();
    });

    player.playerStateStream.listen((event) {
      switch (event.processingState) {
        case ProcessingState.idle:

          break;
        case ProcessingState.loading:
          isLoadingPodcast.value = true;
          break;
        case ProcessingState.buffering:
          isLoadingPodcast.value = true;
          break;
        case ProcessingState.ready:
          isLoadingPodcast.value = false;
          break;
        case ProcessingState.completed:
          updatePlayingState(false);
          break;
      }
    });
  }*/

  void updateLoading(bool b) {
    isLoadingPodcast.value = b;
    update();
  }

  void updateSongLoop(bool b) async {
    isSongLooped.value = b;
    tomtomPlayer.setLoopMode(b);
    //await player.setLoopMode(isSongLooped.value ? LoopMode.one : LoopMode.off);
    update();
  }

  void updateSongShuffle(bool b) {
    isSongShuffle.value = b;
    tomtomPlayer.setShuffleMode(b);
    update();
  }

  void updateProgressStates(ProgressBarState barState) {
    progressNotifier.value = barState;
    currentPosition.value = barState.current.inSeconds.toDouble();
    seekPosition.value = barState.current.inSeconds.toDouble();
    maxDuration.value = barState.total.inSeconds.toDouble();
    update();
  }

  RxList<Podcast> rjPodcasts = <Podcast>[].obs;
  RxList<Podcast> filteredRjPodcasts = <Podcast>[].obs;
  RxList<RjCategory> filteredRjCategories = <RjCategory>[].obs;
  RxString rjPodcastFilter = "All".obs;

  void fetchRjsPodcasts(String rjId) async {
    final data =
        await ApiService().podcastListByRj(ApiKeys.getRjUserQuery(rjId));

    PodcastResponse response = PodcastResponse.fromJson(data);

    rjPodcasts.value = response.podcasts!;
    filteredRjPodcasts.value = response.podcasts!;
  }

  void fetchRjsFilterCategories(String rjId) async {
    final data = await ApiService().postData(
        ApiKeys.RJ_FILTER_CATEGORIES_SUFFIX, ApiKeys.getRjByRjIdQuery(rjId));

    try {
      RjCategoriesData response = RjCategoriesData.fromJson(data);

      if (response.status == "Success") {
        response.rjCategories!
            .insert(0, RjCategory(category: 'All', podcastCount: "0"));
        filteredRjCategories.value = response.rjCategories!;
        rjPodcastFilter.value = "All";
        rjChipSelectedIndex.value = 0;
      } else {
        filteredRjCategories.value = [];
      }
    } catch (e) {
      print(e);
      filteredRjCategories.value = [];
    }
  }

  ///***************************** list unreade chat count*********************** ***//////

  void fetchUnreadChatCount(String rjId) async {
    final data = await ApiService()
        .postData(ApiKeys.CHAT_UNREAD_SUFFIX, ApiKeys.getChatListQuery(rjId));

    UnreadChatResponseData responseData = UnreadChatResponseData.fromJson(data);

    if (responseData.status == "Success" &&
        responseData.response != null &&
        responseData.response!.isNotEmpty) {
      unReadChatCount.value = responseData.response![0].unreadCount!;
    } else {
      unReadChatCount.value = '';
    }
  }

  ///***************************** list chat count*********************** ***//////

  void chatCountViewed(String rjId) async {
    final data = await ApiService()
        .putData(ApiKeys.UPDATE_CHAT_SUFFIX, ApiKeys.getChatListQuery(rjId));

    ResponseData responseData = ResponseData.fromJson(data as dynamic);

    if (responseData.status == "Success") {
      unReadChatCount.value = '';
    }
  }

  showOptionsSheet(context) async {
    List<IconData> options = [
      Icons.photo_camera_outlined,
      Icons.photo_library_outlined,
      Icons.video_call_outlined,
      Icons.video_collection_outlined
    ];
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                  options.length,
                  (index) => Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            border: Border.all(color: Colors.red)),
                        child: IconButton(
                          icon: Icon(
                            options[index],
                            color: Colors.red,
                          ),
                          onPressed: () {
                            Get.back();
                            if (options[index] == Icons.photo_camera_outlined) {
                              openPhotos(camera: true);
                            } else if (options[index] ==
                                Icons.photo_library_outlined) {
                              openPhotos();
                            } else if (options[index] ==
                                Icons.video_call_outlined) {
                              openVideo(camera: true);
                            } else if (options[index] ==
                                Icons.video_collection_outlined) {
                              openVideo();
                            }
                          },
                        ),
                      )),
            ),
          );
        });
  }

  void openPhotos({bool camera = false}) async {
    XFile? camFile = await ImagePickerHelper.captureImage(isCamera: camera);
    if (camFile != null) {
      final File file = File(camFile.path);
      String imgPath = file.path;
      var data = await ApiService().uploadFile(imgPath);
      if (data != null) {
        AddCommentResponse uploadResponse = AddCommentResponse.fromJson(data);
        if (uploadResponse.status == 'Success') {
          _commentController.text = '';
          print('URL => ${uploadResponse.response}');

          addComment(comment: uploadResponse.response!, file: true);

          print(
              'type => ${uploadResponse.response!.split('.').last.toLowerCase()}');
        }
        update();
      }
    }
  }

  void openVideo({bool camera = false}) async {
    XFile? camFile = await ImagePickerHelper.recordVideo(isCamera: camera);
    if (camFile != null) {
      final File file = File(camFile.path);
      String imgPath = file.path;
      var data = await ApiService().uploadFile(imgPath);
      if (data != null) {
        AddCommentResponse uploadResponse = AddCommentResponse.fromJson(data);
        if (uploadResponse.status == 'Success') {
          _commentController.text = '';
          print('URL => ${uploadResponse.response}');

          addComment(comment: uploadResponse.response!, file: true);

          print(
              'type => ${uploadResponse.response!.split('.').last.toLowerCase()}');
        }
        update();
      }
    }
  }

  ///****************************list comment************************************************ */////

  void fetchComments(String podcastId) async {
    if (CommonNetworkApi().mobileUserId == "-1") {
      comments.value = [];
      return;
    }

    commentsLoad.value = true;

    final responseData = await ApiService().fetchComments({
      "podcast_id": podcastId,
      "mob_user_id": CommonNetworkApi().mobileUserId
    });
    debugPrint('data .................................. $responseData');
    try {
      CommentResponse response = CommentResponse.fromJson(responseData);

      print('fech-...................................$response');
      if (response.status == "Error" || response.comments!.isEmpty) {
        comments.value = [];
        commentsLoad.value = false;
        return;
      }

      List<Comment> list = response.comments!.reversed.toList();
      comments.value = list;
    } catch (e) {
      print('adnkadaksajdaj....................$e');
      comments.value = [];
    }

    commentsLoad.value = false;
  }

  //*****************send reply comment**************************** *//

  void sendReplyMessage(context) async {
    try {
      final data = await ApiService().postData(ApiKeys.POST_COMMENT_REPLY,
          ApiKeys.getCommentReplyQuery(commentId.value, message.value),
          ageNeeded: false);

      ResponseData responseData = ResponseData.fromJson(data);

      if (responseData.status == 'Success') {
        fetchComments(podcastId.value);
      } else if (responseData.status == 'Error') {
        AppDialogs.simpleOkDialog(MainPage.activeContext!, "Blocked",
                "Your account has been blocked, please contact to support@tomtompodcast.com")
            .then((value) {
          gotoLoginScreen();
        });
      }
    } catch (err, str) {
      print('Add Comment Error $err');
      print(str);
    }

    messageController.clear();
  }

  //*************************delet comment**************************************** *//

  void deleteComment(String commentId) async {
    try {
      final data = await ApiService().deleteData(
          ApiKeys.DELETE_COMMENT, ApiKeys.getDeleteCommentQuery(commentId));

      ResponseData responseData = ResponseData.fromJson(data);

      if (responseData.status == 'Success') {
        fetchComments(podcastId.value);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //***********************delect relply****************************************** *//

  void deleteReply(String replyId) async {
    try {
      final data = await ApiService().deleteData(
          ApiKeys.POST_COMMENT_REPLY, ApiKeys.getDeleteReplyQuery(replyId));

      ResponseData responseData = ResponseData.fromJson(data);

      if (responseData.status == 'Success') {
        fetchComments(podcastId.value);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void postldh(String commentId, String s) async {
    try {
      final data = await ApiService().postData(
          ApiKeys.POST_COMMENT_LDH, ApiKeys.getCommentLDHQuery(commentId, s),
          ageNeeded: false);

      ResponseData responseData = ResponseData.fromJson(data);

      if (responseData.status == 'Success') {
        fetchComments(podcastId.value);
      }
    } catch (err, str) {
      print('Add Comment Error $err');
      print(str);
    }
  }

  void replayLDH(String replyId, String s) async {
    try {
      final data = await ApiService().postData(
          ApiKeys.POST_REPLY_LDH, ApiKeys.getReplyLDHQuery(replyId, s),
          ageNeeded: false);

      ResponseData responseData = ResponseData.fromJson(data);

      if (responseData.status == 'Success') {
        fetchComments(podcastId.value);
      }
    } catch (err, str) {
      print('Add Comment Error $err');
      print(str);
    }
  }

  void closePlayer() {
    tomtomPlayer.stop();

    panelController.close();
    panelController.hide();
  }

  void gotoLoginScreen() async {
    Get.find<MainController>().tomtomPlayer.dispose();
    MainPage.isFirstBuild = true;
    await Get.delete<MainController>(force: true)
        .then((value) => Get.offAll(const LoginScreen()));
  }
}
