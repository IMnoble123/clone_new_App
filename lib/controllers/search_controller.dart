import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/models/response/notification_response_data.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/utils/utility.dart';

class SearchController extends GetxController {
  final stfController = TextEditingController();

  final FocusNode focusNode = FocusNode();

  RxString searchText = ''.obs;

  RxBool focusChanged = false.obs;
  RxBool openSearchScreen = false.obs;
  RxBool isFromPlayList = false.obs;

  RxInt notificationCount = 0.obs;
  RxList<NotificationItem> notificationItems = <NotificationItem>[].obs;

  RxList<String> selectedPodCasts = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    stfController.addListener(() {
      searchText.value = stfController.text;
      if (!openSearchScreen.value && searchText.value.isNotEmpty) {
        openSearchPanel();
      }
    });

    focusNode.addListener(() {
      focusChanged.value = focusNode.hasFocus;
      update();
    });
  }

  void openSearchPanel() {
    openSearchScreen.value = true;
    update();
  }

  void closeSearchPanel() {
    stfController.text = '';
    isFromPlayList.value = false;
    openSearchScreen.value = false;
    selectedPodCasts.clear();
    update();
  }

  void clearSearch() {
    stfController.text = '';
    update();
  }

  @override
  onClose() {
    print("search control disposed");
    focusNode.dispose();
    stfController.dispose();
    super.onClose();
  }

  void enablePlaylistSearch() {
    selectedPodCasts.clear();
    isFromPlayList.value = true;
    openSearchScreen.value = true;
  }

  void dismissPlaylistSearch() {
    stfController.text = '';
    selectedPodCasts.clear();
    isFromPlayList.value = false;
    openSearchScreen.value = false;
  }

  void fetchNotifications() async {
    // final result = await ApiService().postData(ApiKeys.NOTIFICATIONS_SUFFIX, ApiKeys.getMobileUserQuery());
    final result = await ApiService()
        .postData(ApiKeys.NOTIFICATIONS_SUFFIX, ApiKeys.getMobileUserQuery());

    try {
      NotificationResponseData data = NotificationResponseData.fromJson(result);

      notificationCount.value = data.response!.notificationCount!;
      notificationItems.value = data.response!.notificationList!;
    } catch (e) {
      notificationCount.value = 0;
      notificationItems.value = [];
    }

    /*notificationCount.value = 3;
    notificationItems.value = dummyNotifications();*/

    print(notificationCount.value);
  }

  List<NotificationItem> dummyNotifications() {
    List<NotificationItem> items = List.filled(
        3,
        NotificationItem(
            podcastId: "100",
            message: "Test Podcast",
            viewed: "1",
            createdDate: ""));

    return items;
  }

  void notificationsViewed() async {
    await ApiService().putData(
        ApiKeys.VIEW_NOTIFICATIONS_SUFFIX, ApiKeys.getMobileUserQuery());

    notificationItems.value = [];
    notificationCount.value = 0;
  }
}
